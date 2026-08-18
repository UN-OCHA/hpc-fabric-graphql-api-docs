"""Query one currency by code using the signed-in user's Fabric access."""

from __future__ import annotations

import argparse
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


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Return currencies matching a currency code."
    )
    parser.add_argument(
        "code",
        nargs="?",
        default="USD",
        help="Currency code to query; default: USD.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    variables = {"code": args.code.strip().upper()}

    if not variables["code"]:
        raise SystemExit("Currency code cannot be empty.")

    try:
        with FabricGraphQLClient() as client:
            data = client.execute(
                QUERY,
                variables,
                operation_name="CurrencyByCode",
            )
    except (GraphQLRequestError, ValueError) as error:
        print(f"Query failed: {error}")
        return 1

    print(json.dumps(data, indent=2, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
