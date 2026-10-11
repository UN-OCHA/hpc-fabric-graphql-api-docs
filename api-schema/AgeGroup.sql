-- Create public API view for current visible AgeGroup records.
CREATE   VIEW api.[AgeGroup]
AS
SELECT
    [Id],
    [Name],
    [Description],
    [CreatedAt],
    [UpdatedAt],
    [ReferenceCode]
FROM serve.[AgeGroup]
WHERE RecordStatus = 'Active'

GO

