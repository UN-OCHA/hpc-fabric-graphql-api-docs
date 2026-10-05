
CREATE   VIEW api.FileAssetType
AS
SELECT
    Id,
    Name,
    DisplayName,
    Description,
    CreatedAt,
    UpdatedAt
FROM serve.FileAssetType
WHERE RecordStatus = 'Active';

GO

