# Reference data queries

Send each operation to the APIM endpoint as `query`, with the shown
`variables` in the same JSON body. Example IDs are sample values; replace them
with IDs from your data. Follow each collection's `hasNextPage` and `endCursor`.

These small operations are suitable for connectivity tests and cached reference
data. Continue pagination when `hasNextPage` is true.

## Currencies

Returns currency IDs and codes.

```graphql
query Currencies($first: Int! = 100, $after: String) {
  currencies(
    first: $first
    after: $after
    orderBy: { Code: ASC }
  ) {
    items {
      Id
      Code
    }
    hasNextPage
    endCursor
  }
}
```

Variables:

```json
{
  "first": 100,
  "after": null
}
```

### Currency by code

```graphql
query CurrencyByCode($code: String!) {
  currencies(
    first: 100
    filter: { Code: { eq: $code } }
  ) {
    items {
      Id
      Code
    }
  }
}
```

Variables:

```json
{
  "code": "USD"
}
```


## Countries

Returns level-zero administrative locations.

```graphql
query Countries($first: Int! = 100, $after: String) {
  locations(
    first: $first
    after: $after
    filter: { AdminLevel: { eq: 0 } }
    orderBy: { Name: ASC }
  ) {
    items {
      Id
      Name
      ISO3
      Pcode
      AdminLevel
      Latitude
      Longitude
    }
    hasNextPage
    endCursor
  }
}
```

Variables:

```json
{
  "first": 100,
  "after": null
}
```

## Years

Returns periods with a calendar year, newest first.

```graphql
query Years($first: Int! = 100, $after: String) {
  periods(
    first: $first
    after: $after
    filter: { CalendarYear: { isNull: false } }
    orderBy: { CalendarYear: DESC }
  ) {
    items {
      Id
      Name
      CalendarYear
      PeriodType
      StartDate
      EndDate
    }
    hasNextPage
    endCursor
  }
}
```

Variables:

```json
{
  "first": 100,
  "after": null
}
```

## Revision states

Returns revision-state reference values used by requirement facts.

```graphql
query RevisionStates($first: Int! = 100, $after: String) {
  revisionStates(first: $first, after: $after, orderBy: { Id: ASC }) {
    items {
      Id
      Name
      DisplayName
    }
    hasNextPage
    endCursor
  }
}
```

Variables:

```json
{
  "first": 100,
  "after": null
}
```

For requirement calculations, apply the API-specific rules in
[Data model and rules](../reference/data-model.md).
