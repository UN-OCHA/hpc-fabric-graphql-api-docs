-- Show table row counts and storage usage, including secondary-index overhead.
CREATE   VIEW [dba].[vw_Perf_TableSize]
AS
SELECT SCHEMA_NAME(t.schema_id) AS SchemaName,t.name AS TableName,SUM(CASE WHEN ps.index_id IN (0,1) THEN ps.row_count ELSE 0 END) AS [RowCount],CONVERT(decimal(18,2),SUM(ps.reserved_page_count)*8.0/1024.0) AS ReservedMB,CONVERT(decimal(18,2),SUM(ps.used_page_count)*8.0/1024.0) AS UsedMB,CONVERT(decimal(18,2),SUM(CASE WHEN ps.index_id IN (0,1) THEN ps.used_page_count ELSE 0 END)*8.0/1024.0) AS BaseTableUsedMB,CONVERT(decimal(18,2),SUM(CASE WHEN ps.index_id>1 THEN ps.used_page_count ELSE 0 END)*8.0/1024.0) AS SecondaryIndexUsedMB,CONVERT(decimal(18,2),SUM(CASE WHEN ps.index_id>1 THEN ps.used_page_count ELSE 0 END)*100.0/NULLIF(SUM(ps.used_page_count),0)) AS SecondaryIndexUsedPercent,CONVERT(decimal(18,2),SUM(CASE WHEN ps.index_id IN (0,1) THEN ps.in_row_data_page_count ELSE 0 END)*8.0/1024.0) AS BaseTableInRowDataMB,CONVERT(decimal(18,2),SUM(ps.lob_used_page_count)*8.0/1024.0) AS LobUsedMB,CONVERT(decimal(18,2),SUM(ps.row_overflow_used_page_count)*8.0/1024.0) AS RowOverflowUsedMB
FROM sys.tables AS t
INNER JOIN sys.dm_db_partition_stats AS ps ON ps.object_id=t.object_id
WHERE t.is_ms_shipped=0
GROUP BY SCHEMA_NAME(t.schema_id),t.name;

GO

