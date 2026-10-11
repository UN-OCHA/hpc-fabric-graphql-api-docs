CREATE   VIEW api.[DisaggregationCategoryOtherTranslation]
AS
SELECT
    DisaggregationCategoryOtherId,
    LanguageCode,
    Name,
    Description,
    CreatedAt,
    UpdatedAt
FROM serve.DisaggregationCategoryOtherTranslation
WHERE RecordStatus = 'Active';

GO

