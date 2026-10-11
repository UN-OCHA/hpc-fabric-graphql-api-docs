-- Create public API view for current visible PlanReportingPeriod records.
CREATE   VIEW api.[PlanReportingPeriod]
AS
SELECT
    [Id],
    [StartDate],
    [EndDate],
    [ExpiryDate],
    [PeriodNumber],
    [PlanId],
    [MeasurementsGenerated],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[PlanReportingPeriod]
WHERE RecordStatus = 'Active'

GO

