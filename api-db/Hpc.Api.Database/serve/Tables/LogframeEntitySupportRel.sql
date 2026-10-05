CREATE TABLE [serve].[LogframeEntitySupportRel] (
    [LogframeEntityId]         INT NOT NULL,
    [SupportsLogframeEntityId] INT NOT NULL,
    [SortOrder]                INT NULL,
    CONSTRAINT [PK_serve_LogframeEntitySupportRel] PRIMARY KEY CLUSTERED ([LogframeEntityId] ASC, [SupportsLogframeEntityId] ASC),
    CONSTRAINT [CK_serve_LogframeEntitySupportRel_NoSelfLink] CHECK ([LogframeEntityId]<>[SupportsLogframeEntityId]),
    CONSTRAINT [FK_serve_LogframeEntitySupportRel_LogframeEntity] FOREIGN KEY ([LogframeEntityId]) REFERENCES [serve].[LogframeEntity] ([Id]),
    CONSTRAINT [FK_serve_LogframeEntitySupportRel_SupportsLogframeEntity] FOREIGN KEY ([SupportsLogframeEntityId]) REFERENCES [serve].[LogframeEntity] ([Id])
);


GO

