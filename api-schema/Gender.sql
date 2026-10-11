-- Create public API view for current visible Gender records.
CREATE   VIEW api.[Gender]
AS
SELECT
    [Id],
    [Name],
    [ShortName],
    [Description],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[Gender]
WHERE RecordStatus = 'Active'

GO

