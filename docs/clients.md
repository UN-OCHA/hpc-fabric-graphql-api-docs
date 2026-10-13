# Client examples

All examples use `https://api.humanitarianaction.info/graphql/v1` and the
`Ocp-Apim-Subscription-Key` header. [Obtain a key](getting-started/quick-start.md)
before running them.

## Terminal examples

Set `APIM_SUBSCRIPTION_KEY` in the terminal. Run these commands from the repository root:

```powershell
# C# — .NET 10 SDK
dotnet run --project ./examples/csharp/HaApimExamples.csproj -- currency USD
dotnet run --project ./examples/csharp/HaApimExamples.csproj -- plan 1202
dotnet run --project ./examples/csharp/HaApimExamples.csproj -- currencies 2 5

# Node.js — 22.12+; no npm install
node ./examples/node/example.mjs currency USD
node ./examples/node/example.mjs plan 1202
node ./examples/node/example.mjs currencies 2 5

# Python — 3.10+; no pip install
python3 ./examples/python/example.py currency USD
python3 ./examples/python/example.py plan 1202
python3 ./examples/python/example.py currencies 2 5
```

On Windows, `py` or `python` can replace `python3`.
The endpoint has the correct default; `APIM_ENDPOINT` is an optional override.
The three samples print JSON and check HTTP and GraphQL errors.
They read the `.graphql` files in `examples/queries/`; keep the folder structure.

Source and detailed instructions on GitHub:

- [C#](https://github.com/UN-OCHA/hpc-fabric-graphql-api-docs/tree/main/examples/csharp)
- [Node.js](https://github.com/UN-OCHA/hpc-fabric-graphql-api-docs/tree/main/examples/node)
- [Python](https://github.com/UN-OCHA/hpc-fabric-graphql-api-docs/tree/main/examples/python)

## Drupal (PHP)

This is a module for an existing Drupal 10.3+/11 site, not a standalone PHP script.
Use the PHP version supported by that site.

1. Copy `examples/drupal/ha_apim_examples/` into the site's `web/modules/custom/`
   or `modules/custom/` folder, depending on its web root.
2. Set `APIM_SUBSCRIPTION_KEY` in the web/PHP process environment.
3. Enable **Humanitarian Action APIM examples** on the **Extend** page.
4. Grant the intended role **Use the APIM example form** under **People → Permissions**.
5. Open `/ha-apim-examples` on the Drupal site.

The server calls APIM and displays a table with expandable JSON. The key is kept
on the server. Drush is optional; enable the module through the admin interface.

[Drupal source and instructions](https://github.com/UN-OCHA/hpc-fabric-graphql-api-docs/tree/main/examples/drupal).

## Using a key in production

For a website using a shared application key, its application server should make
the APIM request. Browser code calls your server, which returns the permitted data.
Keep the key in server configuration and apply the website's access rules there.

Use a separate subscription for each production application where possible, so
usage and key replacement can be managed independently. These samples send
requests outside the browser and need no browser CORS setup.
