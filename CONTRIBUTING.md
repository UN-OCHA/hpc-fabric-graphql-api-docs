# Contributing

Keep consumer instructions centred on the APIM endpoint and subscription key.
Use short explanations, complete queries and a variables example for each query
that requires inputs. Keep real keys and response data out of commits.

## Checks

Install `requirements-docs.txt` in a documentation environment, then run:

```bash
python scripts/check_graphql.py
python -m mkdocs build --strict
```

The first command parses complete GraphQL code blocks and the sample `.graphql`
files. If you have a current GraphQL schema export, also run:

```bash
python scripts/check_graphql.py --schema /path/to/schema.graphql
```

SQL files in `api-schema/` cannot be used as the GraphQL schema argument.
Syntax checks do not confirm field availability or execute requests. Test changed
queries through the developer portal using an appropriate subscription.

When an exposed SQL view changes, review the affected queries and data rules.
Select only needed fields, handle list pagination and avoid counting an amount
more than once across multiple relationships.
