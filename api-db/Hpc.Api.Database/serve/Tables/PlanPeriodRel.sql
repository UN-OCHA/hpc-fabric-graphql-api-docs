CREATE TABLE [serve].[PlanPeriodRel] (
    [PlanId]   INT NOT NULL,
    [PeriodId] INT NOT NULL,
    CONSTRAINT [PK_serve_PlanPeriodRel] PRIMARY KEY CLUSTERED ([PlanId] ASC, [PeriodId] ASC),
    CONSTRAINT [FK_serve_PlanPeriodRel_Period] FOREIGN KEY ([PeriodId]) REFERENCES [serve].[Period] ([Id]),
    CONSTRAINT [FK_serve_PlanPeriodRel_Plan] FOREIGN KEY ([PlanId]) REFERENCES [serve].[Plan] ([Id])
);


GO

