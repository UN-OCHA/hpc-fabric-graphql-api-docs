# Node.js example

OCHA users sign in at <https://developer-api.humanitarianaction.info> with
their `@un.org` account using Microsoft Entra ID. External users sign up with
email and password. Subscribe for a key (approval may be required).

Endpoint: `https://api.humanitarianaction.info/graphql/v1`.

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
