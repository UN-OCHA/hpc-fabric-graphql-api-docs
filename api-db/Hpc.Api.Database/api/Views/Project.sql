-- Create public API view for current visible Project records.
CREATE   VIEW api.[Project]
AS
SELECT
    [Id],
    [Name],
    [ProjectCode],
    [Description],
    [StartDate],
    [EndDate],
    [IsPublished],
    [Objective],
    [ImplementingPartners],
    [ImplementationStatus],
    [CurrentRequestedFunds],
	[TotalProjectTarget],
    [PlanId],
    [PgSqlPdf],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[Project]
WHERE VisibilityGroupId = 1
  AND RecordStatus = 'Active'

GO

