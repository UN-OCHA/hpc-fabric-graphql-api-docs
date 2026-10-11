
CREATE   VIEW api.ProjectAttachmentTarget AS
SELECT
    Id,
    ProjectId,
    AttachmentId,    
    ValueNum,
    VisibilityGroupId,
    CreatedAt,
    UpdatedAt
FROM serve.ProjectAttachmentTarget
WHERE VisibilityGroupId = 1;

GO

