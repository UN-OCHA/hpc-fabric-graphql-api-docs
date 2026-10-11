-- Create public API view for current visible Location records.
CREATE    VIEW [api].[Location]
AS
SELECT
    [Id],
    [Name],
    [AdminLevel],
    [ISO3],
    [Pcode],
    [Description],
    [Latitude],
    [Longitude],
    [ParentId],
    RecordStatus,
    ActiveUntil,
    [CountryId],
    [CountryISO3],
    [Path],
    [CreatedAt],
    [UpdatedAt]    
FROM serve.[Location]

GO

