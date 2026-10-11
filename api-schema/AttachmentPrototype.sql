-- Create public API view for current visible AttachmentPrototype records.
CREATE   VIEW api.[AttachmentPrototype]
AS
SELECT
    [Id],
    [RefCode],
    [Type],
    [Value],
    [Value2],
    [PlanId],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[AttachmentPrototype]
WHERE RecordStatus = 'Active'

GO

