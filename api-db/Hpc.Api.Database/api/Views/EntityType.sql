-- Create public API view for current visible EntityType records.
CREATE   VIEW api.[EntityType]
AS
SELECT
    [Id],
    [Name],
    [DisplayName],
    [EntitySubType],
    [PgSqlEntityType],
    [PgSqlRefCode],
    [Description],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[EntityType]
WHERE RecordStatus = 'Active'

GO

