-- Create public API view for current visible CoordinationEntity records.
CREATE   VIEW api.[CoordinationEntity]
AS
SELECT
    [Id],
    [EntityTypeId],
    [PlanId],
    [Name],
    [Description],
    [CustomReference],
    [ComposedReference],
    [IsOverriding],
    [HPCTags],
    [IconId],
    [HpcEntityPrototypeId],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[CoordinationEntity]
WHERE VisibilityGroupId = 1
  AND RecordStatus = 'Active'

GO

