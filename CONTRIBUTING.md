# Contributing

## Documentation changes

1. Create a branch for the change.
2. Update the relevant Markdown page.
3. Keep one documented purpose above every GraphQL example.
4. Prefer named operations and variables over copying IDs into a query.
5. Add `first`, `hasNextPage`, and `endCursor` to every list that might exceed
   one page.
6. Test the query in the Fabric GraphQL editor.
7. Run the checks below and open a pull request.

## Local checks

```bash
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
python -m pip install -r requirements-docs.txt
mkdocs build --strict
python scripts/check_graphql.py --schema /path/to/current-schema.graphql
```

`check_graphql.py` validates complete `graphql` code blocks against the exported
schema. Export the schema from the Fabric GraphQL item before running the check;
the generated schema is not kept as a second source of truth in this repository.
Small syntax fragments used only to explain a filter should use a different
fence such as `text` so they are not treated as complete operations.

## Query review checklist

- The operation has a descriptive name.
- External values are variables with the correct GraphQL types.
- Large root and nested collections are paginated.
- The query selects only fields the consumer needs.
- The nesting depth does not exceed the Fabric maximum.
- Requirement revision fallback and many-to-many duplication risks are handled
  by the client where applicable.
- No secret, token, or personal data appears in the example or its output.
