-- Create public API view for current visible Currency records.
CREATE   VIEW api.[Currency]
AS
SELECT
    [Id],
    [Code],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[Currency]
WHERE RecordStatus = 'Active'

GO

