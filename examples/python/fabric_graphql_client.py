"""Authenticated read-only client for the Humanitarian Action Fabric GraphQL API."""

from __future__ import annotations

import json
import os
import time
from pathlib import Path
from types import TracebackType
from typing import Any
from urllib.parse import urlparse

import requests
from azure.core.credentials import TokenCredential
from azure.core.exceptions import ClientAuthenticationError
from azure.identity import (
    AuthenticationRecord,
    InteractiveBrowserCredential,
    TokenCachePersistenceOptions,
)


DEFAULT_ENDPOINT = (
    "https://d1f25c25ab8d49ceb872d91de3d331ae.zd1.graphql.fabric."
    "microsoft.com/v1/workspaces/d1f25c25-ab8d-49ce-b872-d91de3d331ae/"
    "graphqlapis/c6a47e35-e236-423f-ac01-96f088acbc3a/graphql"
)

DEFAULT_TENANT_ID = "0f9e35db-544f-4f60-bdcc-5ea416e6dc70"

# This scope matches the Fabric-generated interactive development example used
# for the current internal access route. When a dedicated interactive Entra
# application is available, configure its client ID and use the delegated
# GraphQLApi.Execute.All scope documented by Microsoft.
DEFAULT_USER_SCOPE = (
    "https://analysis.windows.net/powerbi/api/user_impersonation"
)

DEFAULT_CACHE_NAME = "ha-fabric-graphql"
TRANSIENT_STATUS_CODES = {429, 500, 502, 503, 504}


class GraphQLRequestError(RuntimeError):
    """Raised when authentication, HTTP transport, or GraphQL execution fails."""


