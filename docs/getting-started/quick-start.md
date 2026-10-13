# Quick start

## 1. Obtain a subscription key

OCHA users sign in at <https://developer-api.humanitarianaction.info> with their
`@un.org` account using Microsoft Entra ID. External users sign up with their
email address and a password. Subscribe to the API product.
If approval is required, wait for approval, then copy the key from your profile.
Alternatively, ask the API developers for a key or use the key shared with you.

The portal password is for signing in to the portal. API requests use the key.

## 2. Make a small request

Use this endpoint and headers in your HTTP client:

```http
POST https://api.humanitarianaction.info/graphql/v1
Content-Type: application/json
Ocp-Apim-Subscription-Key: <your-subscription-key>
```

Body:

```json
{
  "query": "query { plans(first: 5) { items { Id Name } } }"
}
```

This returns up to five plans. An illustrative response is:

```json
{
  "data": {
    "plans": {
      "items": [
        { "Id": 1202, "Name": "Example plan" }
      ]
    }
  }
}
```

Use the IDs and names actually returned by the API.
This is a connectivity test; use [pagination](../querying.md#pagination) for a full list.

## 3. Try Python

Download or clone the whole repository, install Python 3.10+ and open a terminal
at the repository root. No pip packages are needed for this client.

PowerShell:

```powershell
$env:APIM_SUBSCRIPTION_KEY = 'replace-with-your-subscription-key'
python3 ./examples/python/example.py currency USD
python3 ./examples/python/example.py plan 1202
python3 ./examples/python/example.py currencies 2 5
```

On Windows, use `py` or `python` if `python3` is unavailable.

Bash:

```bash
export APIM_SUBSCRIPTION_KEY='replace-with-your-subscription-key'
python3 ./examples/python/example.py currency USD
python3 ./examples/python/example.py plan 1202
python3 ./examples/python/example.py currencies 2 5
```

The last command requests two currencies per page and stops at five records.
See [client examples](../clients.md) for C#, Node.js and Drupal.

## 4. Change the query

Copy an operation from the [query catalogue](../queries/reference-data.md).
Send the query text as `query` and its values as `variables` in the JSON body.
All operations use the same `/graphql/v1` endpoint.

Keep the key in your process environment or hosting platform's secret settings.
Do not put it in committed source files, published JavaScript or request URLs.

Reference: [APIM subscriptions](https://learn.microsoft.com/azure/api-management/api-management-subscriptions).
