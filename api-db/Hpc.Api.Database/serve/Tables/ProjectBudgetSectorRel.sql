CREATE TABLE [serve].[ProjectBudgetSectorRel] (
    [ProjectBudgetId] INT NOT NULL,
    [SectorId] SMALLINT NOT NULL,
    CONSTRAINT [PK_serve_ProjectBudgetSectorRel] PRIMARY KEY CLUSTERED ([ProjectBudgetId], [SectorId]),
    CONSTRAINT [FK_serve_ProjectBudgetSectorRel_ProjectBudget] FOREIGN KEY ([ProjectBudgetId]) REFERENCES [serve].[ProjectBudget] ([Id]),
    CONSTRAINT [FK_serve_ProjectBudgetSectorRel_Sector] FOREIGN KEY ([SectorId]) REFERENCES [serve].[Sector] ([Id])
);
GO