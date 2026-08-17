# Authentication

Every direct request has the same HTTP shape:

```http
POST <GRAPHQL_ENDPOINT>
Authorization: Bearer <SHORT_LIVED_ACCESS_TOKEN>
Content-Type: application/json
```

Choose the identity flow according to who or what is running the request.

| Scenario | Identity | Recommended credential |
| --- | --- | --- |
| Person running Python or a desktop tool | User principal | Interactive/device-code sign-in |
| Interactive application | Signed-in user via registered Entra client | Authorization code with PKCE |
| ETL, scheduled job, or backend service | Dedicated service principal or managed identity | Certificate, managed identity, or client credential |

## Interactive user access

The Python quick start uses Azure Identity's device-code flow. The user signs in
and completes MFA; the code receives a short-lived token. It does not require the
user's password or a client secret.

For a formally registered interactive client, Microsoft requires the delegated
Power BI Service permission `GraphQLApi.Execute.All` and this exact scope:

```text
https://analysis.windows.net/powerbi/api/GraphQLApi.Execute.All
```

The client is a public client and uses authorization code with PKCE. Do not give
it a client secret: a desktop, mobile, Postman, or browser client cannot protect
one.

## Unattended application access

Use a dedicated Microsoft Entra app registration/service principal. Service
principals do not use a delegated GraphQL permission. They request this Fabric
scope:

```text
https://api.fabric.microsoft.com/.default
```

The application must be granted Execute access on the Fabric GraphQL item. If
the API uses SSO, it must also have read access to the data source.

Prefer managed identity or certificate authentication where the hosting
platform supports it. If a client secret is necessary, store it in an approved
secret store, never in source code, configuration committed to Git, browser
code, or logs.

Follow Microsoft's
[service-principal setup guide](https://learn.microsoft.com/en-us/fabric/data-engineering/api-graphql-service-principal)
for tenant prerequisites and Fabric permissions.

## Endpoint configuration

Treat the endpoint as configuration in every client:

```text
FABRIC_GRAPHQL_ENDPOINT=<current endpoint>
```

This direct Fabric URL is temporary. When a stable gateway URL replaces it,
consumers should need to change only this setting; query documents and variables
are expected to remain the same.

## Never share

- client-secret values;
- bearer tokens;
- cached authentication files;
- database connection strings;
- a human user's password;
- production response data in tickets or public repositories.

