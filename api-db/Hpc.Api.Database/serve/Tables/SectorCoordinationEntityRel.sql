CREATE TABLE [serve].[SectorCoordinationEntityRel] (
    [SectorId]             SMALLINT NOT NULL,
    [CoordinationEntityId] INT      NOT NULL,
    CONSTRAINT [PK_serve_SectorCoordinationEntityRel] PRIMARY KEY CLUSTERED ([SectorId] ASC, [CoordinationEntityId] ASC),
    CONSTRAINT [FK_serve_SectorCoordinationEntityRel_CoordinationEntity] FOREIGN KEY ([CoordinationEntityId]) REFERENCES [serve].[CoordinationEntity] ([Id]),
    CONSTRAINT [FK_serve_SectorCoordinationEntityRel_Sector] FOREIGN KEY ([SectorId]) REFERENCES [serve].[Sector] ([Id])
);


GO

