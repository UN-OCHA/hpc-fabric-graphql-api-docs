# Python

The repository includes an interactive example for people and a reusable
GraphQL client with conservative retries for read operations.

## Install

=== "Windows PowerShell"

    ```powershell
    cd examples\python
    py -m venv .venv
    .\.venv\Scripts\Activate.ps1
    python -m pip install -r requirements.txt
    ```

=== "macOS or Linux"

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

`DeviceCodeCredential` prints a URL and code in the terminal. Complete the
Microsoft sign-in with the account that has API access. This flow does not store
a password or client secret.

The current interactive development sample requests:

```text
https://analysis.windows.net/powerbi/api/user_impersonation
```

For a registered interactive application, use Microsoft's documented delegated
scope instead:

```text
https://analysis.windows.net/powerbi/api/GraphQLApi.Execute.All
```

## Configure the endpoint

The current endpoint is the example's default. Override it without editing code:

=== "Windows PowerShell"

    ```powershell
    $env:FABRIC_GRAPHQL_ENDPOINT = "https://example/graphql"
    python query_currency.py
    ```

=== "macOS or Linux"

    ```bash
    export FABRIC_GRAPHQL_ENDPOINT="https://example/graphql"
    python query_currency.py
    ```

Keeping the URL in configuration makes the future gateway migration a setting
change rather than a code change.

## Use another operation

Import `FabricGraphQLClient`, then pass a named query and variables:

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

Variables keep values separate from the query document, simplify reuse, and
avoid unsafe string construction.

## Paginate

Run `python paginate_currencies.py` for a complete cursor loop. The loop sends
the preceding page's `endCursor` as the next request's `after` value and stops
when `hasNextPage` is false.

## Error behavior

GraphQL can return HTTP `200` with an `errors` array. The reusable client checks
both the HTTP status and GraphQL errors. It retries only read requests returning
`429`, `502`, `503`, or `504`, using `Retry-After` when supplied.

Do not log access tokens. Do not copy the example's retry behavior to mutations.

