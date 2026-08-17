# C# and Node.js applications

Scheduled jobs, ETLs, and backend services must use a dedicated application
identity. Do not automate an interactive human sign-in and do not reuse a human
account.

## Required setup

Before running either example, an administrator must:

1. Create or approve a Microsoft Entra app registration/service principal for
   the application.
2. Ensure Fabric tenant settings allow service principals to use Fabric APIs.
3. Grant that service principal **Run Queries and Mutations** on this GraphQL API
   item.
4. If the API uses SSO, grant the service principal minimum read access to the
   underlying data source.

Service principals do not need a delegated `GraphQLApi.Execute.All` permission.
They request:

```text
https://api.fabric.microsoft.com/.default
```

See Microsoft's
[service-principal guide](https://learn.microsoft.com/en-us/fabric/data-engineering/api-graphql-service-principal).

## Credential configuration

Both examples use Azure Identity's `DefaultAzureCredential`. On an Azure host,
prefer a managed identity. In an environment using a service-principal secret,
inject these settings at runtime:

```text
AZURE_TENANT_ID=<tenant ID>
AZURE_CLIENT_ID=<application/client ID>
AZURE_CLIENT_SECRET=<secret value>
FABRIC_GRAPHQL_ENDPOINT=<GraphQL endpoint>
```

Only the secret value is a credential. Do not commit it, place it in browser
code, or print it. Prefer a certificate or managed identity where supported.

## C#

Requires .NET 8 or later.

```bash
cd examples/csharp
dotnet restore
dotnet run
```

The example uses `DefaultAzureCredential`, requests a Fabric token, sends a
query with variables, checks the HTTP status, and checks GraphQL's `errors`
array.

## Node.js

Requires a current Node.js LTS release.

```bash
cd examples/node
npm install
npm start
```

The example uses the built-in `fetch` implementation and a 110-second client
timeout, slightly above Fabric's 100-second request limit.

## Production checklist

- Keep the endpoint in configuration so the gateway URL can replace it later.
- Use one application identity per production consumer.
- Restrict the identity to this API and its required read source.
- Store credentials in an approved secret store and rotate them.
- Cache stable results where appropriate.
- Bound concurrency; do not launch one request per record.
- Retry only transient failures (`429`, `502`, `503`, `504`) with exponential
  backoff and jitter, honoring `Retry-After`.
- Set a maximum retry count and log request IDs, status, duration, and operation
  name without logging tokens or sensitive response bodies.
- Page through large results and checkpoint ETL progress.

