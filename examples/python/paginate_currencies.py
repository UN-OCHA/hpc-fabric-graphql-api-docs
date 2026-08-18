"""Demonstrate safe cursor pagination with an explicit record limit."""

from __future__ import annotations

import argparse
import json

from fabric_graphql_client import FabricGraphQLClient, GraphQLRequestError


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


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Retrieve currencies using controlled cursor pagination."
    )
    parser.add_argument(
        "--page-size",
        type=int,
        default=100,
        help="Records requested per page; default: 100.",
    )
    parser.add_argument(
        "--max-records",
        type=int,
        default=1_000,
        help="Maximum total records to retrieve; default: 1000.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    if not 1 <= args.page_size <= 1_000:
        print("--page-size must be between 1 and 1000.")
        return 2

    if args.max_records < 1:
        print("--max-records must be greater than zero.")
        return 2

    after: str | None = None
    seen_cursors: set[str] = set()
    all_items: list[dict[str, object]] = []
    has_more = False

    try:
        with FabricGraphQLClient() as client:
            while len(all_items) < args.max_records:
                remaining = args.max_records - len(all_items)
                first = min(args.page_size, remaining)

                data = client.execute(
                    QUERY,
                    {"first": first, "after": after},
                    operation_name="CurrenciesPage",
                )
                page = data.get("currencies")

                if not isinstance(page, dict):
                    raise GraphQLRequestError(
                        "Response did not contain a currencies page."
                    )

                items = page.get("items", [])
                if not isinstance(items, list):
                    raise GraphQLRequestError(
                        "The currencies page did not contain an items array."
                    )

                all_items.extend(items)
                has_more = bool(page.get("hasNextPage"))

                if not has_more:
                    break

                end_cursor = page.get("endCursor")
                if not isinstance(end_cursor, str) or not end_cursor:
                    raise GraphQLRequestError(
                        "API reported another page but returned no endCursor."
                    )

                if end_cursor in seen_cursors:
                    raise GraphQLRequestError(
                        "API returned a repeated endCursor; pagination stopped."
                    )

                seen_cursors.add(end_cursor)
                after = end_cursor
    except (GraphQLRequestError, ValueError) as error:
        print(f"Query failed: {error}")
        return 1

    result = {
        "items": all_items,
        "returnedCount": len(all_items),
        "hasNextPage": has_more,
        "stoppedAtConfiguredLimit": has_more
        and len(all_items) >= args.max_records,
    }
    print(json.dumps(result, indent=2, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
