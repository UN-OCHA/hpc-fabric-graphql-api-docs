
-- Show transaction-log health, VLF counts and truncation holdup reason.
CREATE   VIEW dba.vw_Perf_LogStats
AS
SELECT
    database_id AS DatabaseId,
    DB_NAME(database_id) AS DatabaseName,
    recovery_model AS RecoveryModel,
    total_log_size_mb AS TotalLogSizeMB,
    active_log_size_mb AS ActiveLogSizeMB,
    CONVERT(DECIMAL(9, 2), active_log_size_mb * 100.0 / NULLIF(total_log_size_mb, 0)) AS ActiveLogPercent,
    total_vlf_count AS TotalVlfCount,
    active_vlf_count AS ActiveVlfCount,
    current_vlf_sequence_number AS CurrentVlfSequenceNumber,
    current_vlf_size_mb AS CurrentVlfSizeMB,
    log_truncation_holdup_reason AS LogTruncationHoldupReason,
    log_since_last_log_backup_mb AS LogSinceLastLogBackupMB,
    log_since_last_checkpoint_mb AS LogSinceLastCheckpointMB,
    log_backup_time AS LogBackupTime
FROM sys.dm_db_log_stats(DB_ID());

GO

