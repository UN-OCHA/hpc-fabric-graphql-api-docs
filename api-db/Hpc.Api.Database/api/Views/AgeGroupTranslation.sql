CREATE   VIEW api.[AgeGroupTranslation]
AS
SELECT
    AgeGroupId,
    LanguageCode,
    Name,
    Description,
    CreatedAt,
    UpdatedAt
FROM serve.AgeGroupTranslation
WHERE RecordStatus = 'Active';

GO

