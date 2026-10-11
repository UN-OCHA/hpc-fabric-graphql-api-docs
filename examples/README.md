# Humanitarian Action API examples

Simple C#, Node.js, Python and Drupal (PHP) examples using GraphQL through Azure API Management.

API endpoint: `https://hpc-apims.azure-api.net/v1`

Developer portal: <https://hpc-apims.developer.azure-api.net/>

## Get a subscription key

Register on the developer portal with any valid email address and a password,
confirm your email if prompted, and subscribe to the API product. If approval is
required, wait for approval, then copy the subscription key from your profile.
Alternatively, ask the API developers for a key or use the key shared with you.

API requests use the `Ocp-Apim-Subscription-Key` header. Keep real keys out of Git.

## Choose an example

| Folder | Requirements | Instructions |
| --- | --- | --- |
| `csharp/` | .NET 10 SDK | [C#](csharp/README.md) |
| `node/` | Node.js 22.12+; no npm packages | [Node.js](node/README.md) |
| `python/` | Python 3.10+; no pip packages | [Python](python/README.md) |
| `drupal/` | Existing Drupal 10.3+/11 site with its supported PHP version | [Drupal](drupal/README.md) |

Keep the folder structure: C#, Node.js and Python load files from `queries/`.
The Drupal module has its own query copies so it can be installed separately.

## Configure the terminal and server examples

Set the subscription key in the terminal where you run the examples.

PowerShell (Windows):

```powershell
$env:APIM_SUBSCRIPTION_KEY = 'replace-with-your-subscription-key'
```

Bash (Linux/macOS):

```bash
export APIM_SUBSCRIPTION_KEY='replace-with-your-subscription-key'
```

The endpoint defaults to `https://hpc-apims.azure-api.net/v1`.
Set `APIM_ENDPOINT` only if you need a different endpoint.
For Drupal, configure these variables in the web/PHP process environment;
setting them in an unrelated terminal does not configure the website.

## Run from the examples folder

```powershell
# C#
dotnet run --project ./csharp/HaApimExamples.csproj -- currency USD
dotnet run --project ./csharp/HaApimExamples.csproj -- plan 1202
dotnet run --project ./csharp/HaApimExamples.csproj -- currencies 2 5

# Node.js
node ./node/example.mjs currency USD
node ./node/example.mjs plan 1202
node ./node/example.mjs currencies 2 5

# Python
python3 ./python/example.py currency USD
python3 ./python/example.py plan 1202
python3 ./python/example.py currencies 2 5
```

On Windows, use `py` or `python` if `python3` is unavailable.
The pagination example requests two records per page, up to five records total.
C#, Node.js and Python print JSON; the Drupal module provides a form and table.
Drupal requires a running site; it cannot run directly from this folder.

## Queries

| Example | Query file | Variables |
| --- | --- | --- |
| Currency by code | [currency-by-code.graphql](queries/currency-by-code.graphql) | `code`, default `USD` |
| Plan by ID | [plan-by-id.graphql](queries/plan-by-id.graphql) | `planId`, default `1202` |
| Paginated currencies | [currencies-page.graphql](queries/currencies-page.graphql) | `first` and `after` |

All queries POST JSON containing `query` and `variables` to the same endpoint.
Read records from `data.currencies.items` or `data.plans.items`.
The examples check HTTP failures and GraphQL errors, including errors returned
with HTTP 200. Pagination follows `endCursor` until there are no more pages or
the configured record limit is reached. Each page is a separate API call.

The plan query requests up to 10 periods and 10 top-level locations;
it does not paginate those nested collections.

## Troubleshooting

| Result | Check |
| --- | --- |
| Missing key | Set `APIM_SUBSCRIPTION_KEY` in the process running the example. |
| HTTP 400 or GraphQL errors | Query fields, variable types and API validation policies. |
| HTTP 401/403 | Subscription key, approval and access to the API. |
| HTTP 404 | Endpoint and `/v1` path. |
| HTTP 429 | Request limits; follow the response or API owner's guidance. |
| Empty result | Try a known currency code or plan ID. |

Requests have a 110-second client timeout and do not retry automatically.
These examples do not require browser CORS configuration.
Review staged files before committing; the included `.gitignore` excludes
local secrets, dependencies and build output.