class FabricGraphQLClient:
    """Execute GraphQL read operations under a signed-in user's identity.

    The default credential opens a browser the first time authentication is
    required. Its encrypted persistent cache normally allows later processes to
    obtain or refresh tokens silently. Entra Conditional Access can still
    require the user to sign in again.

    A different Azure ``TokenCredential`` can be injected for application or
    managed-identity scenarios without changing the GraphQL request code.
    """

    def __init__(
        self,
        endpoint: str | None = None,
        scope: str | None = None,
        credential: TokenCredential | None = None,
        *,
        tenant_id: str | None = None,
        client_id: str | None = None,
        connect_timeout: float = 10,
        read_timeout: float = 110,
    ) -> None:
        self.endpoint = self._resolve_endpoint(endpoint)
        self.scope = (
            scope
            or os.getenv("FABRIC_GRAPHQL_USER_SCOPE")
            or DEFAULT_USER_SCOPE
        ).strip()

        if not self.scope:
            raise ValueError("The Fabric GraphQL token scope cannot be empty.")

        if connect_timeout <= 0 or read_timeout <= 0:
            raise ValueError("HTTP timeout values must be greater than zero.")

        self.timeout = (connect_timeout, read_timeout)
        self.session = requests.Session()
        self._owns_credential = credential is None
        self._interactive_credential: InteractiveBrowserCredential | None = None
        self._authentication_record: AuthenticationRecord | None = None
        self._authentication_record_path: Path | None = None

        if credential is not None:
            self.credential = credential
        else:
            resolved_tenant_id = (
                tenant_id
                or os.getenv("FABRIC_TENANT_ID")
                or DEFAULT_TENANT_ID
            ).strip()
            resolved_client_id = (
                client_id
                or os.getenv("FABRIC_GRAPHQL_CLIENT_ID")
                or ""
            ).strip()
            cache_name = (
                os.getenv("FABRIC_GRAPHQL_CACHE_NAME")
                or DEFAULT_CACHE_NAME
            ).strip()

            cache_options = TokenCachePersistenceOptions(name=cache_name)
            self._authentication_record_path = self._resolve_record_path()
            self._authentication_record = self._load_authentication_record(
                self._authentication_record_path
            )
            credential_options: dict[str, Any] = {
                "tenant_id": resolved_tenant_id,
                "cache_persistence_options": cache_options,
            }

            if self._authentication_record is not None:
                credential_options["authentication_record"] = (
                    self._authentication_record
                )

            # A client ID is optional for the current Fabric-generated
            # development flow. Supply it when the dedicated public-client Entra
            # application is available.
            if resolved_client_id:
                credential_options["client_id"] = resolved_client_id

            self._interactive_credential = InteractiveBrowserCredential(
                **credential_options
            )
            self.credential = self._interactive_credential

    @staticmethod
    def _resolve_record_path() -> Path:
        configured_path = os.getenv("FABRIC_GRAPHQL_AUTH_RECORD_PATH")
        if configured_path:
            return Path(configured_path).expanduser()

        if os.name == "nt":
            config_root = Path(os.getenv("LOCALAPPDATA") or Path.home())
        else:
            config_root = Path(
                os.getenv("XDG_CONFIG_HOME") or Path.home() / ".config"
            )

        return (
            config_root
            / "ha-fabric-graphql"
            / "authentication-record.json"
        )

    @staticmethod
    def _load_authentication_record(
        record_path: Path,
    ) -> AuthenticationRecord | None:
        if not record_path.is_file():
            return None

        try:
            serialized_record = record_path.read_text(encoding="utf-8")
            return AuthenticationRecord.deserialize(serialized_record)
        except (OSError, ValueError) as exc:
            raise ValueError(
                "The saved Fabric authentication record could not be read. "
                f"Delete '{record_path}' and run the query again."
            ) from exc

    @staticmethod
    def _save_authentication_record(
        record_path: Path,
        record: AuthenticationRecord,
    ) -> None:
        record_path.parent.mkdir(parents=True, exist_ok=True)
        temporary_path = record_path.with_suffix(".tmp")

        try:
            temporary_path.write_text(record.serialize(), encoding="utf-8")

            if os.name != "nt":
                temporary_path.chmod(0o600)

            temporary_path.replace(record_path)
        except OSError as exc:
            raise GraphQLRequestError(
                "Authentication succeeded, but the local authentication "
                f"record could not be saved to '{record_path}': {exc}"
            ) from exc

    def _get_access_token(self) -> str:
        """Get a token, creating the reusable user record on the first run."""
        try:
            if (
                self._interactive_credential is not None
                and self._authentication_record is None
            ):
                # authenticate() returns the non-secret account record required
                # to select the correct entry in the persistent token cache on
                # later process executions.
                self._authentication_record = (
                    self._interactive_credential.authenticate(
                        scopes=[self.scope]
                    )
                )

                if self._authentication_record_path is None:
                    raise GraphQLRequestError(
                        "Authentication record path was not configured."
                    )

                self._save_authentication_record(
                    self._authentication_record_path,
                    self._authentication_record,
                )

            return self.credential.get_token(self.scope).token
        except ClientAuthenticationError as exc:
            raise GraphQLRequestError(f"Authentication failed: {exc}") from exc

    @staticmethod
    def _resolve_endpoint(endpoint: str | None) -> str:
        resolved = (
            endpoint
            or os.getenv("FABRIC_GRAPHQL_ENDPOINT")
            or DEFAULT_ENDPOINT
        ).strip()
        parsed = urlparse(resolved)

        if parsed.scheme.lower() != "https" or not parsed.hostname:
            raise ValueError(
                "FABRIC_GRAPHQL_ENDPOINT must be a complete HTTPS URL."
            )

        if parsed.hostname.lower() in {"example", "example.com"}:
            raise ValueError(
                "FABRIC_GRAPHQL_ENDPOINT contains an example placeholder. "
                "Remove the environment variable or provide the real endpoint."
            )

        return resolved

    @staticmethod
    def _retry_delay(response: requests.Response | None, attempt: int) -> float:
        """Return Retry-After seconds when valid, otherwise exponential delay."""
        if response is not None:
            retry_after = response.headers.get("Retry-After")
            if retry_after:
                try:
                    return max(float(retry_after), 0)
                except ValueError:
                    # Retry-After can also be an HTTP date. Keep the example
                    # simple and use bounded exponential backoff in that case.
                    pass

        return min(2**attempt, 8)

    @staticmethod
    def _format_response_body(body: Any, limit: int = 4_000) -> str:
        try:
            rendered = json.dumps(body, ensure_ascii=False)
        except (TypeError, ValueError):
            rendered = str(body)

        if len(rendered) > limit:
            return f"{rendered[:limit]}... [truncated]"

        return rendered

    def execute(
        self,
        query: str,
        variables: dict[str, Any] | None = None,
        *,
        operation_name: str | None = None,
        retries: int = 3,
    ) -> dict[str, Any]:
        """Execute a GraphQL read operation and return its ``data`` object.

        Transient transport and service errors are retried. This client is
        intended for read operations. Do not reuse automatic retries for
        mutations without first considering duplicate-write risk.
        """
        if not query.strip():
            raise ValueError("The GraphQL query cannot be empty.")

        if retries < 0:
            raise ValueError("retries cannot be negative.")

        access_token = self._get_access_token()

        headers = {
            "Authorization": f"Bearer {access_token}",
            "Accept": "application/json",
            "Content-Type": "application/json",
        }
        payload: dict[str, Any] = {
            "query": query,
            "variables": variables if variables is not None else {},
        }

        if operation_name:
            payload["operationName"] = operation_name

        for attempt in range(retries + 1):
            response: requests.Response | None = None

            try:
                response = self.session.post(
                    self.endpoint,
                    json=payload,
                    headers=headers,
                    timeout=self.timeout,
                )
            except (requests.ConnectionError, requests.Timeout) as exc:
                if attempt < retries:
                    time.sleep(self._retry_delay(None, attempt))
                    continue

                raise GraphQLRequestError(
                    f"Request failed after {attempt + 1} attempts: {exc}"
                ) from exc
            except requests.RequestException as exc:
                raise GraphQLRequestError(f"HTTP request failed: {exc}") from exc

            if (
                response.status_code in TRANSIENT_STATUS_CODES
                and attempt < retries
            ):
                time.sleep(self._retry_delay(response, attempt))
                continue

            try:
                body = response.json()
            except ValueError as exc:
                response_preview = response.text[:1_000]
                raise GraphQLRequestError(
                    f"HTTP {response.status_code}: response was not valid JSON. "
                    f"Body: {response_preview}"
                ) from exc

            if not response.ok:
                raise GraphQLRequestError(
                    f"HTTP {response.status_code}: "
                    f"{self._format_response_body(body)}"
                )

            if not isinstance(body, dict):
                raise GraphQLRequestError(
                    "The GraphQL response was JSON but was not an object."
                )

            if body.get("errors"):
                raise GraphQLRequestError(
                    "GraphQL errors: "
                    f"{self._format_response_body(body['errors'])}"
                )

            data = body.get("data")
            if data is None:
                return {}

            if not isinstance(data, dict):
                raise GraphQLRequestError(
                    "The GraphQL response 'data' value was not an object."
                )

            return data

        raise GraphQLRequestError("Request failed after retry attempts.")

    def close(self) -> None:
        """Close resources owned by the client."""
        self.session.close()

        if self._owns_credential:
            close_credential = getattr(self.credential, "close", None)
            if callable(close_credential):
                close_credential()

    def __enter__(self) -> FabricGraphQLClient:
        return self

    def __exit__(
        self,
        exc_type: type[BaseException] | None,
        exc_value: BaseException | None,
        traceback: TracebackType | None,
    ) -> None:
        self.close()
