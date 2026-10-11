-- Create public API view for current visible Period records.
CREATE   VIEW api.[Period]
AS
SELECT
    [Id],
    [Name],
    [Description],
    [PeriodType],
    [CalendarYear],
    [StartDate],
    [EndDate],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[Period]
WHERE RecordStatus = 'Active'

GO

