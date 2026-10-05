
-- Get filtered missing-index candidates for review.
CREATE    PROCEDURE [dba].[usp_Perf_GetMissingIndexRecommendations]
    @MinImprovementScore DECIMAL(38, 4) = 1000,
    @MinUserSeeks BIGINT = 0,
    @SchemaName SYSNAME = NULL,
    @TableName SYSNAME = NULL,
    @Top INT = 100
AS
BEGIN
    SET NOCOUNT ON;

    IF @Top IS NULL OR @Top <= 0
        SET @Top = 100;

    SELECT TOP (@Top)
        EstimatedImprovementScore,
        IndexGroupHandle,
        IndexHandle,
        UserSeeks,
        UserScans,
        UniqueCompiles,
        AvgTotalUserCost,
        AvgUserImpactPercent,
        LastUserSeek,
        LastUserScan,
        DatabaseName,
        SchemaName,
        TableName,
        FullTableName,
        EqualityColumns,
        InequalityColumns,
        IncludedColumns,
        CandidateCreateIndexSql
    FROM [dba].[vw_Perf_MissingIndexRecommendations]
    WHERE EstimatedImprovementScore >= @MinImprovementScore
      AND UserSeeks >= @MinUserSeeks
      AND (@SchemaName IS NULL OR SchemaName = @SchemaName)
      AND (@TableName IS NULL OR TableName = @TableName)
    ORDER BY
        EstimatedImprovementScore DESC,
        UserSeeks DESC,
        UserScans DESC;
END;

GO

