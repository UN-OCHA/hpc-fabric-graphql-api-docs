
CREATE   VIEW api.FileAsset
AS
SELECT
    Id,
    Name,
    OriginalName,
    MimeType,
    Credit,
    VisibilityGroupId,
    FileAssetTypeId,
    FilePath,
    Url,
    CreatedAt,
    UpdatedAt,
    AzureFileURL
FROM serve.FileAsset
WHERE VisibilityGroupId = 1
  AND RecordStatus = 'Active';

GO

