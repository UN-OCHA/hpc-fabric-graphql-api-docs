# Pagination

Every generated Fabric list connection supports cursor pagination.

- `first` is the maximum number of records requested for this page.
- `hasNextPage` states whether another page exists.
- `endCursor` is the opaque continuation token returned for the next request.
- `after` accepts the preceding page's `endCursor`.

## Reusable operation

```graphql
query CurrenciesPage($first: Int!, $after: String) {
  currencies(
    first: $first
    after: $after
    orderBy: { Code: ASC }
  ) {
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
{
  "first": 100,
  "after": null
}
```

Example response metadata:

```json
{
  "hasNextPage": true,
  "endCursor": "ABC123"
}
```

Next-page variables:

```json
{
  "first": 100,
  "after": "ABC123"
}
```

Repeat with the newest cursor until `hasNextPage` is `false`. Treat the cursor as
opaque: do not decode, edit, persist indefinitely, or construct it yourself.

## Nested pagination

Every nested collection has its own page boundary and cursor. In this example,
`plans` and each plan's `project` collection are separate connections:

```graphql
query PlansAndProjects($after: String) {
  plans(first: 20, after: $after, orderBy: { StartDate: DESC }) {
    items {
      Id
      Name
      project(first: 50, orderBy: { Id: ASC }) {
        items {
          Id
          ProjectCode
          Name
        }
        hasNextPage
        endCursor
      }
    }
    hasNextPage
    endCursor
  }
}
```

The root cursor cannot fetch another nested project page. If a nested
`hasNextPage` is true, issue a smaller query scoped to that parent and paginate
that relationship independently.

## Recommended page sizes

- Start with `first: 100`.
- For narrow rows and tested workloads, increase gradually.
- Do not use more than `first: 1000` in this API without agreement from the API
  owner. This is an operating guardrail, not a Microsoft-documented hard page
  maximum.
- Use smaller pages for wide objects, nested relationships, or slow queries.

The Python example includes a complete pagination loop in
`examples/python/paginate_currencies.py`.

