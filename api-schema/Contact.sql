
-- Create public API view for current visible Contact records.
CREATE   VIEW api.[Contact]
AS
SELECT
    [Id],
    [Name],
    [Email],
    [Phone],
    [Website],
    [Address],
    [Department],
    [JobTitle],
    [Role],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[Contact]
WHERE RecordStatus = 'Active'

GO

