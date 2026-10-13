"""Simple APIM GraphQL examples; uses only the Python standard library.

Sign in at https://developer-api.humanitarianaction.info and subscribe for a key.
Alternatively ask the API developers for a key, or use the key shared with you.
Set APIM_SUBSCRIPTION_KEY in your environment. Never commit a real key.
"""
import argparse
import json
import os
from pathlib import Path
import sys
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

ENDPOINT = os.getenv("APIM_ENDPOINT") or "https://api.humanitarianaction.info/graphql/v1"
QUERY_FOLDER = Path(__file__).resolve().parent.parent / "queries"


def execute(query_file, variables, key):
    """POST a query with variables, then return the response's data object."""
    query = (QUERY_FOLDER / query_file).read_text(encoding="utf-8")
    payload = json.dumps({"query": query, "variables": variables}).encode("utf-8")
    request = Request(ENDPOINT, data=payload, method="POST", headers={
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Ocp-Apim-Subscription-Key": key,
    })
    try:
        with urlopen(request, timeout=110) as response:
            body = json.load(response)
    except HTTPError as error:
        detail = error.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"HTTP {error.code}: {detail}") from error
    except URLError as error:
        raise RuntimeError(f"Could not reach the API: {error.reason}") from error
    # A GraphQL error can arrive in a successful HTTP 200 response.
    if not isinstance(body, dict):
        raise RuntimeError("The API response was not a JSON object.")
    if body.get("errors"):
        raise RuntimeError(f"GraphQL errors: {json.dumps(body['errors'])}")
    if not isinstance(body.get("data"), dict):
        raise RuntimeError("The response did not contain a GraphQL data object.")
    return body["data"]


def main():
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description=(
        "APIM examples. Sign in and subscribe at "
        "https://developer-api.humanitarianaction.info for a key, or ask the API developers."
    ))
    parser.add_argument("example", nargs="?", default="currency", choices=["currency", "plan", "currencies"])
    parser.add_argument("value", nargs="?", help="Currency code, plan ID, or page size.")
    parser.add_argument("limit", nargs="?", type=int, default=1000, help="Max records for currencies.")
    args = parser.parse_args()
    key = (os.getenv("APIM_SUBSCRIPTION_KEY") or "").strip()
    if not key or key == "replace-with-your-subscription-key":
        raise ValueError("Set APIM_SUBSCRIPTION_KEY. Sign in and subscribe at https://developer-api.humanitarianaction.info, or ask the API developers for a key.")
    if args.example == "currency":
        code = (args.value if args.value is not None else "USD").strip().upper()
        if not code:
            raise ValueError("Currency code cannot be empty.")
        result = execute("currency-by-code.graphql", {"code": code}, key)
    elif args.example == "plan":
        plan_id = int(args.value or 1202)
        if not 1 <= plan_id <= 2_147_483_647:
            raise ValueError("Plan ID must be a positive 32-bit integer.")
        result = execute("plan-by-id.graphql", {"planId": plan_id}, key)
    else:
        page_size = int(args.value or 100)
        if not 1 <= page_size <= 1000 or args.limit < 1:
            raise ValueError("Page size must be 1–1000 and max records must be positive.")
        items, seen_cursors = [], set()
        after, has_next_page = None, False
        while len(items) < args.limit:
            first = min(page_size, args.limit - len(items))
            data = execute("currencies-page.graphql", {"first": first, "after": after}, key)
            page = data.get("currencies")
            if not isinstance(page, dict) or not isinstance(page.get("items"), list):
                raise RuntimeError("Missing currencies items array.")
            items.extend(page["items"][:first])
            has_next_page = bool(page.get("hasNextPage"))
            if not has_next_page or len(items) >= args.limit:
                break
            after = page.get("endCursor")
            if not after or after in seen_cursors:
                raise RuntimeError("Pagination stopped: missing or repeated cursor.")
            seen_cursors.add(after)
        result = {
            "items": items, "returnedCount": len(items), "hasNextPage": has_next_page,
            "stoppedAtConfiguredLimit": has_next_page and len(items) >= args.limit,
        }
    # Use result directly in your application; here we print it as readable JSON.
    print(json.dumps(result, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, ValueError, OSError) as error:
        print(f"Query failed: {error}", file=sys.stderr)
        raise SystemExit(1)

