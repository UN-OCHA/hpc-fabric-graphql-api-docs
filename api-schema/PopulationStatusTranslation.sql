CREATE   VIEW api.[PopulationStatusTranslation]
AS
SELECT
    PopulationStatusId,
    LanguageCode,
    Name,
    ShortName,
    Description,
    CreatedAt,
    UpdatedAt
FROM serve.PopulationStatusTranslation
WHERE RecordStatus = 'Active';

GO

