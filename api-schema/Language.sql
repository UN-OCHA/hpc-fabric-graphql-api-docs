CREATE   VIEW api.[Language]
AS
SELECT
    Code,
    Name,
    NativeName,
    IsRtl,
    SortOrder,
    CreatedAt,
    UpdatedAt
FROM serve.[Language]
WHERE IsActive = 1;

GO

