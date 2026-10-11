-- Create public API view for current visible LogframeEntity records.
CREATE   VIEW api.[LogframeEntity]
AS
SELECT
    [Id],
    [EntityTypeId],
    [PlanId],
    [Name],
    [Description],
    [CoordinationEntityId],
    [CustomReference],
    [ComposedReference],
    [SortOrder],
    [HpcEntityPrototypeId],
    [NamePrefix],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[LogframeEntity]
WHERE VisibilityGroupId = 1
  AND RecordStatus = 'Active'

GO

