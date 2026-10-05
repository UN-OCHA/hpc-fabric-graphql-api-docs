CREATE TABLE [serve].[OrganizationParentChildRel] (
    [ParentOrganizationId] INT NOT NULL,
    [ChildOrganizationId]  INT NOT NULL,
    CONSTRAINT [PK_serve_OrganizationParentChildRel] PRIMARY KEY CLUSTERED ([ParentOrganizationId] ASC, [ChildOrganizationId] ASC),
    CONSTRAINT [CK_serve_OrganizationParentChildRel_NoSelfLink] CHECK ([ParentOrganizationId]<>[ChildOrganizationId]),
    CONSTRAINT [FK_serve_OrganizationParentChildRel_Child] FOREIGN KEY ([ChildOrganizationId]) REFERENCES [serve].[Organization] ([Id]),
    CONSTRAINT [FK_serve_OrganizationParentChildRel_Parent] FOREIGN KEY ([ParentOrganizationId]) REFERENCES [serve].[Organization] ([Id])
);


GO

