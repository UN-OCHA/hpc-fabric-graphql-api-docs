CREATE TABLE [serve].[CoordinationEntityContactRel] (
    [CoordinationEntityId] INT NOT NULL,
    [ContactId]            INT NOT NULL,
    CONSTRAINT [PK_serve_CoordinationEntityContactRel] PRIMARY KEY CLUSTERED ([CoordinationEntityId] ASC, [ContactId] ASC),
    CONSTRAINT [FK_serve_CoordinationEntityContactRel_Contact] FOREIGN KEY ([ContactId]) REFERENCES [serve].[Contact] ([Id]),
    CONSTRAINT [FK_serve_CoordinationEntityContactRel_CoordinationEntity] FOREIGN KEY ([CoordinationEntityId]) REFERENCES [serve].[CoordinationEntity] ([Id])
);


GO

