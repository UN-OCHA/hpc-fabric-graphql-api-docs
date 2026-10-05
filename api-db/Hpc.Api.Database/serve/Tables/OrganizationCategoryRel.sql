CREATE TABLE [serve].[OrganizationCategoryRel] (
    [OrganizationId] INT NOT NULL,
    [CategoryId]     INT NOT NULL,
    CONSTRAINT [PK_serve_OrganizationCategoryRel] PRIMARY KEY CLUSTERED ([OrganizationId] ASC, [CategoryId] ASC),
    CONSTRAINT [FK_serve_OrganizationCategoryRel_Category] FOREIGN KEY ([CategoryId]) REFERENCES [serve].[Category] ([Id]),
    CONSTRAINT [FK_serve_OrganizationCategoryRel_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [serve].[Organization] ([Id])
);


GO

