CREATE TABLE [serve].[ProjectLogframeRel] (
    [ProjectId]        INT NOT NULL,
    [LogframeEntityId] INT NOT NULL,
    CONSTRAINT [PK_serve_ProjectLogframeRel] PRIMARY KEY CLUSTERED ([ProjectId] ASC, [LogframeEntityId] ASC),
    CONSTRAINT [FK_serve_ProjectLogframeRel_LogframeEntity] FOREIGN KEY ([LogframeEntityId]) REFERENCES [serve].[LogframeEntity] ([Id]),
    CONSTRAINT [FK_serve_ProjectLogframeRel_Project] FOREIGN KEY ([ProjectId]) REFERENCES [serve].[Project] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_ProjectLogframeRel_Logframe_Project]
    ON [serve].[ProjectLogframeRel]([LogframeEntityId] ASC, [ProjectId] ASC);


GO

