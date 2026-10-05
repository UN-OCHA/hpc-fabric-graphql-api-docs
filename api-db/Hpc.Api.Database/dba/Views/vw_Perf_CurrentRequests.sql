-- Show current running requests, waits, blocking, parallelism and SQL text.
CREATE   VIEW [dba].[vw_Perf_CurrentRequests]
AS
SELECT r.session_id AS SessionId,r.request_id AS RequestId,r.start_time AS RequestStartTime,r.status AS Status,r.command AS Command,r.blocking_session_id AS BlockingSessionId,CONVERT(bit,CASE WHEN ISNULL(r.blocking_session_id,0)<>0 THEN 1 ELSE 0 END) AS IsBlocked,r.wait_type AS WaitType,r.last_wait_type AS LastWaitType,r.wait_time AS WaitTimeMs,r.wait_resource AS WaitResource,r.cpu_time AS CpuTimeMs,r.total_elapsed_time AS TotalElapsedTimeMs,CONVERT(decimal(18,2),r.cpu_time*1.0/NULLIF(r.total_elapsed_time,0)) AS CpuToElapsedRatio,r.logical_reads AS LogicalReads,r.reads AS Reads,r.writes AS Writes,r.row_count AS [RowCount],r.dop AS DegreeOfParallelism,r.parallel_worker_count AS ParallelWorkerCount,r.granted_query_memory AS GrantedQueryMemoryPages,CONVERT(decimal(18,2),r.granted_query_memory*8.0/1024.0) AS GrantedQueryMemoryMB,r.percent_complete AS PercentComplete,r.open_transaction_count AS OpenTransactionCount,r.transaction_id AS TransactionId,r.query_hash AS QueryHash,r.query_plan_hash AS QueryPlanHash,r.sql_handle AS SqlHandle,r.plan_handle AS PlanHandle,r.statement_sql_handle AS StatementSqlHandle,r.statement_context_id AS StatementContextId,r.dist_statement_id AS DistributedStatementId,DB_NAME(r.database_id) AS DatabaseName,s.is_user_process AS IsUserProcess,s.login_name AS LoginName,s.host_name AS HostName,s.program_name AS ProgramName,s.client_interface_name AS ClientInterfaceName,SUBSTRING(st.text,(r.statement_start_offset/2)+1,(((CASE WHEN r.statement_end_offset=-1 THEN DATALENGTH(st.text) ELSE r.statement_end_offset END)-r.statement_start_offset)/2)+1) AS StatementText,st.text AS BatchText
FROM sys.dm_exec_requests AS r
INNER JOIN sys.dm_exec_sessions AS s ON s.session_id=r.session_id
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
WHERE r.session_id<>@@SPID;

GO

