CREATE VIEW [api].[ProjectBudget]
AS
SELECT
    [Id],
    [ProjectId],
    [BudgetSegmentName],
    [BudgetLineItemName],
    [BudgetBreakdownType],
    [Amount],
    [PercentValue],
    [ContentJson],
    [CreatedAt],
    [UpdatedAt]
FROM [serve].[ProjectBudget]
WHERE [RecordStatus] = 'Active';
GO