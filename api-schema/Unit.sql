-- Create public API view for current visible Unit records.
CREATE   VIEW api.[Unit]
AS
SELECT
    [Id],
    [Name],
    [NameFrench],
    [Description],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[Unit]
WHERE RecordStatus = 'Active'

GO

