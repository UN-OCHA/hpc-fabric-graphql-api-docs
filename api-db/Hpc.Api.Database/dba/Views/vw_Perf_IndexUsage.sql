-- Show index reads, maintenance operations and last usage dates.
CREATE   VIEW [dba].[vw_Perf_IndexUsage]
AS
SELECT SCHEMA_NAME(t.schema_id) AS SchemaName,t.name AS TableName,i.name AS IndexName,i.index_id AS IndexId,i.type_desc AS IndexType,i.is_primary_key AS IsPrimaryKey,i.is_unique AS IsUnique,i.auto_created AS IsAutoCreated,i.is_disabled AS IsDisabled,i.has_filter AS HasFilter,i.filter_definition AS FilterDefinition,i.fill_factor AS [FillFactor],i.allow_row_locks AS AllowRowLocks,i.allow_page_locks AS AllowPageLocks,ISNULL(us.user_seeks,0) AS UserSeeks,ISNULL(us.user_scans,0) AS UserScans,ISNULL(us.user_lookups,0) AS UserLookups,ISNULL(us.user_updates,0) AS UserUpdateOperations,ISNULL(us.user_seeks,0)+ISNULL(us.user_scans,0)+ISNULL(us.user_lookups,0) AS TotalReadOperations,CONVERT(decimal(18,2),(ISNULL(us.user_seeks,0)+ISNULL(us.user_scans,0)+ISNULL(us.user_lookups,0))*1.0/NULLIF(ISNULL(us.user_updates,0),0)) AS ReadToUpdateOperationRatio,us.last_user_seek AS LastUserSeek,us.last_user_scan AS LastUserScan,us.last_user_lookup AS LastUserLookup,us.last_user_update AS LastUserUpdate
FROM sys.tables AS t
INNER JOIN sys.indexes AS i ON i.object_id=t.object_id
LEFT JOIN sys.dm_db_index_usage_stats AS us ON us.database_id=DB_ID() AND us.object_id=i.object_id AND us.index_id=i.index_id
WHERE t.is_ms_shipped=0 AND i.index_id>0 AND i.is_hypothetical=0;

GO

