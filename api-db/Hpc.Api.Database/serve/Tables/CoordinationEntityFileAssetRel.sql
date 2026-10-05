CREATE TABLE [serve].[CoordinationEntityFileAssetRel] (
    [CoordinationEntityId] INT NOT NULL,
    [FileAssetId]          INT NOT NULL,
    CONSTRAINT [PK_serve_CoordinationEntityFileAssetRel] PRIMARY KEY CLUSTERED ([CoordinationEntityId] ASC, [FileAssetId] ASC),
    CONSTRAINT [FK_serve_CoordinationEntityFileAssetRel_CoordinationEntity] FOREIGN KEY ([CoordinationEntityId]) REFERENCES [serve].[CoordinationEntity] ([Id]),
    CONSTRAINT [FK_serve_CoordinationEntityFileAssetRel_FileAsset] FOREIGN KEY ([FileAssetId]) REFERENCES [serve].[FileAsset] ([Id])
);


GO

