-- Show Query Store waits by query, plan, interval and wait category.
CREATE   VIEW [dba].[vw_Perf_QueryStoreWaits]
AS
WITH WaitAggregated AS (SELECT ws.plan_id,ws.runtime_stats_interval_id,ws.execution_type,ws.execution_type_desc,ws.wait_category,ws.wait_category_desc,SUM(ws.total_query_wait_time_ms) AS TotalWaitTimeMs,MAX(ws.last_query_wait_time_ms) AS LastWaitTimeMs,MIN(ws.min_query_wait_time_ms) AS MinWaitTimeMs,MAX(ws.max_query_wait_time_ms) AS MaxWaitTimeMs FROM sys.query_store_wait_stats AS ws GROUP BY ws.plan_id,ws.runtime_stats_interval_id,ws.execution_type,ws.execution_type_desc,ws.wait_category,ws.wait_category_desc),ExecutionAggregated AS (SELECT plan_id,runtime_stats_interval_id,execution_type,SUM(count_executions) AS ExecutionCount FROM sys.query_store_runtime_stats GROUP BY plan_id,runtime_stats_interval_id,execution_type)
SELECT p.query_id AS QueryId,wa.plan_id AS PlanId,wa.runtime_stats_interval_id AS RuntimeStatsIntervalId,rsi.start_time AS IntervalStartUtc,rsi.end_time AS IntervalEndUtc,wa.execution_type AS ExecutionType,wa.execution_type_desc AS ExecutionTypeDescription,wa.wait_category AS WaitCategory,wa.wait_category_desc AS WaitCategoryDescription,ISNULL(ea.ExecutionCount,0) AS ExecutionCount,wa.TotalWaitTimeMs,CONVERT(decimal(18,2),wa.TotalWaitTimeMs*1.0/NULLIF(ea.ExecutionCount,0)) AS AvgWaitTimePerExecutionMs,wa.LastWaitTimeMs,wa.MinWaitTimeMs,wa.MaxWaitTimeMs,q.query_hash AS QueryHash,p.query_plan_hash AS QueryPlanHash,p.is_forced_plan AS IsForcedPlan,qt.query_sql_text AS QueryText
FROM WaitAggregated AS wa
INNER JOIN sys.query_store_runtime_stats_interval AS rsi ON rsi.runtime_stats_interval_id=wa.runtime_stats_interval_id
INNER JOIN sys.query_store_plan AS p ON p.plan_id=wa.plan_id
INNER JOIN sys.query_store_query AS q ON q.query_id=p.query_id
INNER JOIN sys.query_store_query_text AS qt ON qt.query_text_id=q.query_text_id
LEFT JOIN ExecutionAggregated AS ea ON ea.plan_id=wa.plan_id AND ea.runtime_stats_interval_id=wa.runtime_stats_interval_id AND ea.execution_type=wa.execution_type;

GO

