# Data rules

These rules describe the supplied query examples. Check the published schema and
the existing `api-schema/` view definitions when extending them.

## Main relationships

| Entity | Related information |
| --- | --- |
| Plan | Periods, locations, projects, organizations, coordination entities, attachments |
| Project | Plan, sectors, organizations, coordination entities |
| Coordination entity | Plan, sectors, entity type and cost attachments |
| Attachment | Entity and attachment facts |
| Attachment fact | Requirement amount and revision state |
| Organization | Categories, projects, locations and hierarchy links |

Not every historical relationship is populated. Many relationships have multiple
records; joining them can repeat the same amount.

## Original and current requirements

Requirement amounts in the examples use `AttachmentFact.ValueNum`:

- Revision state 1: original requirement.
- Revision state 2: current requirement.
- If state 2 is absent, use state 1 as both original and current.

Apply fallback per entity being reported, after collecting all relevant rows.
A current value of zero is a value; it is not the same as a missing current record.
The requirement examples filter cost attachments and `IsTotal: true`.
Do not add total rows to their breakdown rows.

## Sector amounts

The requirement example joins `attachment.EntityId` to the coordination entity ID,
then follows its sector relationship. Do not rely only on
`AttachmentFact.SectorId`; total rows can have a null sector ID.

A coordination entity can cover several sectors. Assigning its whole cost to
each sector duplicates the amount. Use an agreed allocation rule or report the
combined entity total. [Requirement queries](../queries/requirements.md) show
the separate roots and join keys.

## Projects and organizations

`Project.CurrentRequestedFunds` belongs to the project. If the project is linked
to several organizations, its amount must not be counted once per organization.
The supplied examples do not provide organization-specific allocations or a
separate project original requirement.

Organization classifications use category relationships in the supplied examples.
Discover category values before filtering by type or level. Hierarchy queries
return parent-child links; calculate depth in the consuming application.

## Coverage

The catalogue covers metadata and requirements. It does not provide examples
for FTS funding flows, donors, funding trends or progress totals. Confirm that
the required data is exposed before attempting to replace those integrations.
