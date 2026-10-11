-- Create public API view for current visible DisaggregationCategoryOther records.
CREATE   VIEW api.[DisaggregationCategoryOther]
AS
SELECT
    [Id],
    [Name],
    [Description],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[DisaggregationCategoryOther]
WHERE RecordStatus = 'Active'

GO

