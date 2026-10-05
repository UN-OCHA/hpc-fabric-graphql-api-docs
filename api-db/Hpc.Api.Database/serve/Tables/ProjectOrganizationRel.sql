CREATE TABLE [serve].[ProjectOrganizationRel] (
    [ProjectId]      INT NOT NULL,
    [OrganizationId] INT NOT NULL,
    CONSTRAINT [PK_serve_ProjectOrganizationRel] PRIMARY KEY CLUSTERED ([ProjectId] ASC, [OrganizationId] ASC),
    CONSTRAINT [FK_serve_ProjectOrganizationRel_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [serve].[Organization] ([Id]),
    CONSTRAINT [FK_serve_ProjectOrganizationRel_Project] FOREIGN KEY ([ProjectId]) REFERENCES [serve].[Project] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_ProjectOrganizationRel_Organization_Project]
    ON [serve].[ProjectOrganizationRel]([OrganizationId] ASC, [ProjectId] ASC);


GO

