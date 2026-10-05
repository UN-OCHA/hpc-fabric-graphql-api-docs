CREATE TABLE [serve].[PlanCategoryRel] (
    [PlanId]     INT NOT NULL,
    [CategoryId] INT NOT NULL,
    CONSTRAINT [PK_serve_PlanCategoryRel] PRIMARY KEY CLUSTERED ([PlanId] ASC, [CategoryId] ASC),
    CONSTRAINT [FK_serve_PlanCategoryRel_Category] FOREIGN KEY ([CategoryId]) REFERENCES [serve].[Category] ([Id]),
    CONSTRAINT [FK_serve_PlanCategoryRel_Plan] FOREIGN KEY ([PlanId]) REFERENCES [serve].[Plan] ([Id])
);


GO

