
-- Create public API view for current visible UserAccount records.
CREATE   VIEW api.[UserAccount]
AS
SELECT
    [Id],
    [Email],
    [Name],
    [IsActive],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[UserAccount]
WHERE RecordStatus = 'Active'

GO

