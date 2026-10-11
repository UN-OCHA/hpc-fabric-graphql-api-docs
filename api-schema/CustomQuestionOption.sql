-- Create public API view for current visible CustomQuestionOption records.
CREATE   VIEW api.[CustomQuestionOption]
AS
SELECT
    [Id],
    [CustomQuestionId],
    [OptionCode],
    [OptionValue],
    [OptionLabel],
    [OptionJson],
    [SortOrder],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[CustomQuestionOption]
WHERE RecordStatus = 'Active'

GO

