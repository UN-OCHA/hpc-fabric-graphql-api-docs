CREATE TABLE [serve].[PlanLocationRel] (
    [PlanId]     INT NOT NULL,
    [LocationId] INT NOT NULL,
    CONSTRAINT [PK_serve_PlanLocationRel] PRIMARY KEY CLUSTERED ([PlanId] ASC, [LocationId] ASC),
    CONSTRAINT [FK_serve_PlanLocationRel_Location] FOREIGN KEY ([LocationId]) REFERENCES [serve].[Location] ([Id]),
    CONSTRAINT [FK_serve_PlanLocationRel_Plan] FOREIGN KEY ([PlanId]) REFERENCES [serve].[Plan] ([Id])
);


GO

