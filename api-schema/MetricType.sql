-- Create public API view for current visible MetricType records.
CREATE   VIEW api.[MetricType]
AS
SELECT
    [Id],
    [Name],
    [NameFr],
    [NameEs],
    [LabelLookup],
    [OtherName],
    [HPCType],
    [MetricHPCCategory],
    [Description],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[MetricType]
WHERE RecordStatus = 'Active'

GO

