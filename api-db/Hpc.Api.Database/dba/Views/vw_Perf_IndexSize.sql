-- Show storage usage by individual table index.
CREATE   VIEW [dba].[vw_Perf_IndexSize]
AS
SELECT SCHEMA_NAME(t.schema_id) AS SchemaName,t.name AS TableName,i.name AS IndexName,i.index_id AS IndexId,i.type_desc AS IndexType,i.is_primary_key AS IsPrimaryKey,i.is_unique AS IsUnique,i.auto_created AS IsAutoCreated,i.is_disabled AS IsDisabled,i.has_filter AS HasFilter,i.filter_definition AS FilterDefinition,SUM(ps.row_count) AS [RowCount],CONVERT(decimal(18,2),SUM(ps.reserved_page_count)*8.0/1024.0) AS ReservedMB,CONVERT(decimal(18,2),SUM(ps.used_page_count)*8.0/1024.0) AS UsedMB,CONVERT(decimal(18,2),SUM(ps.in_row_data_page_count)*8.0/1024.0) AS InRowDataMB,CONVERT(decimal(18,2),SUM(ps.lob_used_page_count)*8.0/1024.0) AS LobUsedMB,CONVERT(decimal(18,2),SUM(ps.row_overflow_used_page_count)*8.0/1024.0) AS RowOverflowUsedMB
FROM sys.tables AS t
INNER JOIN sys.indexes AS i ON i.object_id=t.object_id
INNER JOIN sys.dm_db_partition_stats AS ps ON ps.object_id=i.object_id AND ps.index_id=i.index_id
WHERE t.is_ms_shipped=0
GROUP BY SCHEMA_NAME(t.schema_id),t.name,i.name,i.index_id,i.type_desc,i.is_primary_key,i.is_unique,i.auto_created,i.is_disabled,i.has_filter,i.filter_definition;

GO

