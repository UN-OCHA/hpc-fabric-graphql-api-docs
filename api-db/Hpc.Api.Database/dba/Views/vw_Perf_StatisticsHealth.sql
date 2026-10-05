-- Show statistics freshness, sampling and modification counts.
CREATE   VIEW [dba].[vw_Perf_StatisticsHealth]
AS
SELECT SCHEMA_NAME(t.schema_id) AS SchemaName,t.name AS TableName,s.name AS StatisticsName,s.stats_id AS StatisticsId,s.auto_created AS IsAutoCreated,s.user_created AS IsUserCreated,s.no_recompute AS NoRecompute,CONVERT(bit,CASE WHEN i.index_id IS NULL THEN 0 ELSE 1 END) AS IsIndexStatistics,i.name AS RelatedIndexName,sp.last_updated AS LastUpdated,sp.rows AS [Rows],sp.rows_sampled AS RowsSampled,CONVERT(decimal(18,2),sp.rows_sampled*100.0/NULLIF(sp.rows,0)) AS SamplePercent,sp.steps AS HistogramSteps,sp.unfiltered_rows AS UnfilteredRows,sp.modification_counter AS ModificationCounter,CONVERT(decimal(18,2),sp.modification_counter*100.0/NULLIF(sp.rows,0)) AS ModificationPercent,DATEDIFF(day,sp.last_updated,SYSUTCDATETIME()) AS DaysSinceLastUpdate
FROM sys.tables AS t
INNER JOIN sys.stats AS s ON s.object_id=t.object_id
OUTER APPLY sys.dm_db_stats_properties(s.object_id,s.stats_id) AS sp
LEFT JOIN sys.indexes AS i ON i.object_id=s.object_id AND i.index_id=s.stats_id
WHERE t.is_ms_shipped=0;

GO

