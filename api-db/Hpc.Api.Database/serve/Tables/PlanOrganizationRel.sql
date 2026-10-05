CREATE TABLE [serve].[PlanOrganizationRel] (
    [PlanId]         INT NOT NULL,
    [OrganizationId] INT NOT NULL,
    CONSTRAINT [PK_serve_PlanOrganizationRel] PRIMARY KEY CLUSTERED ([PlanId] ASC, [OrganizationId] ASC),
    CONSTRAINT [FK_serve_PlanOrganizationRel_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [serve].[Organization] ([Id]),
    CONSTRAINT [FK_serve_PlanOrganizationRel_Plan] FOREIGN KEY ([PlanId]) REFERENCES [serve].[Plan] ([Id])
);


GO

