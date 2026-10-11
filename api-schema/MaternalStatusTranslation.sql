CREATE   VIEW api.[MaternalStatusTranslation]
AS
SELECT
    MaternalStatusId,
    LanguageCode,
    Name,
    Description,
    CreatedAt,
    UpdatedAt
FROM serve.MaternalStatusTranslation
WHERE RecordStatus = 'Active';

GO

