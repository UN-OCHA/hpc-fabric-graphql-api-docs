-- Link missing-index groups to the query hashes and latest SQL text that generated them.
CREATE   VIEW [dba].[vw_Perf_MissingIndexQueries]
AS
SELECT misq.group_handle AS IndexGroupHandle,mid.index_handle AS IndexHandle,misq.query_hash AS QueryHash,misq.query_plan_hash AS QueryPlanHash,misq.user_seeks AS UserSeeks,misq.user_scans AS UserScans,CONVERT(decimal(18,4),misq.avg_total_user_cost) AS AvgTotalUserCost,CONVERT(decimal(18,2),misq.avg_user_impact) AS AvgUserImpactPercent,misq.last_user_seek AS LastUserSeek,misq.last_user_scan AS LastUserScan,misq.last_sql_handle AS LastSqlHandle,misq.last_statement_sql_handle AS LastStatementSqlHandle,DB_NAME(mid.database_id) AS DatabaseName,OBJECT_SCHEMA_NAME(mid.object_id,mid.database_id) AS SchemaName,OBJECT_NAME(mid.object_id,mid.database_id) AS TableName,mid.equality_columns AS EqualityColumns,mid.inequality_columns AS InequalityColumns,mid.included_columns AS IncludedColumns,CASE WHEN st.text IS NULL THEN NULL WHEN misq.last_statement_start_offset<0 THEN st.text ELSE SUBSTRING(st.text,(misq.last_statement_start_offset/2)+1,(((CASE WHEN misq.last_statement_end_offset=-1 THEN DATALENGTH(st.text) ELSE misq.last_statement_end_offset END)-misq.last_statement_start_offset)/2)+1) END AS StatementText,st.text AS BatchText
FROM sys.dm_db_missing_index_group_stats_query AS misq
INNER JOIN sys.dm_db_missing_index_groups AS mig ON mig.index_group_handle=misq.group_handle
INNER JOIN sys.dm_db_missing_index_details AS mid ON mid.index_handle=mig.index_handle
OUTER APPLY sys.dm_exec_sql_text(misq.last_sql_handle) AS st
WHERE mid.database_id=DB_ID();

GO

