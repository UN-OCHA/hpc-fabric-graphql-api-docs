"""Demonstrate cursor pagination without requesting an unbounded result."""

import json

from fabric_graphql_client import FabricGraphQLClient


QUERY = """
query CurrenciesPage($first: Int!, $after: String) {
  currencies(first: $first, after: $after, orderBy: { Code: ASC }) {
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
    after = None
    all_items = []

    while True:
        data = client.execute(QUERY, {"first": 100, "after": after})
        page = data["currencies"]
        all_items.extend(page["items"])

        if not page["hasNextPage"]:
            break

        after = page["endCursor"]
        if not after:
            raise RuntimeError("API reported another page but returned no endCursor")

    print(json.dumps(all_items, indent=2))


if __name__ == "__main__":
    main()

