CREATE TABLE [serve].[CoordinationEntityTextContentRel] (
    [CoordinationEntityId] INT NOT NULL,
    [TextContentId]        INT NOT NULL,
    CONSTRAINT [PK_serve_CoordinationEntityTextContentRel] PRIMARY KEY CLUSTERED ([CoordinationEntityId] ASC, [TextContentId] ASC),
    CONSTRAINT [FK_serve_CoordinationEntityTextContentRel_CoordinationEntity] FOREIGN KEY ([CoordinationEntityId]) REFERENCES [serve].[CoordinationEntity] ([Id]),
    CONSTRAINT [FK_serve_CoordinationEntityTextContentRel_TextContent] FOREIGN KEY ([TextContentId]) REFERENCES [serve].[TextContent] ([Id])
);


GO

