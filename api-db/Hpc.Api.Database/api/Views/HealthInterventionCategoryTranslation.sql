CREATE   VIEW api.[HealthInterventionCategoryTranslation]
AS
SELECT
    HealthInterventionCategoryId,
    LanguageCode,
    Name,
    Description,
    CreatedAt,
    UpdatedAt
FROM serve.HealthInterventionCategoryTranslation
WHERE RecordStatus = 'Active';

GO

