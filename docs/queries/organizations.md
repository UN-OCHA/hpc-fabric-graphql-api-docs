# Organization queries

Send each operation to the APIM endpoint as `query`, with the shown
`variables` in the same JSON body. Example IDs are sample values; replace them
with IDs from your data. Follow each collection's `hasNextPage` and `endCursor`.

## Organizations by name or ID

Implements the SQL-style condition `Name LIKE '%ocha%' OR Id = 123` and returns
the matching organizations with classifications, hierarchy relationships, and
locations.

```graphql
query OrganizationsByNameOrId(
  $nameContains: String!
  $organizationId: Int!
  $first: Int! = 100
  $after: String
) {
  organizations(
    first: $first
    after: $after
    filter: {
      or: [
        { Name: { contains: $nameContains } }
        { Id: { eq: $organizationId } }
      ]
    }
    orderBy: { Name: ASC }
  ) {
    items {
      Id
      Name
      Abbreviation
      NativeName
      Description
      url
      CollectiveInd
      IsVerified
      NewOrganizationId
      CreatedAt
      UpdatedAt

      classifications: category(first: 50, orderBy: { Name: ASC }) {
        items {
          categoryId: Id
          categoryName: Name
          Code
          ParentId
          CategoryTypeId

          categoryType {
            Id
            Name
            DisplayName
            Description
          }
        }
        hasNextPage
        endCursor
      }

      hierarchyRelationships: organizationParentChildRel(
        first: 50
        orderBy: { ParentOrganizationId: ASC }
      ) {
        items {
          ParentOrganizationId
          ChildOrganizationId

          organization {
            Id
            Name
            Abbreviation
          }
        }
        hasNextPage
        endCursor
      }

      locations: location(first: 20, orderBy: { Name: ASC }) {
        items {
          Id
          Name
          ISO3
          Pcode
          AdminLevel
          CountryId
          CountryISO3
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
  "nameContains": "ocha",
  "organizationId": 123,
  "first": 100,
  "after": null
}
```


Substring matching behavior, including case sensitivity, follows the data source and its collation.

## Governing or coordinating organizations by plan

Returns organizations directly related to a plan.

```graphql
query PlanOrganizations($planId: Int!) {
  plans(first: 1, filter: { Id: { eq: $planId } }) {
    items {
      Id
      Name

      organization(first: 100, orderBy: { Name: ASC }) {
        items {
          Id
          Name
          Abbreviation
          url
          IsVerified
          CollectiveInd
        }
        hasNextPage
        endCursor
      }
    }
  }
}
```

Variables:

```json
{
  "planId": 1202
}
```

## Project organizations and current requirements

Returns projects for a plan, their current requested funds, and their related
organizations.

```graphql
query OrganizationProjectRequirements(
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
      ProjectCode
      Name
      currentRequirements: CurrentRequestedFunds

      organization(first: 50, orderBy: { Name: ASC }) {
        items {
          Id
          Name
          Abbreviation
          CollectiveInd
          IsVerified
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

If a project has several organizations, the same project-level
`CurrentRequestedFunds` appears beside each relationship. Do not sum it once per
organization unless that duplication is explicitly intended.

## Discover classification values

Run this before filtering organizations by category names. It returns category
types and organization-related categories used by projects in a plan.

```graphql
query OrganizationClassificationValues(
  $planId: Int!
  $first: Int! = 100
  $after: String
) {
  categoryTypes(first: 100, orderBy: { Name: ASC }) {
    items {
      Id
      Name
      DisplayName
      Description
    }
    hasNextPage
    endCursor
  }

  organizationCategories: categories(
    first: $first
    after: $after
    filter: { organization: { project: { PlanId: { eq: $planId } } } }
    orderBy: { Name: ASC }
  ) {
    items {
      Id
      Name
      Code
      ParentId
      CategoryTypeId

      categoryType {
        Id
        Name
        DisplayName
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

## Organizations by plan, type, and level

Replace `typeName` and `levelName` with exact values returned by the discovery
query.

```graphql
query OrganizationsByTypeAndLevel(
  $planId: Int!
  $typeName: String!
  $levelName: String!
  $first: Int! = 100
  $after: String
) {
  organizations(
    first: $first
    after: $after
    filter: {
      project: { PlanId: { eq: $planId } }
      and: [
        { category: { Name: { eq: $typeName } } }
        { category: { Name: { eq: $levelName } } }
      ]
    }
    orderBy: { Name: ASC }
  ) {
    items {
      Id
      Name
      Abbreviation
      url
      CollectiveInd
      IsVerified

      category(first: 20, orderBy: { Name: ASC }) {
        items {
          Id
          Name
          Code
          ParentId
          CategoryTypeId

          categoryType {
            Id
            Name
            DisplayName
          }
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
  "typeName": "REPLACE WITH EXACT TYPE",
  "levelName": "REPLACE WITH EXACT LEVEL",
  "first": 100,
  "after": null
}
```


These examples use categories rather than direct `OrganizationType` or
`OrganizationLevel` fields. This pattern applies only where those classifications are represented by
organization categories.

## Organization hierarchy edges

```graphql
query OrganizationHierarchy($first: Int! = 100, $after: String) {
  organizationParentChildRels(first: $first, after: $after) {
    items {
      ParentOrganizationId
      ChildOrganizationId
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

The API returns parent-child edges. Calculate hierarchy depth (level 1, level 2,
and so on) in the consuming application.
