"""Check query syntax, and optionally validate queries against a schema export."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

from graphql import build_schema, parse, validate

ROOT = Path(__file__).resolve().parents[1]
FENCE = re.compile(r"```graphql\s*\n(.*?)```", re.DOTALL)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--schema", type=Path, help="Optional GraphQL schema export (not SQL views)")
    args = parser.parse_args()

    schema = None
    if args.schema is not None:
        try:
            schema = build_schema(args.schema.read_text(encoding="utf-8"))
        except Exception as error:
            print(f"Cannot load schema: {error}", file=sys.stderr)
            return 2

    sources = []
    for path in sorted((ROOT / "docs").rglob("*.md")):
        for number, query in enumerate(FENCE.findall(path.read_text(encoding="utf-8")), 1):
            sources.append((f"{path.relative_to(ROOT)}: block {number}", query))
    for path in sorted((ROOT / "examples").rglob("*.graphql")):
        sources.append((str(path.relative_to(ROOT)), path.read_text(encoding="utf-8")))

    if not sources:
        print("No GraphQL queries found.", file=sys.stderr)
        return 1

    failed = 0
    for label, query in sources:
        try:
            document = parse(query)
            errors = validate(schema, document) if schema is not None else []
        except Exception as error:
            errors = [error]
        if errors:
            failed += 1
            print(label, file=sys.stderr)
            for error in errors:
                print(f"  {error}", file=sys.stderr)

    if failed:
        print(f"Failed: {failed} of {len(sources)} queries", file=sys.stderr)
        return 1

    check = "syntax and schema" if schema is not None else "syntax only"
    print(f"Checked {len(sources)} queries ({check}). No API requests were made.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
