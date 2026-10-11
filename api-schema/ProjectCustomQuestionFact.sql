-- Create public API view for current visible ProjectCustomQuestionFact records.
CREATE   VIEW api.[ProjectCustomQuestionFact]
AS
SELECT
    [Id],
    [ProjectId],
    [PlanId],
    [CustomQuestionId],
    [ValueText],
    [ValueNumber],
    [ValueBit],
    [ValueJson],    
    [CreatedAt],
    [UpdatedAt]
FROM serve.[ProjectCustomQuestionFact]
WHERE VisibilityGroupId = 1
  AND RecordStatus = 'Active'

GO

