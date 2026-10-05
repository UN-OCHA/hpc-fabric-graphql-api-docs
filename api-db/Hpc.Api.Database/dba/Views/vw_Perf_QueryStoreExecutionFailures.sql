-- Show Query Store aborted and exception executions.
CREATE   VIEW [dba].[vw_Perf_QueryStoreExecutionFailures]
AS
WITH FailureAggregated AS (SELECT rs.plan_id,rs.runtime_stats_interval_id,rs.execution_type,rs.execution_type_desc,SUM(rs.count_executions) AS ExecutionCount,MIN(rs.first_execution_time) AS FirstExecutionTime,MAX(rs.last_execution_time) AS LastExecutionTime,SUM(CONVERT(float,rs.avg_cpu_time)*rs.count_executions)/NULLIF(SUM(rs.count_executions),0)/1000.0 AS AvgCpuMs,SUM(CONVERT(float,rs.avg_duration)*rs.count_executions)/NULLIF(SUM(rs.count_executions),0)/1000.0 AS AvgDurationMs,SUM(CONVERT(float,rs.avg_logical_io_reads)*rs.count_executions)/NULLIF(SUM(rs.count_executions),0) AS AvgLogicalReads FROM sys.query_store_runtime_stats AS rs WHERE rs.execution_type IN (3,4) GROUP BY rs.plan_id,rs.runtime_stats_interval_id,rs.execution_type,rs.execution_type_desc)
SELECT p.query_id AS QueryId,fa.plan_id AS PlanId,fa.runtime_stats_interval_id AS RuntimeStatsIntervalId,rsi.start_time AS IntervalStartUtc,rsi.end_time AS IntervalEndUtc,fa.execution_type AS ExecutionType,fa.execution_type_desc AS ExecutionTypeDescription,fa.ExecutionCount,fa.FirstExecutionTime,fa.LastExecutionTime,CONVERT(decimal(18,2),fa.AvgCpuMs) AS AvgCpuMs,CONVERT(decimal(18,2),fa.AvgDurationMs) AS AvgDurationMs,CONVERT(decimal(18,2),fa.AvgLogicalReads) AS AvgLogicalReads,q.query_hash AS QueryHash,p.query_plan_hash AS QueryPlanHash,p.is_forced_plan AS IsForcedPlan,qt.query_sql_text AS QueryText
FROM FailureAggregated AS fa
INNER JOIN sys.query_store_runtime_stats_interval AS rsi ON rsi.runtime_stats_interval_id=fa.runtime_stats_interval_id
INNER JOIN sys.query_store_plan AS p ON p.plan_id=fa.plan_id
INNER JOIN sys.query_store_query AS q ON q.query_id=p.query_id
INNER JOIN sys.query_store_query_text AS qt ON qt.query_text_id=q.query_text_id;

GO

