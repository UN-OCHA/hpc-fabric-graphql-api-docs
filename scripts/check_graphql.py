"""Validate complete GraphQL code blocks in the documentation against a schema."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

from graphql import build_schema, parse, validate


GRAPHQL_FENCE = re.compile(r"```graphql\s*\n(.*?)```", re.DOTALL)
COMPLETE_OPERATION = re.compile(r"^\s*(query|mutation|subscription|fragment)\b")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--schema",
        type=Path,
        default=Path("schema.graphql"),
        help="Path to the schema exported from the Fabric GraphQL item",
    )
    parser.add_argument(
        "--docs",
        type=Path,
        default=Path("docs"),
        help="Documentation directory",
    )
    args = parser.parse_args()

    if not args.schema.is_file():
        print(f"Schema not found: {args.schema}", file=sys.stderr)
        print("Export the current Fabric schema or pass --schema PATH.", file=sys.stderr)
        return 2

    schema = build_schema(args.schema.read_text(encoding="utf-8"))
    checked = 0
    failed = 0

    for markdown_path in sorted(args.docs.rglob("*.md")):
        text = markdown_path.read_text(encoding="utf-8")
        for block_number, source in enumerate(GRAPHQL_FENCE.findall(text), 1):
            if not COMPLETE_OPERATION.match(source):
                continue
            checked += 1
            try:
                document = parse(source)
                errors = validate(schema, document)
            except Exception as error:  # parser/build errors have useful messages
                errors = [error]

            if errors:
                failed += 1
                print(f"{markdown_path}: GraphQL block {block_number}")
                for error in errors:
                    print(f"  - {error}")

    if failed:
        print(f"Failed: {failed} of {checked} complete GraphQL blocks")
        return 1

    print(f"Validated {checked} complete GraphQL blocks")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

