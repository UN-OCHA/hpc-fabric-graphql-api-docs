# C# example

Register at <https://hpc-apims.developer.azure-api.net/> with **any valid email
address and a password**, then subscribe to the API product for a subscription
key (approval may be required). Alternatively ask the API developers for a key,
or use the key shared with you.

Endpoint: `https://hpc-apims.azure-api.net/v1`.

Install the **.NET 10 SDK**. Set `APIM_SUBSCRIPTION_KEY` as explained in the
[root README](../README.md#configure-the-terminal-and-server-examples).
From this `csharp/` directory:

```bash
dotnet run -- currency USD
dotnet run -- plan 1202
dotnet run -- currencies 100 1000
```

The last command requests 100 currencies per page, up to 1000 records in total.
Defaults are USD, plan 1202, and 100/1000.

`Program.cs` creates an `HttpClient`, adds the subscription-key header, reads
the query from `../queries/`, posts `{ query, variables }`, and prints the JSON
data. The project copies those query files into the build output automatically.
No additional NuGet packages are required. Keep `../queries/` with this project.
Change query variables in the command line; change query fields in the `.graphql`
files. Do not put a real key in source code.
