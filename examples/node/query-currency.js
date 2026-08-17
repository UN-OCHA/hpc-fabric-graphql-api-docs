import { DefaultAzureCredential } from "@azure/identity";

const endpoint = process.env.FABRIC_GRAPHQL_ENDPOINT;
if (!endpoint) {
  throw new Error("FABRIC_GRAPHQL_ENDPOINT is required");
}

// DefaultAzureCredential supports managed identity and environment credentials.
// For environment credentials, set AZURE_TENANT_ID, AZURE_CLIENT_ID, and
// AZURE_CLIENT_SECRET in the process environment or secret-injection system.
const credential = new DefaultAzureCredential();
const token = await credential.getToken(
  "https://api.fabric.microsoft.com/.default",
);

const query = `
  query CurrencyByCode($code: String!) {
    currencies(first: 100, filter: { Code: { eq: $code } }) {
      items {
        Id
        Code
      }
      hasNextPage
      endCursor
    }
  }
`;

const response = await fetch(endpoint, {
  method: "POST",
  headers: {
    Authorization: `Bearer ${token.token}`,
    Accept: "application/json",
    "Content-Type": "application/json",
  },
  body: JSON.stringify({ query, variables: { code: "USD" } }),
  signal: AbortSignal.timeout(110_000),
});

const body = await response.json();
if (!response.ok) {
  throw new Error(`HTTP ${response.status}: ${JSON.stringify(body)}`);
}
if (body.errors) {
  throw new Error(`GraphQL errors: ${JSON.stringify(body.errors)}`);
}

console.log(JSON.stringify(body.data, null, 2));

