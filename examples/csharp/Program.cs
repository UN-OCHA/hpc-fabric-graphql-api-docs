using Azure.Core;
using Azure.Identity;
using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;

internal static class Program
{
    private const string DefaultEndpoint =
        "https://d1f25c25ab8d49ceb872d91de3d331ae.zd1.graphql.fabric." +
        "microsoft.com/v1/workspaces/d1f25c25-ab8d-49ce-b872-d91de3d331ae/" +
        "graphqlapis/c6a47e35-e236-423f-ac01-96f088acbc3a/graphql";

    private const string DefaultTenantId =
        "0f9e35db-544f-4f60-bdcc-5ea416e6dc70";

    // This matches the Fabric-generated interactive development example used
    // for the current internal access route. When the dedicated public-client
    // Entra application is available, configure its client ID and use the
    // delegated GraphQLApi.Execute.All scope documented by Microsoft.
    private const string DefaultUserScope =
        "https://analysis.windows.net/powerbi/api/user_impersonation";

    private const string TokenCacheName = "ha-fabric-graphql-csharp";

    private const string CurrencyQuery = """
        query CurrencyByCode($code: String!) {
          currencies(
            first: 100
            filter: { Code: { eq: $code } }
          ) {
            items {
              Id
              Code
            }
            hasNextPage
            endCursor
          }
        }
        """;

    private static async Task<int> Main(string[] args)
    {
        if (args.Length > 1 || args.Any(
            argument => argument is "-h" or "--help"))
        {
            PrintUsage();
            return args.Length > 1 ? 2 : 0;
        }

        var currencyCode = args.Length == 1
            ? args[0].Trim().ToUpperInvariant()
            : "USD";

        if (string.IsNullOrWhiteSpace(currencyCode))
        {
            Console.Error.WriteLine("Currency code cannot be empty.");
            return 2;
        }

        try
        {
            var endpoint = ResolveEndpoint();
            var scope = ResolveSetting(
                "FABRIC_GRAPHQL_USER_SCOPE",
                DefaultUserScope);
            var credential = await CreateInteractiveCredentialAsync(scope);

            using var client = new FabricGraphQLClient(
                endpoint,
                scope,
                credential);

            var data = await client.ExecuteAsync(
                CurrencyQuery,
                new { code = currencyCode },
                operationName: "CurrencyByCode");

            Console.WriteLine(
                JsonSerializer.Serialize(
                    data,
                    new JsonSerializerOptions { WriteIndented = true }));

            return 0;
        }
        catch (Exception exception) when (
            exception is GraphQLRequestException
            or AuthenticationFailedException
            or CredentialUnavailableException
            or InvalidOperationException
            or IOException
            or UnauthorizedAccessException)
        {
            Console.Error.WriteLine($"Query failed: {exception.Message}");
            return 1;
        }
    }

    private static void PrintUsage()
    {
        Console.WriteLine("Usage:");
        Console.WriteLine("  dotnet run");
        Console.WriteLine("  dotnet run -- EUR");
    }

    private static string ResolveSetting(
        string environmentVariable,
        string defaultValue)
    {
        var configuredValue =
            Environment.GetEnvironmentVariable(environmentVariable);

        return string.IsNullOrWhiteSpace(configuredValue)
            ? defaultValue
            : configuredValue.Trim();
    }

