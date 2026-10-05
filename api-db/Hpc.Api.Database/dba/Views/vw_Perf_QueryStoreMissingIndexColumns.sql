-- Show missing-index columns embedded in retained Query Store plans.
CREATE   VIEW [dba].[vw_Perf_QueryStoreMissingIndexColumns]
AS
WITH Plans AS (SELECT p.query_id,p.plan_id,p.is_forced_plan,TRY_CONVERT(xml,p.query_plan) AS PlanXml FROM sys.query_store_plan AS p WHERE p.query_plan IS NOT NULL)
SELECT p.query_id AS QueryId,p.plan_id AS PlanId,p.is_forced_plan AS IsForcedPlan,g.n.value('(@Impact)[1]','decimal(18,4)') AS EstimatedImpactPercent,m.n.value('(@Database)[1]','nvarchar(256)') AS DatabaseName,m.n.value('(@Schema)[1]','nvarchar(256)') AS SchemaName,m.n.value('(@Table)[1]','nvarchar(256)') AS TableName,cg.n.value('(@Usage)[1]','nvarchar(60)') AS ColumnUsage,c.n.value('(@Name)[1]','nvarchar(256)') AS ColumnName,c.n.value('(@ColumnId)[1]','int') AS ColumnId
FROM Plans AS p
CROSS APPLY p.PlanXml.nodes('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/showplan"; //MissingIndexGroup') AS g(n)
CROSS APPLY g.n.nodes('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/showplan"; MissingIndex') AS m(n)
CROSS APPLY m.n.nodes('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/showplan"; ColumnGroup') AS cg(n)
CROSS APPLY cg.n.nodes('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/showplan"; Column') AS c(n)
WHERE p.PlanXml IS NOT NULL;

GO

