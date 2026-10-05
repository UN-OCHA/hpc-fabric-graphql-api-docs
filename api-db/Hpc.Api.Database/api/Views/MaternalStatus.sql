-- Create public API view for current visible MaternalStatus records.
CREATE   VIEW api.[MaternalStatus]
AS
SELECT
    [Id],
    [Name],
    [Description],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[MaternalStatus]
WHERE RecordStatus = 'Active'

GO

