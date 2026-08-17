"""Small authenticated client for the Humanitarian Action Fabric GraphQL API."""

from __future__ import annotations

import os
import time
from typing import Any

import requests
from azure.identity import DeviceCodeCredential


DEFAULT_ENDPOINT = (
    "https://d1f25c25ab8d49ceb872d91de3d331ae.zd1.graphql.fabric."
    "microsoft.com/v1/workspaces/d1f25c25-ab8d-49ce-b872-d91de3d331ae/"
    "graphqlapis/c6a47e35-e236-423f-ac01-96f088acbc3a/graphql"
)

# This scope matches Fabric's generated interactive development sample used for
# the current internal access route. A formally registered interactive client
# should use the delegated GraphQLApi.Execute.All scope documented by Microsoft.
DEFAULT_USER_SCOPE = (
    "https://analysis.windows.net/powerbi/api/user_impersonation"
)


class GraphQLRequestError(RuntimeError):
    """Raised when an HTTP or GraphQL-level error is returned."""


class FabricGraphQLClient:
    """Execute GraphQL query operations under the signed-in user's identity."""

    def __init__(
        self,
        endpoint: str | None = None,
        scope: str | None = None,
        credential: DeviceCodeCredential | None = None,
    ) -> None:
        self.endpoint = endpoint or os.getenv("FABRIC_GRAPHQL_ENDPOINT", DEFAULT_ENDPOINT)
        self.scope = scope or os.getenv("FABRIC_GRAPHQL_USER_SCOPE", DEFAULT_USER_SCOPE)
        self.credential = credential or DeviceCodeCredential()
        self.session = requests.Session()

    def execute(
        self,
        query: str,
        variables: dict[str, Any] | None = None,
        *,
        retries: int = 3,
    ) -> dict[str, Any]:
        """Execute a read query and return its ``data`` object.

        A query-only retry is attempted for throttling and transient gateway or
        service failures. Do not reuse this retry behavior for mutations.
        """
        access_token = self.credential.get_token(self.scope).token
        headers = {
            "Authorization": f"Bearer {access_token}",
            "Accept": "application/json",
            "Content-Type": "application/json",
        }
        payload = {"query": query, "variables": variables or {}}

        for attempt in range(retries + 1):
            response = self.session.post(
                self.endpoint,
                json=payload,
                headers=headers,
                timeout=(10, 110),
            )

            if response.status_code in {429, 502, 503, 504} and attempt < retries:
                retry_after = response.headers.get("Retry-After")
                delay = float(retry_after) if retry_after else min(2**attempt, 8)
                time.sleep(delay)
                continue

            try:
                body = response.json()
            except ValueError as exc:
                raise GraphQLRequestError(
                    f"HTTP {response.status_code}: response was not valid JSON"
                ) from exc

            if not response.ok:
                raise GraphQLRequestError(
                    f"HTTP {response.status_code}: {body}"
                )

            if body.get("errors"):
                raise GraphQLRequestError(f"GraphQL errors: {body['errors']}")

            return body.get("data", {})

        raise GraphQLRequestError("Request failed after retry attempts")

