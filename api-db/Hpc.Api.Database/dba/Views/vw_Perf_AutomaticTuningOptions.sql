-- Show automatic tuning option state.
CREATE   VIEW [dba].[vw_Perf_AutomaticTuningOptions]
AS
SELECT name AS OptionName,desired_state_desc AS DesiredState,actual_state_desc AS ActualState,reason_desc AS Reason
FROM sys.database_automatic_tuning_options;

GO

