-- Show missing-index candidates generated from the observed workload.
CREATE   VIEW [dba].[vw_Perf_MissingIndexRecommendations]
AS
SELECT CONVERT(decimal(38,4),migs.avg_total_user_cost*(migs.avg_user_impact/100.0)*(migs.user_seeks+migs.user_scans)) AS EstimatedImprovementScore,mig.index_group_handle AS IndexGroupHandle,mid.index_handle AS IndexHandle,ISNULL(qc.QueryCount,0) AS AssociatedQueryCount,migs.user_seeks AS UserSeeks,migs.user_scans AS UserScans,migs.unique_compiles AS UniqueCompiles,CONVERT(decimal(18,4),migs.avg_total_user_cost) AS AvgTotalUserCost,CONVERT(decimal(18,2),migs.avg_user_impact) AS AvgUserImpactPercent,migs.last_user_seek AS LastUserSeek,migs.last_user_scan AS LastUserScan,DB_NAME(mid.database_id) AS DatabaseName,OBJECT_SCHEMA_NAME(mid.object_id,mid.database_id) AS SchemaName,OBJECT_NAME(mid.object_id,mid.database_id) AS TableName,mid.statement AS FullTableName,mid.equality_columns AS EqualityColumns,mid.inequality_columns AS InequalityColumns,mid.included_columns AS IncludedColumns,CAST(N'CREATE NONCLUSTERED INDEX '+QUOTENAME(LEFT(CONCAT(N'IX_',OBJECT_NAME(mid.object_id,mid.database_id),N'_MI_',mid.index_handle),128))+N' ON '+mid.statement+N' ('+ISNULL(mid.equality_columns,N'')+CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN N', ' ELSE N'' END+ISNULL(mid.inequality_columns,N'')+N')'+CASE WHEN mid.included_columns IS NOT NULL THEN N' INCLUDE ('+mid.included_columns+N')' ELSE N'' END+N';' AS nvarchar(max)) AS CandidateCreateIndexSql
FROM sys.dm_db_missing_index_groups AS mig
INNER JOIN sys.dm_db_missing_index_group_stats AS migs ON migs.group_handle=mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details AS mid ON mid.index_handle=mig.index_handle
LEFT JOIN (SELECT group_handle,COUNT_BIG(*) AS QueryCount FROM sys.dm_db_missing_index_group_stats_query GROUP BY group_handle) AS qc ON qc.group_handle=mig.index_group_handle
WHERE mid.database_id=DB_ID() AND (mid.equality_columns IS NOT NULL OR mid.inequality_columns IS NOT NULL);

GO

