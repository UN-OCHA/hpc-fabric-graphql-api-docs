-- Show physical indexes referenced by Query Store execution plans.
CREATE   VIEW [dba].[vw_Perf_QueryStorePlanIndexes]
AS
WITH Plans AS (SELECT p.query_id,p.plan_id,p.is_forced_plan,p.plan_forcing_type_desc,p.plan_type_desc,TRY_CONVERT(xml,p.query_plan) AS PlanXml FROM sys.query_store_plan AS p WHERE p.query_plan IS NOT NULL)
SELECT DISTINCT p.query_id AS QueryId,p.plan_id AS PlanId,p.is_forced_plan AS IsForcedPlan,p.plan_forcing_type_desc AS PlanForcingType,p.plan_type_desc AS PlanType,r.n.value('(@NodeId)[1]','int') AS PlanNodeId,r.n.value('(@PhysicalOp)[1]','nvarchar(128)') AS PhysicalOperation,r.n.value('(@LogicalOp)[1]','nvarchar(128)') AS LogicalOperation,x.n.value('(@Database)[1]','nvarchar(256)') AS DatabaseName,x.n.value('(@Schema)[1]','nvarchar(256)') AS SchemaName,x.n.value('(@Table)[1]','nvarchar(256)') AS TableName,x.n.value('(@Index)[1]','nvarchar(256)') AS IndexName,x.n.value('(@IndexKind)[1]','nvarchar(128)') AS IndexKind,x.n.value('(@Storage)[1]','nvarchar(128)') AS StorageType
FROM Plans AS p
CROSS APPLY p.PlanXml.nodes('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/showplan"; //RelOp[*/Object[@Index]]') AS r(n)
CROSS APPLY r.n.nodes('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/showplan"; */Object[@Index]') AS x(n)
WHERE p.PlanXml IS NOT NULL;

GO

