
CREATE   VIEW api.[MeasurementFact]
AS
SELECT
    [Id],
    [AttachmentId],
    [MeasurementId],
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
    [IsTotal],
    [ValueNum],
    [CustomMetricName],
    [DerivedMetricSource],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[MeasurementFact]
WHERE VisibilityGroupId = 1;

GO

