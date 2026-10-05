-- Show Query Store configuration and storage state.
CREATE   VIEW [dba].[vw_Perf_QueryStoreOptions]
AS
SELECT actual_state_desc AS ActualState,desired_state_desc AS DesiredState,current_storage_size_mb AS CurrentStorageSizeMB,max_storage_size_mb AS MaxStorageSizeMB,CONVERT(decimal(18,2),current_storage_size_mb*100.0/NULLIF(max_storage_size_mb,0)) AS StorageUsedPercent,readonly_reason AS ReadOnlyReason,interval_length_minutes AS IntervalLengthMinutes,stale_query_threshold_days AS StaleQueryThresholdDays,size_based_cleanup_mode_desc AS SizeBasedCleanupMode,query_capture_mode_desc AS QueryCaptureMode,flush_interval_seconds AS FlushIntervalSeconds,wait_stats_capture_mode_desc AS WaitStatsCaptureMode
FROM sys.database_query_store_options;

GO

