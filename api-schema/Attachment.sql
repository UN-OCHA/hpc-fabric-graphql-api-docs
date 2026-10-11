CREATE   VIEW api.[Attachment]
AS
SELECT
    [Id],
    [Name],
    [PlanId],
    [EntityId],
    [EntityTypeId],
    [EntityMainType],
    [AttachmentType],
    [CustomReference],
    [HasDisaggregatedData],
    [UnitId],
    [CalculationMethod],
    [Description],
    [AttachmentPrototypeId],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[Attachment]
WHERE VisibilityGroupId = 1
  AND RecordStatus = N'Active';

GO

