-- Create public API view for current visible PopulationStatus records.
CREATE   VIEW api.[PopulationStatus]
AS
SELECT
    [Id],
    [Name],
    [ShortName],
    [Description],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[PopulationStatus]
WHERE RecordStatus = 'Active'

GO

