# Reference data queries

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

For requirement calculations, apply the API-specific rules in
[Data model and rules](../reference/data-model.md).

