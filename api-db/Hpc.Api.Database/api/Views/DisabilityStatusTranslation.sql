CREATE   VIEW api.[DisabilityStatusTranslation]
AS
SELECT
    DisabilityStatusId,
    LanguageCode,
    Name,
    Description,
    CreatedAt,
    UpdatedAt
FROM serve.DisabilityStatusTranslation
WHERE RecordStatus = 'Active';

GO

