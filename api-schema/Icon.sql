-- Create public API view for current visible Icon records.
CREATE   VIEW api.[Icon]
AS
SELECT
    [Id],
    [Name],
    [FullName],
    [Svg],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[Icon]
WHERE RecordStatus = 'Active'

GO

