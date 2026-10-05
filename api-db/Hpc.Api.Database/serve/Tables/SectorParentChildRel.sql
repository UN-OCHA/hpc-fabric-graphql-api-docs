CREATE TABLE [serve].[SectorParentChildRel] (
    [ParentSectorId] SMALLINT NOT NULL,
    [ChildSectorId]  SMALLINT NOT NULL,
    CONSTRAINT [PK_serve_SectorParentChildRel] PRIMARY KEY CLUSTERED ([ParentSectorId] ASC, [ChildSectorId] ASC),
    CONSTRAINT [CK_serve_SectorParentChildRel_NoSelfLink] CHECK ([ParentSectorId]<>[ChildSectorId]),
    CONSTRAINT [FK_serve_SectorParentChildRel_Child] FOREIGN KEY ([ChildSectorId]) REFERENCES [serve].[Sector] ([Id]),
    CONSTRAINT [FK_serve_SectorParentChildRel_Parent] FOREIGN KEY ([ParentSectorId]) REFERENCES [serve].[Sector] ([Id])
);


GO

