# Humanitarian Action GraphQL API

Read-only access to humanitarian planning and response data.

API endpoint: `https://api.humanitarianaction.info/graphql/v1`

Developer portal and documentation: <https://developer-api.humanitarianaction.info>

## Get access

1. OCHA users: sign in to the developer portal with your `@un.org` account using Microsoft Entra ID.
2. External users: sign up on the developer portal with your email address and a password.
3. Ask the API team for access. We will add you to the API product and give you a subscription key.

Send the key in the `Ocp-Apim-Subscription-Key` header. Keep it out of source code and public pages.

## Try the API

Follow the [quick start](docs/getting-started/quick-start.md) to send a small GraphQL request.

Or run one of the [C#, Node.js, Python and Drupal examples](examples/README.md). For example, from the repository root:

```powershell
$env:APIM_SUBSCRIPTION_KEY = 'your-subscription-key'
python ./examples/python/example.py currency USD
```

On Linux/macOS, use `export APIM_SUBSCRIPTION_KEY='your-subscription-key'` and `python3`.

## Find a query

- [Reference data](docs/queries/reference-data.md): currencies, countries, years and revision states
- [Plans](docs/queries/plans.md): ID, year and project filters
- [Projects and emergencies](docs/queries/projects-and-emergencies.md)
- [Sectors and coordination entities](docs/queries/sectors-and-coordination.md)
- [Requirements](docs/queries/requirements.md): original/current values and sector joins
- [Organizations](docs/queries/organizations.md): names, classifications and hierarchy

Read the [data rules](docs/reference/data-model.md) before calculating totals.

## Explore the API schema

The [GraphQL schema](api-schema/api_schema.graphql) lists the queries, fields,
filters and relationships available in the API. Use it to check field names and
types when writing a query or configuring editor autocomplete.

Start with the [schema guide](api-schema/README.md). The tested examples above
are the quickest way to make your first request.
