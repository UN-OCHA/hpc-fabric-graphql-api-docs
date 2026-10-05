
CREATE   VIEW api.SectorParentChildRel
AS
SELECT
    ParentSectorId,
    ChildSectorId
FROM serve.SectorParentChildRel;

GO

