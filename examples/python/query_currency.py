"""Run a small authenticated currency query as the signed-in user."""

import json

from fabric_graphql_client import FabricGraphQLClient, GraphQLRequestError


QUERY = """
query CurrencyByCode($code: String!) {
  currencies(
    first: 100
    filter: { Code: { eq: $code } }
  ) {
    items {
      Id
      Code
    }
    hasNextPage
    endCursor
  }
}
"""


def main() -> None:
    client = FabricGraphQLClient()
    data = client.execute(QUERY, {"code": "USD"})
    print(json.dumps(data, indent=2))


if __name__ == "__main__":
    try:
        main()
    except GraphQLRequestError as error:
        raise SystemExit(f"Query failed: {error}") from error

