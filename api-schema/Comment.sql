-- Create public API view for current visible Comment records.
CREATE   VIEW api.[Comment]
AS
SELECT
    [Id],
    [EntityTypeId],
    [EntityId],
    [UserAccountId],
    [CommentText],
    [Step],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[Comment]
WHERE VisibilityGroupId = 1
  AND RecordStatus = 'Active'

GO

