# Humanitarian Action Fabric GraphQL API

Internal documentation and reusable client examples for the Humanitarian Action
Microsoft Fabric GraphQL API.

The documentation covers:

- access and authentication for people and unattended applications;
- Python, C#, Node.js, Postman, and cURL examples;
- filtering, variables, ordering, and cursor pagination;
- ready-to-use queries for plans, projects, emergencies, sectors, requirements,
  and organizations;
- current Fabric limits and API-specific data rules.

## Read the documentation

Start with [Documentation home](docs/index.md), then follow the
[quick start](docs/getting-started/quick-start.md).

The Markdown files render directly on GitHub. For a searchable documentation
site with navigation and copy buttons on every code block, run the Material for
MkDocs site locally:

```bash
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
python -m pip install -r requirements-docs.txt
mkdocs serve
```

Open <http://127.0.0.1:8000>. Build the static site with:

```bash
mkdocs build --strict
```

The included GitHub Pages workflow is manual. Before running it, an organization
administrator must confirm that the Pages site will be **private**. See
[Publishing this site](docs/reference/publishing.md).

## Run the Python example

```bash
cd examples/python
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
python -m pip install -r requirements.txt
python query_currency.py
```

The script uses an interactive Microsoft Entra sign-in and never stores a
password, client secret, or access token. See the
[Python guide](docs/clients/python.md) for configuration and troubleshooting.

## Repository layout

```text
docs/                  Documentation source
examples/python/       Interactive user example and reusable client
examples/csharp/       Unattended service-principal example
examples/node/         Unattended service-principal example
scripts/               Documentation validation utilities
.github/workflows/      Strict build check and manual Pages deployment
mkdocs.yml             Site navigation and theme configuration
```

## Security

Do not commit client secrets, bearer tokens, database connection strings, or
response data containing sensitive information. Keep unattended credentials in
an approved secret store and rotate them according to organizational policy.

## Updating the documentation

See [CONTRIBUTING.md](CONTRIBUTING.md). Query changes should be checked against
the current exported schema and tested in the Fabric GraphQL editor before
review. The package's 33 complete GraphQL examples were validated against the
schema supplied with the initial documentation set.
