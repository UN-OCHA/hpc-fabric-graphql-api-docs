# Filters and variables

Filters reduce data at the source. Always filter by a stable business key,
identifier, year, or relationship when the consumer does not need the whole
collection.

## Basic filter

```graphql
query CurrencyByCode {
  currencies(
    first: 100
    filter: { Code: { eq: "USD" } }
  ) {
    items {
      Id
      Code
    }
  }
}
```

The shape is:

```text
filter: {
  FieldName: { operator: value }
}
```

## Common operators

Available operators depend on the field's scalar type.

| Operator | Meaning | Example |
| --- | --- | --- |
| `eq` | equals | `Code: { eq: "USD" }` |
| `neq` | does not equal | `Code: { neq: "USD" }` |
| `in` | matches any supplied value | `RevisionStateId: { in: [1, 2] }` |
| `contains` | string contains text | `Name: { contains: "ocha" }` |
| `startsWith` | string begins with text | `PlanCode: { startsWith: "H" }` |
| `endsWith` | string ends with text | `Name: { endsWith: "Plan" }` |
| `gt`, `gte` | greater than / at least | `CalendarYear: { gte: 2024 }` |
| `lt`, `lte` | less than / at most | `CalendarYear: { lte: 2026 }` |
| `isNull` | null or non-null test | `CalendarYear: { isNull: false }` |

The exported schema is the authority for an individual field. For example,
numeric filters support comparisons while string filters support substring
operators.

## AND and OR

Fields placed together are treated as `AND`:

```graphql
filter: {
  IsReleased: { eq: true }
  IsRestricted: { eq: false }
}
```

Use `or` for alternatives:

```graphql
filter: {
  or: [
    { Name: { contains: "ocha" } }
    { Id: { eq: 123 } }
  ]
}
```

## Related-entity filters

Relationships exposed by the schema can be nested inside a filter. This returns
plans related to a 2026 period:

```graphql
filter: {
  period: {
    CalendarYear: { eq: 2026 }
  }
}
```

Relationship filters express existence: the parent is returned when at least
one related record satisfies the nested condition.

## Variables

Prefer variables whenever an ID, year, code, page size, or cursor changes:

```graphql
query PlansByYear(
  $year: Int!
  $first: Int! = 100
  $after: String
) {
  plans(
    first: $first
    after: $after
    filter: { period: { CalendarYear: { eq: $year } } }
    orderBy: { StartDate: DESC }
  ) {
    items {
      Id
      Name
      PlanCode
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
  "year": 2026,
  "first": 100,
  "after": null
}
```

On the next page, replace `null` with the preceding response's `endCursor`.
The variable must be declared in the operation header before it is used. A query
that uses `$after` without declaring `$after: String` fails validation.

## Ordering

Cursor pagination should use a stable order where possible:

```graphql
orderBy: { StartDate: DESC }
```

Use only fields present in the entity's generated `OrderByInput`. If records can
share the ordering value, consumers should tolerate a changing dataset during a
long extraction and rerun or checkpoint as appropriate.

