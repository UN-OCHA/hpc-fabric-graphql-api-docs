CREATE TABLE [serve].[ProjectBudgetCoordinationEntityRel] (
    [ProjectBudgetId] INT NOT NULL,
    [CoordinationEntityId] INT NOT NULL,
    CONSTRAINT [PK_serve_ProjectBudgetCoordinationEntityRel] PRIMARY KEY CLUSTERED ([ProjectBudgetId], [CoordinationEntityId]),
    CONSTRAINT [FK_serve_ProjectBudgetCoordinationEntityRel_ProjectBudget] FOREIGN KEY ([ProjectBudgetId]) REFERENCES [serve].[ProjectBudget] ([Id]),
    CONSTRAINT [FK_serve_ProjectBudgetCoordinationEntityRel_CoordinationEntity] FOREIGN KEY ([CoordinationEntityId]) REFERENCES [serve].[CoordinationEntity] ([Id])
);
GO