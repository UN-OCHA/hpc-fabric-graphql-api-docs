-- Create public API view for current visible RevisionState records.
CREATE   VIEW api.[RevisionState]
AS
SELECT
    [Id],
    [Name],
    [DisplayName],
    [Description],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[RevisionState]

GO

