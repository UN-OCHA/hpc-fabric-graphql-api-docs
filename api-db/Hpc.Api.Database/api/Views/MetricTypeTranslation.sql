CREATE   VIEW api.[MetricTypeTranslation]
AS
SELECT
    MetricTypeId,
    LanguageCode,
    Name,
    Description,
    CreatedAt,
    UpdatedAt
FROM serve.MetricTypeTranslation
WHERE RecordStatus = 'Active';

GO

