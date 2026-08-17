# Projects and emergencies

## Emergencies

```graphql
query Emergencies($first: Int! = 100, $after: String) {
  emergencies(
    first: $first
    after: $after
    orderBy: { Name: ASC }
  ) {
    items {
      Id
      Name
      EmergencyType
      EmergencyDate
      GlideNumber
      IsLevel3
    }
    hasNextPage
    endCursor
  }
}
```

## Emergencies by plan

```graphql
query EmergenciesByPlan(
  $planId: Int!
  $first: Int! = 100
  $after: String
) {
  emergencies(
    first: $first
    after: $after
    filter: { plan: { Id: { eq: $planId } } }
    orderBy: { Name: ASC }
  ) {
    items {
      Id
      Name
      EmergencyType
      EmergencyDate
      GlideNumber
      IsLevel3
    }
    hasNextPage
    endCursor
  }
}
```

```json
{
  "planId": 1202,
  "first": 100,
  "after": null
}
```

## Projects

```graphql
query Projects($first: Int! = 100, $after: String) {
  projects(first: $first, after: $after, orderBy: { Name: ASC }) {
    items {
      Id
      PlanId
      ProjectCode
      Name
      StartDate
      EndDate
      IsPublished
      ImplementationStatus
      CurrentRequestedFunds
      TotalProjectTarget
    }
    hasNextPage
    endCursor
  }
}
```

## Projects by plan

Returns projects and selected relationships for one plan. Each nested list has
its own page boundary.

```graphql
query ProjectsByPlan(
  $planId: Int!
  $first: Int! = 100
  $after: String
) {
  projects(
    first: $first
    after: $after
    filter: { PlanId: { eq: $planId } }
    orderBy: { Name: ASC }
  ) {
    items {
      Id
      PlanId
      ProjectCode
      Name
      StartDate
      EndDate
      IsPublished
      ImplementationStatus
      CurrentRequestedFunds
      TotalProjectTarget

      organization(first: 50, orderBy: { Name: ASC }) {
        items {
          Id
          Name
          Abbreviation
        }
        hasNextPage
        endCursor
      }

      sector(first: 20, orderBy: { Name: ASC }) {
        items {
          Id
          Name
          SectorCode
          SectorType
        }
        hasNextPage
        endCursor
      }

      coordinationEntity(first: 20, orderBy: { Name: ASC }) {
        items {
          Id
          Name
          EntityTypeId
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

```json
{
  "planId": 1202,
  "first": 100,
  "after": null
}
```

`CurrentRequestedFunds` is exposed at project level. The current schema does not
expose a separate project-level original requirement or an
organization-specific allocation amount.

