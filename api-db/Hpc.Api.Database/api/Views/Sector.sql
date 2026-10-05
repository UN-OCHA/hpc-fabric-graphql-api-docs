-- Create public API view for current visible Sector records.
CREATE   VIEW api.[Sector]
AS
SELECT
    [Id],
    [Name],
    [SectorType],
    [SectorCode],
    [Description],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[Sector]
WHERE VisibilityGroupId = 1
  AND RecordStatus = 'Active'

GO

