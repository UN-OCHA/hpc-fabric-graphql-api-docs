CREATE VIEW [api].[ProjectBudgetOrganizationRel]
AS
SELECT
    ProjectBudgetId,
    OrganizationId
FROM [serve].[ProjectBudgetOrganizationRel];
GO