# Humanitarian Action API

Documentation, GraphQL queries and working client examples for the Humanitarian Action API.

Endpoint: `https://hpc-apims.azure-api.net/v1`

Developer portal: <https://hpc-apims.developer.azure-api.net/>

## Get started

1. Register on the developer portal with any valid email address and a password.
2. Subscribe to the API product and obtain a subscription key; approval may be required.
   Alternatively, ask the API developers for a key or use the key shared with you.
3. Follow the [quick start](docs/getting-started/quick-start.md).

Send the key in the `Ocp-Apim-Subscription-Key` header. Keep real keys out of Git.

## What is in this repository?

| Folder | Contents |
| --- | --- |
| `docs/` | Setup, query catalogue, data rules and troubleshooting |
| `examples/` | C#, Node.js, Python and Drupal (PHP) samples |
| `api-schema/` | SQL view definitions for the objects exposed by the GraphQL API; maintained separately and retained in your existing checkout |
| `scripts/` | GraphQL syntax and optional schema validation |
| `.github/workflows/` | Documentation checks and manual GitHub Pages publishing |

The `api-schema/` folder is not included in this package. Keep your existing copy.

## Run an example

From the repository root in PowerShell:

```powershell
$env:APIM_SUBSCRIPTION_KEY = 'replace-with-your-subscription-key'

# Choose the runtime you have installed.
dotnet run --project ./examples/csharp/HaApimExamples.csproj -- currency USD
node ./examples/node/example.mjs currency USD
python3 ./examples/python/example.py currency USD
```

On Windows, `py` or `python` can be used instead of `python3`.
On Linux/macOS, set the key with `export APIM_SUBSCRIPTION_KEY='replace-with-your-subscription-key'`.

See [example instructions](examples/README.md) for plan queries, pagination and Drupal setup.
Node.js and Python need no extra packages. Drupal needs an existing Drupal site.

## Find a query

- [Reference data](docs/queries/reference-data.md): currencies, countries, years and revision states
- [Plans](docs/queries/plans.md): ID, year and project filters
- [Projects and emergencies](docs/queries/projects-and-emergencies.md)
- [Sectors and coordination entities](docs/queries/sectors-and-coordination.md)
- [Requirements](docs/queries/requirements.md): original/current values and sector joins
- [Organizations](docs/queries/organizations.md): names, classifications and hierarchy

Read [data rules](docs/reference/data-model.md) before calculating totals.

## Preview the documentation website

The Markdown can be read directly on GitHub. Website preview is optional.

```powershell
python -m venv .venv
./.venv/Scripts/python.exe -m pip install -r requirements-docs.txt
./.venv/Scripts/python.exe -m mkdocs serve
```

Open <http://127.0.0.1:8000>. Linux/macOS uses `.venv/bin/python`.
See [publishing instructions](docs/reference/publishing.md) for GitHub Pages.

## Update the existing repository

Replace `docs/`, `examples/`, `scripts/` and `.github/workflows/` with the versions
in this package, then replace the included root files. Replacing the folders
removes obsolete pages rather than leaving them beside the new documentation.
Keep the existing `.git/` and `api-schema/` folders. Review the changes before committing.

See [CONTRIBUTING.md](CONTRIBUTING.md) for checks before a pull request.
