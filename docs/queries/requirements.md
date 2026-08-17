# Requirement queries

Requirement amounts are stored in `AttachmentFact.ValueNum`. Revision state 1
is original and revision state 2 is current. When state 2 is absent for an
entity, use state 1 as both original and current.

## Plan original and current totals

Returns plan metadata and two independently aggregated values.

```graphql
query PlanRequirements($planId: Int!) {
  plan: plans(first: 1, filter: { Id: { eq: $planId } }) {
    items {
      Id
      Name
      ShortName
      PlanCode
      PlanType
      PlanCosting
    }
  }

  originalRequirements: attachmentFacts(
    filter: {
      IsTotal: { eq: true }
      RevisionStateId: { eq: 1 }
      attachment: {
        PlanId: { eq: $planId }
        AttachmentType: { eq: "Cost" }
        EntityMainType: { eq: "Plan" }
      }
    }
  ) {
    groupBy(fields: [RevisionStateId]) {
      fields {
        RevisionStateId
      }
      aggregations {
        amount: sum(field: ValueNum)
      }
    }
  }

  currentRequirements: attachmentFacts(
    filter: {
      IsTotal: { eq: true }
      RevisionStateId: { eq: 2 }
      attachment: {
        PlanId: { eq: $planId }
        AttachmentType: { eq: "Cost" }
        EntityMainType: { eq: "Plan" }
      }
    }
  ) {
    groupBy(fields: [RevisionStateId]) {
      fields {
        RevisionStateId
      }
      aggregations {
        amount: sum(field: ValueNum)
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

If `currentRequirements.groupBy` is empty, use the original amount as the
current amount in the consuming application.

## Plan requirement rows by year

Returns rows for client-side grouping by plan and revision state. Paginate all
pages before aggregating.

```graphql
query PlanRequirementRowsByYear(
  $year: Int!
  $first: Int! = 100
  $after: String
) {
  requirementRows: attachmentFacts(
    first: $first
    after: $after
    filter: {
      IsTotal: { eq: true }
      RevisionStateId: { in: [1, 2] }
      attachment: {
        AttachmentType: { eq: "Cost" }
        EntityMainType: { eq: "Plan" }
        plan: { period: { CalendarYear: { eq: $year } } }
      }
    }
    orderBy: { AttachmentId: ASC }
  ) {
    items {
      AttachmentId
      RevisionStateId
      ValueNum

      revisionState {
        Id
        Name
        DisplayName
      }

      attachment {
        PlanId
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

Group the complete result by `attachment.PlanId + RevisionStateId`, then apply
the state-2 fallback per plan.

## Sector and coordination-entity requirement rows

This operation deliberately uses two shallow root selections rather than
nesting attachments and grouped facts under every coordination entity. It is
more reliable and exposes the keys required for a client-side join.

```graphql
query SectorRequirementRowsByPlan(
  $planId: Int!
  $entityFirst: Int! = 100
  $entityAfter: String
  $factFirst: Int! = 100
  $factAfter: String
) {
  coordinationEntities(
    first: $entityFirst
    after: $entityAfter
    filter: { PlanId: { eq: $planId } }
    orderBy: { Name: ASC }
  ) {
    items {
      coordinationEntityId: Id
      coordinationEntityName: Name
      EntityTypeId

      entityType {
        Id
        Name
        DisplayName
      }

      sector(first: 20, orderBy: { Name: ASC }) {
        items {
          sectorId: Id
          sectorName: Name
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

  costFacts: attachmentFacts(
    first: $factFirst
    after: $factAfter
    filter: {
      IsTotal: { eq: true }
      RevisionStateId: { in: [1, 2] }
      attachment: {
        PlanId: { eq: $planId }
        AttachmentType: { eq: "Cost" }
        EntityMainType: { eq: "CoordinationEntity" }
      }
    }
    orderBy: { AttachmentId: ASC }
  ) {
    items {
      attachmentFactId: Id
      AttachmentId
      RevisionStateId
      ValueNum

      revisionState {
        Id
        Name
        DisplayName
      }

      attachment {
        Id
        EntityId
        PlanId
        EntityMainType
        AttachmentType
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
  "entityFirst": 100,
  "entityAfter": null,
  "factFirst": 100,
  "factAfter": null
}
```

Join `costFacts.items[].attachment.EntityId` to
`coordinationEntities.items[].coordinationEntityId`. Paginate both root
connections and any sector list reporting another page. Apply revision fallback
per coordination entity before sector aggregation.

!!! warning "Many-to-many allocation"
    A coordination entity can be linked to multiple sectors. Assigning its full
    cost to every sector duplicates the amount. A business allocation rule is
    required before producing sector totals.

