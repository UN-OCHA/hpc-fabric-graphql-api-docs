using Azure.Core;
using Azure.Identity;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;

const string scope = "https://api.fabric.microsoft.com/.default";

var endpoint = Environment.GetEnvironmentVariable("FABRIC_GRAPHQL_ENDPOINT")
    ?? throw new InvalidOperationException("FABRIC_GRAPHQL_ENDPOINT is required.");

// DefaultAzureCredential uses managed identity when available and can also use
// AZURE_TENANT_ID, AZURE_CLIENT_ID, and AZURE_CLIENT_SECRET from the environment.
// It prevents credentials from being embedded in source code.
var credential = new DefaultAzureCredential();
var token = await credential.GetTokenAsync(
    new TokenRequestContext(new[] { scope })
);

const string query = """
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
""";

var payload = new
{
    query,
    variables = new { code = "USD" }
};

using var client = new HttpClient
{
    Timeout = TimeSpan.FromSeconds(110)
};
using var request = new HttpRequestMessage(HttpMethod.Post, endpoint);
request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token.Token);
request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
request.Content = JsonContent.Create(payload);

using var response = await client.SendAsync(request);
var body = await response.Content.ReadAsStringAsync();

if (!response.IsSuccessStatusCode)
{
    throw new HttpRequestException($"HTTP {(int)response.StatusCode}: {body}");
}

using var document = JsonDocument.Parse(body);
if (document.RootElement.TryGetProperty("errors", out var errors))
{
    throw new InvalidOperationException($"GraphQL errors: {errors}");
}

Console.WriteLine(
    JsonSerializer.Serialize(
        document.RootElement,
        new JsonSerializerOptions { WriteIndented = true }
    )
);

