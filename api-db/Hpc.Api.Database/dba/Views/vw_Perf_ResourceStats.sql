-- Show recent CPU, I/O, memory, worker and session utilization with a pressure classification.
CREATE   VIEW [dba].[vw_Perf_ResourceStats]
AS
SELECT rs.end_time AS EndTimeUtc,rs.avg_cpu_percent AS AvgCpuPercent,rs.avg_data_io_percent AS AvgDataIoPercent,rs.avg_log_write_percent AS AvgLogWritePercent,rs.avg_memory_usage_percent AS AvgMemoryUsagePercent,rs.max_worker_percent AS MaxWorkerPercent,rs.max_session_percent AS MaxSessionPercent,rs.cpu_limit AS CpuLimit,rs.dtu_limit AS DtuLimit,rs.avg_instance_cpu_percent AS AvgInstanceCpuPercent,rs.avg_instance_memory_percent AS AvgInstanceMemoryPercent,rs.replica_role AS ReplicaRole,p.MaxResourcePercent,CASE WHEN p.MaxResourcePercent>=90 THEN N'Critical' WHEN p.MaxResourcePercent>=80 THEN N'High' WHEN p.MaxResourcePercent>=60 THEN N'Elevated' ELSE N'Normal' END AS PressureLevel
FROM sys.dm_db_resource_stats AS rs
CROSS APPLY (SELECT MAX(v.ResourcePercent) AS MaxResourcePercent FROM (VALUES(CONVERT(decimal(18,2),rs.avg_cpu_percent)),(CONVERT(decimal(18,2),rs.avg_data_io_percent)),(CONVERT(decimal(18,2),rs.avg_log_write_percent)),(CONVERT(decimal(18,2),rs.avg_memory_usage_percent)),(CONVERT(decimal(18,2),rs.max_worker_percent)),(CONVERT(decimal(18,2),rs.max_session_percent))) AS v(ResourcePercent)) AS p;

GO

