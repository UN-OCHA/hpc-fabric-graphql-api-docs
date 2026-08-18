# Python

The repository includes an interactive example for users and a reusable GraphQL client with conservative retries for read operations.

## Install

### Windows PowerShell

```powershell
cd examples\python
py -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
```

### macOS or Linux

```bash
cd examples/python
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
```

## Run the connectivity test

```bash
python query_currency.py
```

`DeviceCodeCredential` prints a URL and code in the terminal. Complete the Microsoft sign-in using an account that has access to the API. This authentication flow does not store a password or client secret.

The current interactive development sample requests the following scope:

```text
https://analysis.windows.net/powerbi/api/user_impersonation
```

For a registered interactive application, use Microsoft's documented delegated scope instead:

```text
https://analysis.windows.net/powerbi/api/GraphQLApi.Execute.All
```

Keeping the URL in configuration means that a future gateway migration will require only a configuration change rather than a code change.

## Use another operation

Import `FabricGraphQLClient`, then pass it a named query and its variables:

```python
from fabric_graphql_client import FabricGraphQLClient

query = """
query PlanById($planId: Int!) {
  plans(first: 1, filter: { Id: { eq: $planId } }) {
    items {
      Id
      Name
      PlanCode
    }
  }
}
"""

client = FabricGraphQLClient()
data = client.execute(query, {"planId": 1202})

print(data)
```

Variables keep values separate from the query document. This simplifies query reuse and avoids unsafe string construction.

## Paginate results

Run the following example to retrieve all currency records using cursor-based pagination:

```bash
python paginate_currencies.py
```

The pagination loop:

1. Reads the current page's `endCursor`.
2. Sends that value as the next request's `after` variable.
3. Continues while `hasNextPage` is `true`.
4. Stops when `hasNextPage` is `false`.

## Error behavior

GraphQL can return an HTTP `200` response containing an `errors` array. The reusable client checks both the HTTP status code and GraphQL errors.

For read requests, it retries only the following temporary HTTP errors:

- `429` — Too Many Requests
- `502` — Bad Gateway
- `503` — Service Unavailable
- `504` — Gateway Timeout

When the server supplies a `Retry-After` header, the client uses it to determine how long to wait before retrying.

Do not log access tokens. Do not copy the example's retry behavior to GraphQL mutations.