    private static Uri ResolveEndpoint()
    {
        var endpoint = ResolveSetting(
            "FABRIC_GRAPHQL_ENDPOINT",
            DefaultEndpoint);

        if (!Uri.TryCreate(endpoint, UriKind.Absolute, out var uri)
            || uri.Scheme != Uri.UriSchemeHttps
            || string.IsNullOrWhiteSpace(uri.Host))
        {
            throw new InvalidOperationException(
                "FABRIC_GRAPHQL_ENDPOINT must be a complete HTTPS URL.");
        }

        if (uri.Host.Equals("example", StringComparison.OrdinalIgnoreCase)
            || uri.Host.Equals(
                "example.com",
                StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(
                "FABRIC_GRAPHQL_ENDPOINT contains an example placeholder. " +
                "Remove the environment variable or provide the real endpoint.");
        }

        return uri;
    }

    private static string GetAuthenticationRecordPath()
    {
        var configuredPath = Environment.GetEnvironmentVariable(
            "FABRIC_GRAPHQL_AUTH_RECORD_PATH");

        if (!string.IsNullOrWhiteSpace(configuredPath))
        {
            return Path.GetFullPath(
                Environment.ExpandEnvironmentVariables(
                    configuredPath.Trim()));
        }

        var localApplicationData = Environment.GetFolderPath(
            Environment.SpecialFolder.LocalApplicationData);

        if (string.IsNullOrWhiteSpace(localApplicationData))
        {
            localApplicationData = Environment.GetFolderPath(
                Environment.SpecialFolder.UserProfile);
        }

        return Path.Combine(
            localApplicationData,
            "ha-fabric-graphql",
            "authentication-record-csharp.json");
    }

    private static async Task<InteractiveBrowserCredential>
        CreateInteractiveCredentialAsync(string scope)
    {
        var tenantId = ResolveSetting(
            "FABRIC_TENANT_ID",
            DefaultTenantId);
        var clientId = Environment.GetEnvironmentVariable(
            "FABRIC_GRAPHQL_CLIENT_ID")?.Trim();
        var authenticationRecordPath = GetAuthenticationRecordPath();

        AuthenticationRecord? authenticationRecord = null;

        if (File.Exists(authenticationRecordPath))
        {
            try
            {
                await using var recordStream = new FileStream(
                    authenticationRecordPath,
                    FileMode.Open,
                    FileAccess.Read,
                    FileShare.Read);

                authenticationRecord =
                    await AuthenticationRecord.DeserializeAsync(recordStream);
            }
            catch (Exception exception) when (
                exception is IOException
                or UnauthorizedAccessException
                or JsonException)
            {
                throw new InvalidOperationException(
                    "The saved Fabric authentication record could not be read. " +
                    $"Delete '{authenticationRecordPath}' and run again.",
                    exception);
            }
        }

        var options = new InteractiveBrowserCredentialOptions
        {
            TenantId = tenantId,
            AuthenticationRecord = authenticationRecord,
            TokenCachePersistenceOptions =
                new TokenCachePersistenceOptions
                {
                    Name = TokenCacheName,
                    UnsafeAllowUnencryptedStorage = false
                }
        };

        // A client ID is optional for the current Fabric-generated development
        // flow. Supply it when the dedicated public-client Entra application is
        // available.
        if (!string.IsNullOrWhiteSpace(clientId))
        {
            options.ClientId = clientId;
        }

        var credential = new InteractiveBrowserCredential(options);

        if (authenticationRecord is null)
        {
            authenticationRecord = await credential.AuthenticateAsync(
                new TokenRequestContext(new[] { scope }));

            await SaveAuthenticationRecordAsync(
                authenticationRecordPath,
                authenticationRecord);
        }

        return credential;
    }

    private static async Task SaveAuthenticationRecordAsync(
        string authenticationRecordPath,
        AuthenticationRecord authenticationRecord)
    {
        var directory = Path.GetDirectoryName(authenticationRecordPath)
            ?? throw new InvalidOperationException(
                "Authentication record directory could not be determined.");

        Directory.CreateDirectory(directory);

        var temporaryPath = authenticationRecordPath + ".tmp";

        try
        {
            await using (var recordStream = new FileStream(
                temporaryPath,
                FileMode.Create,
                FileAccess.Write,
                FileShare.None))
            {
                await authenticationRecord.SerializeAsync(recordStream);
            }

            File.Move(
                temporaryPath,
                authenticationRecordPath,
                overwrite: true);
        }
        catch (Exception exception) when (
            exception is IOException
            or UnauthorizedAccessException)
        {
            throw new InvalidOperationException(
                "Authentication succeeded, but the local authentication " +
                $"record could not be saved to '{authenticationRecordPath}'.",
                exception);
        }
    }
}

internal sealed class FabricGraphQLClient : IDisposable
{
    private static readonly HashSet<HttpStatusCode> TransientStatusCodes =
    [
        HttpStatusCode.TooManyRequests,
        HttpStatusCode.InternalServerError,
        HttpStatusCode.BadGateway,
        HttpStatusCode.ServiceUnavailable,
        HttpStatusCode.GatewayTimeout
    ];

    private readonly Uri _endpoint;
    private readonly string _scope;
    private readonly TokenCredential _credential;
    private readonly HttpClient _httpClient;

    public FabricGraphQLClient(
        Uri endpoint,
        string scope,
        TokenCredential credential)
    {
        _endpoint = endpoint;
        _scope = scope;
        _credential = credential;
        _httpClient = new HttpClient
        {
            Timeout = TimeSpan.FromSeconds(120)
        };
    }

