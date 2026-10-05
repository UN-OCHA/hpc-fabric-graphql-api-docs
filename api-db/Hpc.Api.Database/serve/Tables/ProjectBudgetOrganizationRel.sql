CREATE TABLE [serve].[ProjectBudgetOrganizationRel] (
    [ProjectBudgetId] INT NOT NULL,
    [OrganizationId] INT NOT NULL,
    CONSTRAINT [PK_serve_ProjectBudgetOrganizationRel] PRIMARY KEY CLUSTERED ([ProjectBudgetId], [OrganizationId]),
    CONSTRAINT [FK_serve_ProjectBudgetOrganizationRel_ProjectBudget] FOREIGN KEY ([ProjectBudgetId]) REFERENCES [serve].[ProjectBudget] ([Id]),
    CONSTRAINT [FK_serve_ProjectBudgetOrganizationRel_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [serve].[Organization] ([Id])
);
GO
