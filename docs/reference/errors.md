# Errors and troubleshooting

Always capture the HTTP status, GraphQL operation name, response headers,
duration, and top-level `errors` array. Never log bearer tokens or client-secret
values.

## Common responses

| Symptom | Likely cause | Action |
| --- | --- | --- |
| `400` validation error | Invalid field, argument, variable, depth, or policy limit | Test the smallest query; check the current schema and variable declarations |
| `401 Unauthorized` | Missing, expired, or wrong-audience token | Sign in again; confirm the scope used for the user or service principal |
| `403 Forbidden` | Identity lacks API or SSO data-source permission | Check **Run Queries and Mutations** and the connection mode |
| `429 Too Many Requests` | Fabric capacity or gateway throttling | Honor `Retry-After`; reduce concurrency and page size |
| `5xx` or internal execution error | Transient service issue or query/relationship execution problem | Retry a bounded number of times; then isolate the failing relationship |
| HTTP `200` with `errors` | GraphQL execution or resolver failure | Treat as failure; inspect `errors[].message`, `path`, and extensions |

## “The variable ... does not exist”

Every referenced variable must be declared in the operation header:

```graphql
query Plans($after: String) {
  plans(first: 100, after: $after) {
    items {
      Id
    }
    hasNextPage
    endCursor
  }
}
```

Send first-page variables as `{ "after": null }`, then send the returned
`endCursor` on subsequent requests.

## Internal error on a nested relationship

The schema can describe a relationship that fails for a particular data shape
or becomes too expensive when several one-to-many paths are nested. Diagnose it
systematically:

1. Run only the root entity and scalar fields.
2. Add one relationship at a time.
3. Add a small `first` value to every relationship.
4. Move aggregation to a separate root query.
5. Return join keys and combine the two result sets in the client.
6. Confirm the query stays below the ten-level depth limit.

The documented sector-requirement query follows this split-query pattern.

## Query works in Fabric but not through another gateway

A gateway can impose stricter request-size, depth, rate, quota, or schema
validation policies than Fabric. Compare the direct endpoint response with the
gateway response and inspect gateway tracing. Do not weaken a production policy
until the query's actual size, depth, and cost are understood.

## Browser does not open for Python

The example intentionally uses device-code authentication. Read the URL and code
printed in the terminal, open the URL manually, enter the code, and sign in.

## Access works for an admin but not a consumer

Administrators often have broad workspace and database rights that hide missing
consumer permissions. Test with the consumer's identity and check both the
GraphQL item permission and, for SSO, the underlying data-source permission.

