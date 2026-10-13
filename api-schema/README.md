# GraphQL API schema

[api_schema.graphql](api_schema.graphql) is an exported snapshot of the
Humanitarian Action GraphQL API. It describes what a client can query: operations,
fields, types, filters, sorting and relationships. You can read it in a text editor
or use it with a GraphQL editor for field suggestions and query validation.

Note: The developer portal includes a visual tool for exploring the API.

## Find what you need

1. Search for `type Query` to find an operation, such as `plans`. Its arguments
   include `first` (page size), `after` (next page), `filter` and `orderBy`.
2. Search for `type Plan` to see fields you can request, such as `Id`, `Name`
   and `StartDate`, as well as related objects.
3. Search for `input PlanFilterInput` to see fields you can filter on. For
   example, `Id` uses `IntFilterInput`, which supports `eq`.
4. Search for `type PlanConnection` to see the returned `items`, `hasNextPage`
   and `endCursor` fields used for pagination.

For example, these definitions allow this query:

```graphql
query {
  plans(first: 5, filter: { Id: { eq: 1200 } }) {
    items { Id Name StartDate }
    hasNextPage
    endCursor
  }
}
```

Use the [quick start](../docs/getting-started/quick-start.md) for the API URL,
access and sending a request. The [query examples](../docs/queries/plans.md)
show common uses. The schema defines field structure; the [data rules](../docs/reference/data-model.md)
explain what values mean and how to calculate totals.

This file is a snapshot. When the API changes, use a new export to check current
fields. If you need help, send the API team your query and error message, without
including your subscription key.
