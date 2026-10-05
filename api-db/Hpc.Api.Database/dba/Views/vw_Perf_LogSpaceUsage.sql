
-- Show current transaction-log consumption and available log space.
CREATE   VIEW dba.vw_Perf_LogSpaceUsage
AS
SELECT
    DB_ID() AS DatabaseId,
    DB_NAME() AS DatabaseName,
    CONVERT(DECIMAL(18, 2), total_log_size_in_bytes * 1.0 / 1024.0 / 1024.0) AS TotalLogSizeMB,
    CONVERT(DECIMAL(18, 2), used_log_space_in_bytes * 1.0 / 1024.0 / 1024.0) AS UsedLogSpaceMB,
    CONVERT(DECIMAL(18, 2), (total_log_size_in_bytes - used_log_space_in_bytes) * 1.0 / 1024.0 / 1024.0) AS FreeLogSpaceMB,
    CONVERT(DECIMAL(9, 2), used_log_space_in_percent) AS UsedLogSpacePercent,
    CONVERT(DECIMAL(18, 2), log_space_in_bytes_since_last_backup * 1.0 / 1024.0 / 1024.0) AS LogSinceLastBackupMB
FROM sys.dm_db_log_space_usage;

GO

