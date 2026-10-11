-- Create public API view for current visible SettlementType records.
CREATE   VIEW api.[SettlementType]
AS
SELECT
    [Id],
    [Name],
    [Description],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[SettlementType]
WHERE RecordStatus = 'Active'

GO

