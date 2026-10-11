
CREATE   VIEW api.OrganizationParentChildRel
AS
SELECT
    ParentOrganizationId,
    ChildOrganizationId
FROM serve.OrganizationParentChildRel;

GO

