CREATE TABLE [serve].[PlanFileAssetRel] (
    [PlanId]      INT NOT NULL,
    [FileAssetId] INT NOT NULL,
    CONSTRAINT [PK_serve_PlanFileAssetRel] PRIMARY KEY CLUSTERED ([PlanId] ASC, [FileAssetId] ASC),
    CONSTRAINT [FK_serve_PlanFileAssetRel_FileAsset] FOREIGN KEY ([FileAssetId]) REFERENCES [serve].[FileAsset] ([Id]),
    CONSTRAINT [FK_serve_PlanFileAssetRel_Plan] FOREIGN KEY ([PlanId]) REFERENCES [serve].[Plan] ([Id])
);


GO

