# Writing queries

Choose fields, apply filters and use variables for changing values. Request only
the data you need and page through lists.

## Fields, filters and variables

This query retrieves one plan using an ID supplied separately:

```graphql
query PlanSummary($planId: Int!) {
  plans(first: 1, filter: { Id: { eq: $planId } }) {
    items {
      Id
      Name
      PlanCode
    }
  }
}
```

Variables:

```json
{ "planId": 1202 }
```

Send the complete query text and variable object in the request body:

```json
{
  "query": "query PlanSummary($planId: Int!) { plans(first: 1, filter: { Id: { eq: $planId } }) { items { Id Name PlanCode } } }",
  "variables": { "planId": 1202 }
}
```

`Int!` means a required integer. Declare every variable in the operation header.
Field names are case-sensitive: use `Id` and `Name`, as shown in the schema.

| Operator | Purpose | Example filter fragment |
| --- | --- | --- |
| `eq`, `neq` | Equal / not equal | `Id: { eq: 1202 }` |
| `in` | Any listed value | `RevisionStateId: { in: [1, 2] }` |
| `contains` | Text contains a value | `Name: { contains: "ocha" }` |
| `startsWith`, `endsWith` | Text prefix / suffix | `PlanCode: { startsWith: "H" }` |
| `gt`, `gte`, `lt`, `lte` | Numeric comparisons | `CalendarYear: { gte: 2024 }` |
| `isNull` | Null check | `CalendarYear: { isNull: false }` |

Available operators depend on the field type. Use the developer portal schema
to check supported fields, arguments and relationships.

Fields in the same filter combine as AND. Use `or` for alternatives:

```text
filter: {
  or: [
    { Name: { contains: "ocha" } }
    { Id: { eq: 123 } }
  ]
}
```

The catalogue also shows filters through relationships, such as plans by year.

## Pagination

```graphql
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
```

First-page variables:

```json
{ "first": 100, "after": null }
```

1. Read `data.currencies.items`.
2. If `hasNextPage` is true, send its `endCursor` as the next `after` value.
3. Repeat until `hasNextPage` is false or your record limit is reached.

Treat cursors as opaque values; do not build them yourself. Each nested collection
has its own cursor. Paging the root does not retrieve later pages of nested lists.
If a nested list has another page, query that relationship for its parent separately.

## Keep requests small

- Start with `first: 100`; use smaller pages for wide or nested results.
- The samples accept page sizes up to 1000 as a client guardrail, not a guaranteed service limit.
- Filter by plan, ID, code or year rather than fetching everything.
- Select only needed fields and split large nested operations.
- Limit concurrent calls and cache stable reference values where useful.
- Check HTTP status and the GraphQL `errors` array, even with HTTP 200.

Sample clients have a 110-second timeout and do not retry automatically. APIM and
the service may impose shorter timeouts and other limits. Ask the API developers
about limits before building a large extraction.

For production read requests, use bounded retries for transient failures and
honor `Retry-After`; do not retry invalid queries or invalid keys repeatedly.
