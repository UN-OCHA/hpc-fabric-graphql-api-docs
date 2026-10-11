
CREATE   VIEW api.[Measurement]
AS
SELECT
    [Id],
    [Name],
    [PlanId],
    [AttachmentId],
    [MeasurementPeriodId],
    [EntityId],
    [EntityTypeId],
    [EntityMainType],
    [MeasurementType],
    [CustomReference],
    [UnitId],
    [CalculationMethod],
    [Description],
    [AttachmentPrototypeId],
    [IsCommentPublic],
    [Comments],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[Measurement]
WHERE VisibilityGroupId = 1
  AND RecordStatus = N'Active';

GO

