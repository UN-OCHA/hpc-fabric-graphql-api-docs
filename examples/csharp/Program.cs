using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;

// Sign in at https://developer-api.humanitarianaction.info and ask the API team for a key.
// Set APIM_SUBSCRIPTION_KEY in your environment. Keep real keys out of Git.

string endpoint = Environment.GetEnvironmentVariable("APIM_ENDPOINT")
    ?? "https://api.humanitarianaction.info/graphql/v1";

string? subscriptionKey =
    Environment.GetEnvironmentVariable("APIM_SUBSCRIPTION_KEY")?.Trim();

string example = args.ElementAtOrDefault(0) ?? "currency";

try
{
    if (string.IsNullOrWhiteSpace(subscriptionKey))
        throw new ArgumentException("Set APIM_SUBSCRIPTION_KEY first.");

    using var client = new HttpClient
    {
        Timeout = TimeSpan.FromSeconds(110)
    };

    client.DefaultRequestHeaders.Add(
        "Ocp-Apim-Subscription-Key", subscriptionKey);

    // Read a query file, send buffered JSON, and return its data.
    async Task<JsonElement> ExecuteAsync(string queryFile, object variables)
    {
        string query = await File.ReadAllTextAsync(
            Path.Combine(AppContext.BaseDirectory, "Queries", queryFile));

        string json = JsonSerializer.Serialize(new { query, variables });

        // Buffer the body so HttpClient can send Content-Length.
        using var content = new ByteArrayContent(Encoding.UTF8.GetBytes(json));
        content.Headers.ContentType =
            new MediaTypeHeaderValue("application/json");

        using var response = await client.PostAsync(endpoint, content);
        string responseBody = await response.Content.ReadAsStringAsync();

        if (!response.IsSuccessStatusCode)
            throw new HttpRequestException(
                $"HTTP {(int)response.StatusCode}: {responseBody}");

        using var document = JsonDocument.Parse(responseBody);
        var root = document.RootElement;

        if (root.TryGetProperty("errors", out var errors) &&
            errors.ValueKind == JsonValueKind.Array &&
            errors.GetArrayLength() > 0)
        {
            throw new InvalidOperationException($"GraphQL errors: {errors}");
        }

        // Clone keeps the data valid after disposing the document.
        return root.GetProperty("data").Clone();
    }

    object result;

    if (example == "currency")
    {
        string code = (args.ElementAtOrDefault(1) ?? "USD")
            .Trim().ToUpperInvariant();

        if (code.Length == 0)
            throw new ArgumentException("Currency code cannot be empty.");

        result = await ExecuteAsync(
            "currency-by-code.graphql", new { code });
    }
    else if (example == "plan")
    {
        int planId = int.Parse(args.ElementAtOrDefault(1) ?? "1202");

        if (planId < 1)
            throw new ArgumentException("Plan ID must be positive.");

        result = await ExecuteAsync(
            "plan-by-id.graphql", new { planId });
    }
    else if (example == "currencies")
    {
        int pageSize = int.Parse(args.ElementAtOrDefault(1) ?? "100");
        int maxRecords = int.Parse(args.ElementAtOrDefault(2) ?? "1000");

        if (pageSize is < 1 or > 1000 || maxRecords < 1)
            throw new ArgumentException(
                "Page size must be 1–1000 and max records must be positive.");

        var items = new List<JsonElement>();
        var seenCursors = new HashSet<string>();
        string? after = null;
        bool hasNextPage;

        do
        {
            int first = Math.Min(pageSize, maxRecords - items.Count);

            var data = await ExecuteAsync(
                "currencies-page.graphql", new { first, after });

            var page = data.GetProperty("currencies");
            items.AddRange(
                page.GetProperty("items").EnumerateArray().Take(first));

            hasNextPage = page.GetProperty("hasNextPage").GetBoolean();

            if (!hasNextPage || items.Count >= maxRecords)
                break;

            after = page.GetProperty("endCursor").GetString();

            if (string.IsNullOrEmpty(after) || !seenCursors.Add(after))
                throw new InvalidOperationException(
                    "Pagination stopped: missing or repeated cursor.");
        } while (true);

        result = new
        {
            items,
            returnedCount = items.Count,
            hasNextPage,
            stoppedAtConfiguredLimit =
                hasNextPage && items.Count >= maxRecords
        };
    }
    else
    {
        throw new ArgumentException("Choose currency, plan, or currencies.");
    }

    Console.WriteLine(JsonSerializer.Serialize(
        result, new JsonSerializerOptions { WriteIndented = true }));

    return 0;
}
catch (Exception error)
{
    Console.Error.WriteLine($"Query failed: {error.Message}");
    return 1;
}
