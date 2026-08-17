# Plan queries

## First page of plans

Returns basic plan details, years, and level-zero locations. The nested lists are
intentionally small; paginate them separately if their `hasNextPage` value is
true.

```graphql
query Plans($first: Int! = 100, $after: String) {
  plans(
    first: $first
    after: $after
    orderBy: { StartDate: DESC }
  ) {
    items {
      Id
      Name
      ShortName
      PlanCode
      PlanType
      PlanCosting
      PlanClusterType
      StartDate
      EndDate
      IsReleased
      IsRestricted

      period(first: 10, orderBy: { CalendarYear: DESC }) {
        items {
          Id
          CalendarYear
          PeriodType
        }
        hasNextPage
        endCursor
      }

      location(first: 10, filter: { AdminLevel: { eq: 0 } }) {
        items {
          Id
          Name
          ISO3
          Pcode
        }
        hasNextPage
        endCursor
      }
    }
    hasNextPage
    endCursor
  }
}
```

## Plan by ID

```graphql
query PlanById($planId: Int!) {
  plans(first: 1, filter: { Id: { eq: $planId } }) {
    items {
      Id
      Name
      ShortName
      PlanCode
      PlanType
      PlanCosting
      PlanClusterType
      PlanLanguage
      StartDate
      EndDate
      IsReleased
      IsRestricted
      IsPartOfGHO
      IsForHPCProjects

      period(first: 10, orderBy: { CalendarYear: DESC }) {
        items {
          Id
          CalendarYear
          PeriodType
        }
      }

      location(first: 10, filter: { AdminLevel: { eq: 0 } }) {
        items {
          Id
          Name
          ISO3
          Pcode
        }
      }
    }
  }
}
```

```json
{
  "planId": 1202
}
```

## Plans by year

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
      ShortName
      PlanCode
      PlanType
      PlanCosting
      StartDate
      EndDate
      IsReleased
      IsRestricted

      period(first: 10, filter: { CalendarYear: { eq: $year } }) {
        items {
          Id
          CalendarYear
          PeriodType
        }
      }

      location(first: 10, filter: { AdminLevel: { eq: 0 } }) {
        items {
          Id
          Name
          ISO3
        }
      }
    }
    hasNextPage
    endCursor
  }
}
```

```json
{
  "year": 2026,
  "first": 100,
  "after": null
}
```

## Plan by project ID

Returns the plan containing the requested project and the matching project
record.

```graphql
query PlanByProjectId($projectId: Int!) {
  plans(
    first: 10
    filter: { project: { Id: { eq: $projectId } } }
  ) {
    items {
      Id
      Name
      ShortName
      PlanCode
      PlanType
      StartDate
      EndDate

      project(first: 10, filter: { Id: { eq: $projectId } }) {
        items {
          Id
          ProjectCode
          Name
          CurrentRequestedFunds
        }
      }
    }
    hasNextPage
    endCursor
  }
}
```

```json
{
  "projectId": 12345
}
```

