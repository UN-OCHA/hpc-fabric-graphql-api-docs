CREATE   VIEW api.[DeliveryModalityTranslation]
AS
SELECT
    DeliveryModalityId,
    LanguageCode,
    Name,
    Description,
    CreatedAt,
    UpdatedAt
FROM serve.DeliveryModalityTranslation
WHERE RecordStatus = 'Active';

GO

