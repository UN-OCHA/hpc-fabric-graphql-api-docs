
-- Create public API view for current visible Organization records.
CREATE   VIEW [api].[Organization]
AS
SELECT
    [Id],
    [Name],
    [Abbreviation],
    [Url],
    [NativeName],
    [Comments],
    [Notes],
    [CollectiveInd],
    [IsVerified],
    [NewOrganizationId],
    [Description],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[Organization]

GO

