
CREATE    VIEW [api].[AttachmentFact]
AS
SELECT
    [Id],
    [AttachmentId],
    [MetricTypeId],
    [LocationId],
    [GenderId],
    [AgeGroupId],
    [PopulationStatusId],
    [SettlementTypeId],
    [DisabilityStatusId],
    [HealthInterventionCategoryId],
    [MaternalStatusId],
    [DisaggregationCategoryOtherId],
    [DeliveryModalityId],
    [RevisionStateId],
    [SectorId],
    [IsTotal],
    [ValueNum],
    [CustomMetricName],
    DerivedMetricSource,
    [CreatedAt],
    [UpdatedAt]
FROM serve.[AttachmentFact]
WHERE VisibilityGroupId = 1;

GO

