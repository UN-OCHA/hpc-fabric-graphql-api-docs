# Humanitarian Action Fabric GraphQL API

Documentation and examples for using the Humanitarian Action Microsoft Fabric GraphQL API.

The API provides read-only access to reference data, plans, projects, emergencies, sectors, coordination entities, caseloads, requirements, organizations and related data.

## Start here

- [Documentation home](docs/index.md)
- [Quick start](docs/getting-started/quick-start.md)
- [Query catalogue](docs/queries/reference-data.md)
- [Authentication](docs/getting-started/authentication.md)
- [Performance and limits](docs/querying/performance-and-limits.md)

## Client guides

Instructions and examples are available for:

- [Python](docs/clients/python.md)
- [C#](docs/clients/csharp.md)
- [Node.js](docs/clients/node.md)
- [Postman](docs/clients/postman.md)
- [cURL](docs/clients/curl.md)
- [Applications and ETLs](docs/clients/applications.md)

## Run the Python example

### Windows PowerShell

```powershell
cd examples\python
py -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
python query_currency.py
```

### macOS or Linux

```bash
cd examples/python
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
python query_currency.py
```

The example opens Microsoft Entra sign-in in your browser and runs a small currency query under your identity.

## Responsible use

- Select only the fields you need.
- Apply filters in the GraphQL query.
- Start with pages of 100 records.
- Use `hasNextPage` and `endCursor` to retrieve additional pages.
- Avoid large, deeply nested or highly concurrent queries.

## Security

Do not commit or share:

- Client secrets
- Access tokens
- APIM subscription keys
- Database connection strings
- Sensitive API response data

Keep application credentials in an approved secret store.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) before changing the documentation or query examples.

Test query changes against the current GraphQL schema before submitting them for review.
