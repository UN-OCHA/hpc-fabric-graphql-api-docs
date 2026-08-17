# Humanitarian Action Fabric GraphQL API

Use this API to read Humanitarian Action reference data, plans, projects,
emergencies, sectors, coordination entities, requirements, and organizations
through GraphQL.

!!! info "Current access route"
    Approved internal consumers currently connect to the authenticated Microsoft
    Fabric endpoint directly. A managed gateway and stable API URL are planned.
    Keep the endpoint in configuration rather than source code: when the URL is
    replaced, the documented GraphQL operations and variables are expected to
    remain compatible.

## Endpoint

```text
https://d1f25c25ab8d49ceb872d91de3d331ae.zd1.graphql.fabric.microsoft.com/v1/workspaces/d1f25c25-ab8d-49ce-b872-d91de3d331ae/graphqlapis/c6a47e35-e236-423f-ac01-96f088acbc3a/graphql
```

The endpoint is not a credential. Every request still requires a Microsoft
Entra access token and permission on the Fabric GraphQL API item.

## Choose how to use the API

| What you want to do | Start here |
| --- | --- |
| Sign in and run a query as yourself | [Quick start](getting-started/quick-start.md) |
| Use the ready-to-run Python client | [Python guide](clients/python.md) |
| Find and copy a tested query | [Query catalogue](queries/reference-data.md) |
| Build an ETL or backend service | [Application clients](clients/applications.md) |

## First query

This small query is a safe connectivity test:

```graphql
query CurrencyByCode($code: String!) {
  currencies(
    first: 100
    filter: { Code: { eq: $code } }
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

Variables:

```json
{
  "code": "USD"
}
```

## Responsible use

- Select only the fields needed by the consumer.
- Filter at the server; do not retrieve the full database and filter locally.
- Start with pages of 100 records. A page may be increased cautiously, but
  `first: 1000` is an operating ceiling for this API, not a target.
- Follow `hasNextPage` and `endCursor` instead of requesting an unbounded result.
- Paginate nested collections independently.
- Split deeply nested or slow operations into smaller requests.
- Do not run many large requests concurrently.

See [performance and limits](querying/performance-and-limits.md) before building
an extraction process.

