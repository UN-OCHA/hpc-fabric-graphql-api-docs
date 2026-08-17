# Data model and rules

## Main relationships

| Starting entity | Related data |
| --- | --- |
| Plan | Period/year, location, emergency, project, coordination entity, organization, attachment |
| Project | Plan, sector, coordination entity, organization, location |
| Coordination entity | Plan, sector, entity type, cost attachment |
| Attachment | Plan or other entity and its attachment facts |
| Attachment fact | Requirement value and revision state |
| Sector | Coordination entity through `SectorCoordinationEntityRel` |
| Organization | Plans, projects, categories, locations, hierarchy relationships |

Relationships exposed in the GraphQL schema do not guarantee that every
historical record has a populated foreign key. They also do not turn a
many-to-many relationship into a one-to-one relationship.

## Requirement revision logic

```text
RevisionStateId 1 = original requirement
RevisionStateId 2 = current requirement
If state 2 is absent, state 1 represents both original and current
```

Apply fallback at the entity being reported—not once for an entire result set.
For example, a sector report should apply the rule independently for each
coordination entity before it aggregates values.

## Sector requirement relationship

Follow sector costs through these two paths and join on the coordination entity:

```text
Attachment.EntityId
  -> CoordinationEntity.Id
  -> SectorCoordinationEntityRel
  -> Sector.Id

Attachment.Id
  -> AttachmentFact.AttachmentId
```

Do not depend only on `AttachmentFact.SectorId`; it can be null for historical
records.

One coordination entity can be linked to several sectors. Repeating its entire
cost for each sector overstates the total. Consumers need an agreed allocation
or reporting rule for that case.

## Project and organization amounts

`Project.CurrentRequestedFunds` is a project-level amount. If one project has
several organizations, the same value is returned alongside each related
organization. It is not an organization-specific allocation.

The current schema does not expose a separate project original requirement or a
specific allocation of requirements between organizations.

## Organization classifications

Organization type and level are not direct scalar fields in the current schema.
Where those concepts are represented by categories, first discover the category
types and exact category values, then filter through the `category` relationship.

Organization hierarchy is exposed as parent-child edges. The API does not
calculate hierarchy depth.

## FTS funding-flow coverage

The current GraphQL schema covers plan metadata and requirements, but not the
complete FTS funding-flow model.

| Information | Current schema |
| --- | --- |
| Countries, years, currencies | Available |
| Plans, projects, emergencies | Available |
| Sectors, coordination entities | Available |
| Plan original/current requirements | Available |
| Coordination-entity requirement rows | Available |
| Project current requested funds | Available |
| Project original requirements | Not exposed |
| Organization-specific requirement allocations | Not exposed |
| Funding totals and progress | Not exposed |
| Funding sources and donors | Not exposed |
| Funding trends | Not exposed |
| Shared, overlap, and single funding | Not exposed |

Funding-source, trend, and funding-flow custom-search endpoints cannot be
reproduced exactly until the required funding-flow data is included in the
Fabric GraphQL API.

