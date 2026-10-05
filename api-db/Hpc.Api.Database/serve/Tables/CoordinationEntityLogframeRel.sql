CREATE TABLE [serve].[CoordinationEntityLogframeRel] (
    [CoordinationEntityId] INT NOT NULL,
    [LogframeEntityId]     INT NOT NULL,
    CONSTRAINT [PK_serve_CoordinationEntityLogframeRel] PRIMARY KEY CLUSTERED ([CoordinationEntityId] ASC, [LogframeEntityId] ASC),
    CONSTRAINT [FK_serve_CoordinationEntityLogframeRel_CoordinationEntity] FOREIGN KEY ([CoordinationEntityId]) REFERENCES [serve].[CoordinationEntity] ([Id]),
    CONSTRAINT [FK_serve_CoordinationEntityLogframeRel_LogframeEntity] FOREIGN KEY ([LogframeEntityId]) REFERENCES [serve].[LogframeEntity] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_CoordinationEntityLogframeRel_Logframe_CoordinationEntity]
    ON [serve].[CoordinationEntityLogframeRel]([LogframeEntityId] ASC, [CoordinationEntityId] ASC);


GO

