CREATE TABLE [serve].[OrganizationLocationRel] (
    [OrganizationId] INT NOT NULL,
    [LocationId]     INT NOT NULL,
    CONSTRAINT [PK_serve_OrganizationLocationRel] PRIMARY KEY CLUSTERED ([OrganizationId] ASC, [LocationId] ASC),
    CONSTRAINT [FK_serve_OrganizationLocationRel_Location] FOREIGN KEY ([LocationId]) REFERENCES [serve].[Location] ([Id]),
    CONSTRAINT [FK_serve_OrganizationLocationRel_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [serve].[Organization] ([Id])
);


GO

