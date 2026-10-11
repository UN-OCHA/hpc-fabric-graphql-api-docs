-- Create public API view for current visible EntityPrototype records.
CREATE   VIEW api.[EntityPrototype]
AS
SELECT
    [Id],
    [RefCode],
    [Type],
    [PlanId],
    [OrderNumber],
    [Value],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[EntityPrototype]
WHERE RecordStatus = 'Active'

GO

