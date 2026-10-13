# C# example

OCHA users sign in at <https://developer-api.humanitarianaction.info> with
their `@un.org` account using Microsoft Entra ID. External users sign up with
email and password. Ask the API team for access. We will add you to the API
product and give you a subscription key.

Endpoint: `https://api.humanitarianaction.info/graphql/v1`.

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
