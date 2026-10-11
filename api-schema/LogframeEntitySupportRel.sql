
CREATE   VIEW api.LogframeEntitySupportRel
AS
SELECT
    LogframeEntityId,
    SupportsLogframeEntityId,
    SortOrder
FROM serve.LogframeEntitySupportRel;

GO

