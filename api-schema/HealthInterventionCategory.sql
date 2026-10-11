-- Create public API view for current visible HealthInterventionCategory records.
CREATE   VIEW api.[HealthInterventionCategory]
AS
SELECT
    [Id],
    [Name],
    [Description],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[HealthInterventionCategory]
WHERE RecordStatus = 'Active'

GO

