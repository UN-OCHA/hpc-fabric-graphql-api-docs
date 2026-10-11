# Node.js example

Register at <https://hpc-apims.developer.azure-api.net/> with **any valid email
address and a password**, then subscribe to the API product for a subscription
key (approval may be required). Alternatively ask the API developers for a key,
or use the key shared with you.

Endpoint: `https://hpc-apims.azure-api.net/v1`.

Install **Node.js 22.12+**. Set `APIM_SUBSCRIPTION_KEY` as explained in the
[root README](../README.md#configure-the-terminal-and-server-examples).
From this `node/` directory:

```bash
node example.mjs currency USD
node example.mjs plan 1202
node example.mjs currencies 100 1000
```

The last command requests 100 currencies per page, up to 1000 records in total.
`node example.mjs --help` shows usage. Defaults are USD, plan 1202, and 100/1000.

No `npm install` is needed. `example.mjs` uses native `fetch`, reads the query
from `../queries/`, adds `Ocp-Apim-Subscription-Key`, posts `{ query, variables }`,
and prints the JSON data. Keep `../queries/` with this directory. Change variables
in the command line or fields in the `.graphql` files. Keep the real key in your
environment, outside source control.
