
-- Pass-through API views for typed relationship tables.
CREATE   VIEW api.PlanPeriodRel
AS
SELECT
    PlanId,
    PeriodId
FROM serve.PlanPeriodRel;

GO

