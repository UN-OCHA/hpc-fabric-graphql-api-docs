CREATE TABLE [serve].[PlanEmergencyRel] (
    [PlanId]      INT      NOT NULL,
    [EmergencyId] SMALLINT NOT NULL,
    CONSTRAINT [PK_serve_PlanEmergencyRel] PRIMARY KEY CLUSTERED ([PlanId] ASC, [EmergencyId] ASC),
    CONSTRAINT [FK_serve_PlanEmergencyRel_Emergency] FOREIGN KEY ([EmergencyId]) REFERENCES [serve].[Emergency] ([Id]),
    CONSTRAINT [FK_serve_PlanEmergencyRel_Plan] FOREIGN KEY ([PlanId]) REFERENCES [serve].[Plan] ([Id])
);


GO

