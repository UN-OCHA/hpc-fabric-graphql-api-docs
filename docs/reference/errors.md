# Troubleshooting

Record the HTTP status, operation name and error message. Check the GraphQL
`errors` array even if HTTP status is 200. Do not log or share subscription keys.

| Result | What to check |
| --- | --- |
| Missing key | Set `APIM_SUBSCRIPTION_KEY` in the process running the example. |
| HTTP 400 | Query syntax, field names, variable types and APIM validation policies. |
| HTTP 401/403 | Key value, active subscription, product/API access and other policies. |
| HTTP 404 | Endpoint and `/graphql/v1` path. |
| HTTP 429 | Request limits; honor `Retry-After` and reduce concurrency. |
| HTTP 5xx or timeout | Retry only a bounded number of times; test a smaller query. |
| HTTP 200 with `errors` | Inspect the error message and affected field path. |
| Empty list | Use a known ID/code; an empty result can be valid. |

## Start with the smallest query

```graphql
query TestPlans {
  plans(first: 5) {
    items {
      Id
      Name
    }
  }
}
```

Send `{ "query": "query TestPlans { plans(first: 5) { items { Id Name } } }" }`
with `Content-Type: application/json` and the subscription-key header.
Add fields and relationships gradually to isolate a failure.

The C# sample buffers JSON and sends `Content-Type: application/json` with a
known body length. This request format resolved the earlier C# validation failure;
the exact policy trigger was not isolated.

## Variable errors

Declare every referenced variable in the query header and supply each required
value in `variables`. For example, `$planId: Int!` needs an integer such as
`1202`, not a quoted string. Start pagination with `after: null`.

## Runtime or path errors

- **Node is not recognized:** install Node.js or add the extracted portable
  runtime folder to the current terminal's PATH.
- **Python cannot find the file:** run `python3 ./examples/python/example.py`
  from the repository root, followed by the query arguments.
- **Drush is not recognized:** Drush is optional. Enable the module through
  the Drupal site's Extend page. A running Drupal site and PHP are required.

If the small query still fails, send the API developers its query, variables,
HTTP status, error message and time of the request. Omit the key.
