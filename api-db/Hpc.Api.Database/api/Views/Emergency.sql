-- Create public API view for current visible Emergency records.
CREATE   VIEW api.[Emergency]
AS
SELECT
    [Id],
    [Name],
    [EmergencyType],
    [Description],
    [EmergencyDate],
    [GlideNumber],
    [IsLevel3],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[Emergency]
WHERE VisibilityGroupId = 1
  AND RecordStatus = 'Active'

GO

