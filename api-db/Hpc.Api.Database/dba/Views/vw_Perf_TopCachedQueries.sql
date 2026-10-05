-- Show cached completed statements by CPU, reads, elapsed time and execution count.
CREATE   VIEW [dba].[vw_Perf_TopCachedQueries]
AS
SELECT qs.execution_count AS ExecutionCount,qs.creation_time AS PlanCreationTime,qs.last_execution_time AS LastExecutionTime,qs.plan_generation_num AS PlanGenerationNumber,qs.query_hash AS QueryHash,qs.query_plan_hash AS QueryPlanHash,qs.sql_handle AS SqlHandle,qs.plan_handle AS PlanHandle,DB_NAME(st.dbid) AS DatabaseName,OBJECT_SCHEMA_NAME(st.objectid,st.dbid) AS SchemaName,OBJECT_NAME(st.objectid,st.dbid) AS ObjectName,CONVERT(decimal(20,2),qs.total_worker_time/1000.0) AS TotalCpuTimeMs,CONVERT(decimal(20,2),qs.total_elapsed_time/1000.0) AS TotalElapsedTimeMs,qs.total_logical_reads AS TotalLogicalReads,qs.total_logical_writes AS TotalLogicalWrites,qs.total_physical_reads AS TotalPhysicalReads,CONVERT(decimal(18,2),qs.total_worker_time*1.0/NULLIF(qs.execution_count,0)/1000.0) AS AvgCpuTimeMs,CONVERT(decimal(18,2),qs.total_elapsed_time*1.0/NULLIF(qs.execution_count,0)/1000.0) AS AvgElapsedTimeMs,CONVERT(decimal(18,2),qs.total_logical_reads*1.0/NULLIF(qs.execution_count,0)) AS AvgLogicalReads,CONVERT(decimal(18,2),qs.total_logical_writes*1.0/NULLIF(qs.execution_count,0)) AS AvgLogicalWrites,CONVERT(decimal(18,2),qs.max_worker_time/1000.0) AS MaxCpuTimeMs,CONVERT(decimal(18,2),qs.max_elapsed_time/1000.0) AS MaxElapsedTimeMs,qs.max_logical_reads AS MaxLogicalReads,qs.last_logical_reads AS LastLogicalReads,SUBSTRING(st.text,(qs.statement_start_offset/2)+1,(((CASE WHEN qs.statement_end_offset=-1 THEN DATALENGTH(st.text) ELSE qs.statement_end_offset END)-qs.statement_start_offset)/2)+1) AS StatementText,st.text AS BatchText
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st;

GO

