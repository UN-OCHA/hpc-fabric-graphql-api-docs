-- Create public API view for current visible CategoryType records.
CREATE   VIEW api.[CategoryType]
AS
SELECT
    [Id],
    [Name],
    [DisplayName],
    [Description],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[CategoryType]
WHERE RecordStatus = 'Active'

GO

