# Humanitarian Action Fabric GraphQL API

The Humanitarian Action Fabric GraphQL API provides read access to:

* Reference data, including currencies, countries, and years
* Plans and emergencies
* Projects
* Sectors and coordination entities
* Original and current requirements
* Organizations and organization classifications

This documentation is intended for approved internal users, developers, and application teams.

## Current access route

> **Important**
>
> Approved internal consumers currently connect directly to the authenticated Microsoft Fabric GraphQL endpoint.
>
> A managed API gateway and stable API URL are planned. Keep the endpoint URL in application configuration rather than hard-coding it throughout the application. When the gateway URL becomes available, consumers should only need to replace the configured endpoint. The GraphQL queries and variables are expected to remain unchanged.

## GraphQL endpoint

```text
https://d1f25c25ab8d49ceb872d91de3d331ae.zd1.graphql.fabric.microsoft.com/v1/workspaces/d1f25c25-ab8d-49ce-b872-d91de3d331ae/graphqlapis/c6a47e35-e236-423f-ac01-96f088acbc3a/graphql
```

The endpoint URL is not a credential. Every direct request requires:

1. A valid Microsoft Entra access token.
2. Permission to run the Fabric GraphQL API.
3. Data-source permission when the API uses single sign-on.

See [Access and permissions](getting-started/access.md) for details.

## Get started

Choose the guide that matches how you intend to use the API:

* **Run a query using your own Microsoft Entra identity:**
  Follow the [Quick start](getting-started/quick-start.md).

* **Use the API from Python:**
  Follow the [Python guide](clients/python.md).

* ~~**Use Postman or cURL:**~~
  ~~Follow the [Postman and cURL guide](clients/postman-and-curl.md).~~

* **Build an ETL, scheduled job, or backend service:**
  Follow the [C# and Node.js application guide](clients/applications.md).

* **Find a ready-to-use query:**
  Open the [Query catalogue](queries/reference-data.md).

* **Learn how filters and variables work:**
  Read [Filters and variables](querying/filters-and-variables.md).

* **Retrieve more than one page of data:**
  Read [Pagination](querying/pagination.md).

## First query

The following query returns the currency whose code is `USD`. It is a small and safe query for testing connectivity and permissions.

### GraphQL query

```graphql
query CurrencyByCode($code: String!) {
  currencies(
    first: 100
    filter: {
      Code: {
        eq: $code
      }
    }
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

### Variables

```json
{
  "code": "USD"
}
```

### Expected response structure

```json
{
  "data": {
    "currencies": {
      "items": [
        {
          "Id": 1,
          "Code": "USD"
        }
      ],
      "hasNextPage": false,
      "endCursor": null
    }
  }
}
```

The currency ID shown above is illustrative. Use the value returned by the API.

## Query catalogue

Ready-to-use queries are organized by subject:

* [Reference data](queries/reference-data.md)
* [Plans](queries/plans.md)
* [Projects and emergencies](queries/projects-and-emergencies.md)
* [Sectors and coordination entities](queries/sectors-and-coordination.md)
* [Requirements](queries/requirements.md)
* [Organizations](queries/organizations.md)

## Responsible use

Direct consumers share the Microsoft Fabric capacity with other applications and data workloads. Use the API carefully.

* Request only the fields required by the consumer.
* Apply filters in GraphQL instead of retrieving all records and filtering locally.
* Start with `first: 100`.
* Increase the page size gradually only after testing response time and response size.
* Do not use more than `first: 1000` without agreement from the API owner.
* Include `hasNextPage` and `endCursor` when retrieving collections.
* Continue subsequent pages using the `after` argument.
* Paginate nested collections independently.
* Split deeply nested queries into smaller operations.
* Avoid running many large requests concurrently.
* Cache stable reference data where appropriate.
* Retry throttling and transient server errors with controlled exponential backoff.
* Do not repeatedly retry invalid queries or permission errors.

Before creating an extraction process or ETL, read [Performance and limits](querying/performance-and-limits.md).

## Important data rules

Some data requires additional processing by the consuming application:

* Revision state 1 represents the original requirement.
* Revision state 2 represents the current requirement.
* If revision state 2 is absent, revision state 1 represents both original and current requirements.
* A coordination entity can be linked to multiple sectors.
* Repeating the complete coordination-entity requirement for every linked sector can overstate totals.
* Project requirements are project-level amounts and are not organization-specific allocations.

See [Data model and rules](reference/data-model.md) before calculating requirement totals.

## Authentication overview

Interactive users authenticate using their own Microsoft Entra identity.

Unattended applications, ETLs, scheduled jobs, and backend services must use a dedicated application identity such as a service principal or managed identity. They must not automate a human user's sign-in.

See [Authentication](getting-started/authentication.md) for the supported approaches.

## Troubleshooting

For authentication failures, permission errors, GraphQL validation errors, throttling, pagination problems, and internal execution errors, see [Errors and troubleshooting](reference/errors.md).

## External references

Microsoft Fabric and client-tool documentation is available under [External references](reference/external-links.md).
