# Performance and limits

Direct consumers share the Fabric capacity with other workloads. A valid query
can still be harmful if it retrieves too much data, nests several large
relationships, or is run concurrently many times.

## Microsoft Fabric platform limits

Microsoft currently documents these general API for GraphQL limits:

| Limit | Current value | Design response |
| --- | ---: | --- |
| Default page size | 100 items | Always paginate explicitly |
| Maximum retrievable through pagination | 100,000 items | Split larger extracts into filtered ranges |
| Maximum response size | 64 MB | Select fewer fields and use smaller pages |
| Request timeout | 100 seconds | Split complex or deeply nested operations |
| Maximum query depth | 10 levels | Flatten or use multiple requests |
| Objects attached to one GraphQL item | 1,000 objects | API-owner/schema design concern |

Source: [Limitations of Microsoft Fabric API for GraphQL](https://learn.microsoft.com/en-us/fabric/data-engineering/api-graphql-limits).
Microsoft can revise these limits; review the linked page when designing or
changing a production extraction.

## This API's operating guidance

1. **Filter first.** Prefer a plan ID, project ID, year, code, or updated-date
   range over an all-record query.
2. **Start at 100 records.** Increase only after measuring response time and
   payload size. Do not exceed `first: 1000` without agreement from the API
   owner.
3. **Select only needed fields.** GraphQL does not make unused fields free.
4. **Paginate every collection.** Include `hasNextPage` and `endCursor`; nested
   lists require separate pagination.
5. **Avoid wide fan-out.** A plan containing projects, every project's
   organizations, sectors, locations, and facts can multiply work and payload
   size even below the ten-level depth limit.
6. **Split complex operations.** First obtain stable IDs, then request related
   rows in a second filtered query.
7. **Bound concurrency.** Use a small worker pool or sequential pages. Never
   launch one request per returned record without a strict limit.
8. **Cache stable reference data.** Currencies, sectors, and similar reference
   values need not be re-fetched for every record.
9. **Retry transient failures responsibly.** Retry `429`, `502`, `503`, and
   `504` with exponential backoff, jitter, and a maximum attempt count. Honor
   `Retry-After`.
10. **Checkpoint ETLs.** Record the last completed filter range or cursor so a
    failure does not force a complete restart. A cursor should be used for the
    active extraction, not treated as a permanent record identifier.

## Warning signs

Reduce or split a query when any of the following occurs:

- `hasNextPage` is ignored;
- response size grows into multiple megabytes;
- request duration approaches the timeout;
- query nesting approaches ten levels;
- an internal execution error disappears when a relationship is removed;
- the same nested collection returns `hasNextPage: true` for many parents;
- Fabric begins returning throttling or transient server errors.

An HTTP success status does not guarantee GraphQL success. Always inspect the
top-level `errors` array.

