-- Create public API view for current visible CustomQuestionDependency records.
CREATE   VIEW api.[CustomQuestionDependency]
AS
SELECT
    [Id],
    [CustomQuestionId],
    [DependsOnCustomQuestionId],    
    [CreatedAt],
    [UpdatedAt]
FROM serve.[CustomQuestionDependency]
WHERE RecordStatus = 'Active'

GO

