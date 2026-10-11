
-- Create public API view for project plan/custom fields.
CREATE   VIEW api.ProjectPlanField
AS
SELECT
    ProjectId,
    PlanId,
    CustomQuestionId,
    QuestionName,
    QuestionDisplayLabel,
    QuestionDescription,
    FieldType,
    QuestionSortOrder,
    IsRequired,
    IsGrouping,
    IsMultiSelect,
    MinValue,
    MaxValue,
    MaxLength,
    OptionCode,
    OptionValue,
    OptionLabel,
    AnswerText,
    AnswerNumber,
    AnswerBit,
    AnswerJson,
    DependencyJson,
    CreatedAt,
    UpdatedAt
FROM serve.ProjectPlanField
WHERE VisibilityGroupId = 1
  AND RecordStatus = 'Active';

GO

