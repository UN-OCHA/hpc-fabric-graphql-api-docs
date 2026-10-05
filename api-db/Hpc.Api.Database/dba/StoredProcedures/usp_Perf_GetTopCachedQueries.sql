
-- Get top cached statements ordered by the selected performance measure.
CREATE    PROCEDURE [dba].[usp_Perf_GetTopCachedQueries]
    @OrderBy VARCHAR(40) = 'TotalLogicalReads',
    @Top INT = 50
AS
BEGIN
    SET NOCOUNT ON;

    IF @Top IS NULL OR @Top <= 0
        SET @Top = 50;

    IF @OrderBy NOT IN
    (
        'TotalCpuTime',
        'TotalElapsedTime',
        'TotalLogicalReads',
        'TotalLogicalWrites',
        'TotalPhysicalReads',
        'ExecutionCount',
        'AvgLogicalReads'
    )
        SET @OrderBy = 'TotalLogicalReads';

    SELECT TOP (@Top)
        ExecutionCount,
        PlanCreationTime,
        LastExecutionTime,
        TotalCpuTimeMs,
        TotalElapsedTimeMs,
        TotalLogicalReads,
        TotalLogicalWrites,
        TotalPhysicalReads,
        AvgCpuTimeMs,
        AvgElapsedTimeMs,
        AvgLogicalReads,
        AvgLogicalWrites,
        StatementText
    FROM [dba].[vw_Perf_TopCachedQueries]
    ORDER BY
        CASE
            WHEN @OrderBy = 'TotalCpuTime'
                THEN TotalCpuTimeMs
        END DESC,
        CASE
            WHEN @OrderBy = 'TotalElapsedTime'
                THEN TotalElapsedTimeMs
        END DESC,
        CASE
            WHEN @OrderBy = 'TotalLogicalReads'
                THEN TotalLogicalReads
        END DESC,
        CASE
            WHEN @OrderBy = 'TotalLogicalWrites'
                THEN TotalLogicalWrites
        END DESC,
        CASE
            WHEN @OrderBy = 'TotalPhysicalReads'
                THEN TotalPhysicalReads
        END DESC,
        CASE
            WHEN @OrderBy = 'ExecutionCount'
                THEN ExecutionCount
        END DESC,
        CASE
            WHEN @OrderBy = 'AvgLogicalReads'
                THEN AvgLogicalReads
        END DESC,
        TotalLogicalReads DESC;
END;

GO

