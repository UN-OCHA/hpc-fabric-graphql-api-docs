-- Create public API view for current visible Plan records.
CREATE        VIEW [api].[Plan]
AS
SELECT
    [Id],
    [Name],
    [ShortName],
    [Description],
    [PlanSubTitle],
    [StartDate],
    [EndDate],
    [PlanType],
    [PlanLanguage],
    [PlanLanguageCode],
    [PlanClusterType],
    [PlanCosting],
    [IsPartOfGHO],
    [IsForHPCProjects],
    [IsReleased],
    [ReleasedDate],
    [RevisionState],
    IsRestricted,
    [PlanCode],
    [CustomLocationCode],
    [FocusedLocationName],
    [FocusedLocationId],
    [CurrentReportingPeriodId],
    [LastPublishedReportingPeriodId],
    [DocumentPublishDate],
    [CreatedAt],
    [UpdatedAt],    
    IsLegacyCurrentVersion
FROM serve.[Plan]
WHERE VisibilityGroupId = 1
  AND RecordStatus = 'Active'

GO

