-- Create public API view for current visible Category records.
CREATE   VIEW api.[Category]
AS
SELECT
    [Id],
    [Name],
    [CategoryTypeId],
    [Description],
    [ParentId],
    [Code],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[Category]
WHERE RecordStatus = 'Active'

GO

