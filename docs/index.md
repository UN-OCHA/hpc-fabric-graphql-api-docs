# Humanitarian Action API

Query reference data, plans, projects, emergencies, sectors, coordination entities,
requirements and organizations using GraphQL through Azure API Management (APIM).

Endpoint: `https://hpc-apims.azure-api.net/v1`

Developer portal: <https://hpc-apims.developer.azure-api.net/>

## Start here

1. [Get a key and make your first request](getting-started/quick-start.md).
2. [Choose a client example](clients.md).
3. [Learn filters, variables and pagination](querying.md).

Every API request is an HTTP POST containing a GraphQL query and, when needed,
variables. Supply your subscription key in the `Ocp-Apim-Subscription-Key` header.

## Query catalogue

| Topic | Examples |
| --- | --- |
| [Reference data](queries/reference-data.md) | Currencies, countries, years, revision states |
| [Plans](queries/plans.md) | Plans by ID, year or project |
| [Projects and emergencies](queries/projects-and-emergencies.md) | Lists and plan filters |
| [Sectors and coordination](queries/sectors-and-coordination.md) | Plan/project sector and coordination links |
| [Requirements](queries/requirements.md) | Original/current amounts and sector joins |
| [Organizations](queries/organizations.md) | Names, classifications and hierarchy |

Read [data rules](reference/data-model.md) before summing costs or project amounts.
The [view reference](reference/schema.md) explains the existing `api-schema/` folder.
For request failures, use [troubleshooting](reference/errors.md).
