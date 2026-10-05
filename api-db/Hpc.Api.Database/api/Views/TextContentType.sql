
CREATE   VIEW api.TextContentType
AS
SELECT
    Id,
    Name,
    DisplayName,
    Description,
    CreatedAt,
    UpdatedAt
FROM serve.TextContentType
WHERE RecordStatus = 'Active';

GO

