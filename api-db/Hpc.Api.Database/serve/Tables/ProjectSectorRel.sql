CREATE TABLE [serve].[ProjectSectorRel] (
    [ProjectId] INT      NOT NULL,
    [SectorId]  SMALLINT NOT NULL,
    CONSTRAINT [PK_serve_ProjectSectorRel] PRIMARY KEY CLUSTERED ([ProjectId] ASC, [SectorId] ASC),
    CONSTRAINT [FK_serve_ProjectSectorRel_Project] FOREIGN KEY ([ProjectId]) REFERENCES [serve].[Project] ([Id]),
    CONSTRAINT [FK_serve_ProjectSectorRel_Sector] FOREIGN KEY ([SectorId]) REFERENCES [serve].[Sector] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_ProjectSectorRel_Sector_Project]
    ON [serve].[ProjectSectorRel]([SectorId] ASC, [ProjectId] ASC);


GO

