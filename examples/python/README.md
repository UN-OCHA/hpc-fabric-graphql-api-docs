# Python example

OCHA users sign in at <https://developer-api.humanitarianaction.info> with
their `@un.org` account using Microsoft Entra ID. External users sign up with
email and password. Ask the API team for access. We will add you to the API
product and give you a subscription key.

Endpoint: `https://api.humanitarianaction.info/graphql/v1`.

Install **Python 3.10+**. Set `APIM_SUBSCRIPTION_KEY` as explained in the
[root README](../README.md#configure-the-terminal-and-server-examples).
From this `python/` directory:

```bash
python3 example.py currency USD
python3 example.py plan 1202
python3 example.py currencies 2 5
```

On Windows, use `py` or `python` instead of `python3` if needed.
The last command requests two currencies per page, up to five records in total.
`python3 example.py --help` shows usage. Defaults are USD, plan 1202, and 100/1000.

No pip packages or virtual environment are required. `example.py` uses Python's
standard library to read a query from `../queries/`, POST JSON to the endpoint
with the subscription-key header, and print the JSON data. Keep `../queries/`
with this directory. Change command-line values or query fields in the `.graphql`
files. Keep the real key in your environment, outside source control.
