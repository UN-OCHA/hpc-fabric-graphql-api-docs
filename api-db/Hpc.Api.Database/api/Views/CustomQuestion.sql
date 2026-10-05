-- Create public API view for current visible CustomQuestion records.
CREATE   VIEW api.[CustomQuestion]
AS
SELECT
    [Id],
    [PlanId],
    [Name],
    [FieldType],
    [Description],
    [SortOrder],
    [IsRequired],
    [IsGrouping],
    [MinValue],
    [MaxValue],
    [MaxLength],
    [IsMultiSelect],
    [RulesJson],
    [LabelJson],
    [DefinitionJson],
    [DisplayLabel],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[CustomQuestion]
WHERE VisibilityGroupId = 1
  AND RecordStatus = 'Active'

GO

