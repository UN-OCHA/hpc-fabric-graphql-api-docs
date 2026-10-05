-- Create public API view for current visible DisabilityStatus records.
CREATE   VIEW api.[DisabilityStatus]
AS
SELECT
    [Id],
    [Name],
    [Description],
    [Kind],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[DisabilityStatus]
WHERE RecordStatus = 'Active'

GO

