CREATE   VIEW api.[SettlementTypeTranslation]
AS
SELECT
    SettlementTypeId,
    LanguageCode,
    Name,
    Description,
    CreatedAt,
    UpdatedAt
FROM serve.SettlementTypeTranslation
WHERE RecordStatus = 'Active';

GO

