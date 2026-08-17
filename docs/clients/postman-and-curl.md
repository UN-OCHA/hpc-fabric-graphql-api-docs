# Postman and cURL

## Postman with a signed-in user

Direct user authentication in Postman requires an approved Microsoft Entra
public-client application. Ask the API owner for its tenant ID and client ID.
These are identifiers, not secrets.

In Postman, create a `POST` request to the GraphQL endpoint and configure
**Authorization > OAuth 2.0 > Configure New Token**:

| Setting | Value |
| --- | --- |
| Grant type | Authorization Code (With PKCE) |
| Authorize using browser | Enabled |
| Callback URL | `https://oauth.pstmn.io/v1/browser-callback` (displayed read-only when browser authorization is enabled) |
| Auth URL | `https://login.microsoftonline.com/<TENANT_ID>/oauth2/v2.0/authorize` |
| Access Token URL | `https://login.microsoftonline.com/<TENANT_ID>/oauth2/v2.0/token` |
| Client ID | Approved interactive application's client ID |
| Client secret | Leave empty |
| Scope | `https://analysis.windows.net/powerbi/api/GraphQLApi.Execute.All` |
| Code challenge method | SHA-256 |

The Entra app registration must list the same callback URL under its mobile and
desktop/public-client redirect URIs. In Postman, select **Get New Access Token**,
complete Microsoft sign-in, then select **Use Token**.

Do not enable token sharing or sync a token into a shared workspace.

## Request body

Set `Content-Type: application/json` and choose **Body > raw > JSON**:

```json
{
  "query": "query CurrencyByCode($code: String!) { currencies(first: 100, filter: { Code: { eq: $code } }) { items { Id Code } hasNextPage endCursor } }",
  "variables": {
    "code": "USD"
  }
}
```

Postman also has a GraphQL body editor. The raw JSON form is shown because it is
identical to the payload used by Python, C#, Node.js, and cURL.

## cURL

If an approved process has already obtained a short-lived token, it can make the
same request with cURL:

```bash
curl --request POST "$FABRIC_GRAPHQL_ENDPOINT" \
  --header "Authorization: Bearer $FABRIC_ACCESS_TOKEN" \
  --header "Content-Type: application/json" \
  --data '{
    "query": "query CurrencyByCode($code: String!) { currencies(first: 100, filter: { Code: { eq: $code } }) { items { Id Code } } }",
    "variables": {"code": "USD"}
  }'
```

Do not paste tokens into shell history, scripts, documentation, or tickets. The
cURL example is best for a short diagnostic, not long-running automation.

Postman's current OAuth configuration behavior is documented in
[Postman OAuth 2.0 authentication](https://learning.postman.com/docs/use/send-requests/authorization/oauth-20/).