    public async Task<JsonElement> ExecuteAsync(
        string query,
        object? variables = null,
        string? operationName = null,
        int retries = 3,
        CancellationToken cancellationToken = default)
    {
        if (string.IsNullOrWhiteSpace(query))
        {
            throw new ArgumentException(
                "The GraphQL query cannot be empty.",
                nameof(query));
        }

        if (retries < 0)
        {
            throw new ArgumentOutOfRangeException(
                nameof(retries),
                "Retry count cannot be negative.");
        }

        AccessToken token;

        try
        {
            token = await _credential.GetTokenAsync(
                new TokenRequestContext(new[] { _scope }),
                cancellationToken);
        }
        catch (Exception exception) when (
            exception is AuthenticationFailedException
            or CredentialUnavailableException)
        {
            throw new GraphQLRequestException(
                $"Authentication failed: {exception.Message}",
                exception);
        }

        var payload = new Dictionary<string, object?>
        {
            ["query"] = query,
            ["variables"] = variables ?? new { }
        };

        if (!string.IsNullOrWhiteSpace(operationName))
        {
            payload["operationName"] = operationName;
        }

        for (var attempt = 0; attempt <= retries; attempt++)
        {
            using var request = new HttpRequestMessage(
                HttpMethod.Post,
                _endpoint);

            request.Headers.Authorization =
                new AuthenticationHeaderValue("Bearer", token.Token);
            request.Headers.Accept.Add(
                new MediaTypeWithQualityHeaderValue("application/json"));
            request.Content = JsonContent.Create(payload);

            HttpResponseMessage response;

            try
            {
                response = await _httpClient.SendAsync(
                    request,
                    HttpCompletionOption.ResponseHeadersRead,
                    cancellationToken);
            }
            catch (Exception exception) when (
                exception is HttpRequestException
                or TaskCanceledException)
            {
                if (attempt < retries
                    && !cancellationToken.IsCancellationRequested)
                {
                    await Task.Delay(
                        GetRetryDelay(null, attempt),
                        cancellationToken);
                    continue;
                }

                throw new GraphQLRequestException(
                    $"Request failed after {attempt + 1} attempts: " +
                    exception.Message,
                    exception);
            }

            using (response)
            {
                if (TransientStatusCodes.Contains(response.StatusCode)
                    && attempt < retries)
                {
                    await Task.Delay(
                        GetRetryDelay(response, attempt),
                        cancellationToken);
                    continue;
                }

                var responseBody = await response.Content.ReadAsStringAsync(
                    cancellationToken);

                JsonDocument responseDocument;

                try
                {
                    responseDocument = JsonDocument.Parse(responseBody);
                }
                catch (JsonException exception)
                {
                    throw new GraphQLRequestException(
                        $"HTTP {(int)response.StatusCode}: response was not " +
                        $"valid JSON. Body: {Truncate(responseBody, 1_000)}",
                        exception);
                }

                using (responseDocument)
                {
                    if (!response.IsSuccessStatusCode)
                    {
                        throw new GraphQLRequestException(
                            $"HTTP {(int)response.StatusCode}: " +
                            Truncate(responseBody, 4_000));
                    }

                    if (responseDocument.RootElement.TryGetProperty(
                        "errors",
                        out var errors)
                        && errors.ValueKind != JsonValueKind.Null
                        && errors.ToString() is { Length: > 0 } errorText
                        && errorText != "[]")
                    {
                        throw new GraphQLRequestException(
                            $"GraphQL errors: {Truncate(errorText, 4_000)}");
                    }

                    if (!responseDocument.RootElement.TryGetProperty(
                        "data",
                        out var data))
                    {
                        throw new GraphQLRequestException(
                            "The GraphQL response did not contain a data object.");
                    }

                    return data.Clone();
                }
            }
        }

        throw new GraphQLRequestException(
            "Request failed after retry attempts.");
    }

    private static TimeSpan GetRetryDelay(
        HttpResponseMessage? response,
        int attempt)
    {
        var retryAfter = response?.Headers.RetryAfter;

        if (retryAfter?.Delta is { } delta)
        {
            return delta > TimeSpan.FromSeconds(60)
                ? TimeSpan.FromSeconds(60)
                : delta;
        }

        if (retryAfter?.Date is { } retryDate)
        {
            var dateDelay = retryDate - DateTimeOffset.UtcNow;
            if (dateDelay > TimeSpan.Zero)
            {
                return dateDelay > TimeSpan.FromSeconds(60)
                    ? TimeSpan.FromSeconds(60)
                    : dateDelay;
            }
        }

        return TimeSpan.FromSeconds(Math.Min(Math.Pow(2, attempt), 8));
    }

    private static string Truncate(string value, int maximumLength)
    {
        return value.Length <= maximumLength
            ? value
            : value[..maximumLength] + "... [truncated]";
    }

    public void Dispose()
    {
        _httpClient.Dispose();
    }
}

internal sealed class GraphQLRequestException : Exception
{
    public GraphQLRequestException(string message)
        : base(message)
    {
    }

    public GraphQLRequestException(
        string message,
        Exception innerException)
        : base(message, innerException)
    {
    }
}
