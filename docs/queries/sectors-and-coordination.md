# Sectors and coordination entities

Send each operation to the APIM endpoint as `query`, with the shown
`variables` in the same JSON body. Example IDs are sample values; replace them
with IDs from your data. Follow each collection's `hasNextPage` and `endCursor`.

## All sectors

```graphql
query Sectors($first: Int! = 100, $after: String) {
  sectors(first: $first, after: $after, orderBy: { Name: ASC }) {
    items {
      Id
      Name
      SectorCode
      SectorType
      Description
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

## Sectors by plan

Returns sectors linked to coordination entities belonging to the plan.

```graphql
query SectorsByPlan(
  $planId: Int!
  $first: Int! = 100
  $after: String
) {
  sectors(
    first: $first
    after: $after
    filter: { coordinationEntity: { PlanId: { eq: $planId } } }
    orderBy: { Name: ASC }
  ) {
    items {
      Id
      Name
      SectorCode
      SectorType
    }
    hasNextPage
    endCursor
  }
}
```

Variables:

```json
{
  "planId": 1202,
  "first": 100,
  "after": null
}
```


## Sectors by project

```graphql
query SectorsByProject(
  $projectId: Int!
  $first: Int! = 100
  $after: String
) {
  sectors(
    first: $first
    after: $after
    filter: { project: { Id: { eq: $projectId } } }
    orderBy: { Name: ASC }
  ) {
    items {
      Id
      Name
      SectorCode
      SectorType
    }
    hasNextPage
    endCursor
  }
}
```

Variables:

```json
{
  "projectId": 12345,
  "first": 100,
  "after": null
}
```


## Coordination entities by plan

```graphql
query CoordinationEntitiesByPlan(
  $planId: Int!
  $first: Int! = 100
  $after: String
) {
  coordinationEntities(
    first: $first
    after: $after
    filter: { PlanId: { eq: $planId } }
    orderBy: { Name: ASC }
  ) {
    items {
      Id
      PlanId
      Name
      Description
      CustomReference
      ComposedReference
      EntityTypeId

      entityType {
        Id
        Name
        DisplayName
        EntitySubType
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
    }
    hasNextPage
    endCursor
  }
}
```

Variables:

```json
{
  "planId": 1202,
  "first": 100,
  "after": null
}
```

## Coordination entities by project

```graphql
query CoordinationEntitiesByProject(
  $projectId: Int!
  $first: Int! = 100
  $after: String
) {
  coordinationEntities(
    first: $first
    after: $after
    filter: { project: { Id: { eq: $projectId } } }
    orderBy: { Name: ASC }
  ) {
    items {
      Id
      PlanId
      Name
      EntityTypeId

      entityType {
        Id
        Name
        DisplayName
        EntitySubType
      }

      sector(first: 20, orderBy: { Name: ASC }) {
        items {
          Id
          Name
          SectorCode
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

Variables:

```json
{
  "projectId": 12345,
  "first": 100,
  "after": null
}
```

## Relationship note

Sector membership is many-to-many and follows:

```text
CoordinationEntity
  -> SectorCoordinationEntityRel
  -> Sector
```

Do not assume a coordination entity has exactly one sector. See
[requirement rules](../reference/data-model.md) before combining sector links
with cost values.
