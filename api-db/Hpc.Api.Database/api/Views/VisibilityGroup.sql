-- Create public API view for current visible VisibilityGroup records.
CREATE   VIEW api.[VisibilityGroup]
AS
SELECT
    [Id],
    [Name],
    [DisplayName],
    [Description],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[VisibilityGroup]

GO

