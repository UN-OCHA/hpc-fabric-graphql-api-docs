CREATE TABLE [serve].[ProjectCoordinationEntityRel] (
    [ProjectId]            INT NOT NULL,
    [CoordinationEntityId] INT NOT NULL,
    CONSTRAINT [PK_serve_ProjectCoordinationEntityRel] PRIMARY KEY CLUSTERED ([ProjectId] ASC, [CoordinationEntityId] ASC),
    CONSTRAINT [FK_serve_ProjectCoordinationEntityRel_CoordinationEntity] FOREIGN KEY ([CoordinationEntityId]) REFERENCES [serve].[CoordinationEntity] ([Id]),
    CONSTRAINT [FK_serve_ProjectCoordinationEntityRel_Project] FOREIGN KEY ([ProjectId]) REFERENCES [serve].[Project] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_ProjectCoordinationEntityRel_CoordinationEntity_Project]
    ON [serve].[ProjectCoordinationEntityRel]([CoordinationEntityId] ASC, [ProjectId] ASC);


GO

