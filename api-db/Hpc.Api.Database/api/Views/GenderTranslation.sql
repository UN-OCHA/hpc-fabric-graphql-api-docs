CREATE   VIEW api.[GenderTranslation]
AS
SELECT
    GenderId,
    LanguageCode,
    Name,
    ShortName,
    Description,
    CreatedAt,
    UpdatedAt
FROM serve.GenderTranslation
WHERE RecordStatus = 'Active';

GO

