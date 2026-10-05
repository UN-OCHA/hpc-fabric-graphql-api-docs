
CREATE   VIEW api.TextContent
AS
SELECT
    Id,
    Name,
    Title,
    Description,
    ContentHtml,
    ContentPlainText,
    AsOfDate,
    VisibilityGroupId,
    TextContentTypeId,
    CreatedAt,
    UpdatedAt
FROM serve.TextContent
WHERE VisibilityGroupId = 1
  AND RecordStatus = 'Active';

GO

