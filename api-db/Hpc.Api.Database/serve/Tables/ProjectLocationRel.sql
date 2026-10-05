CREATE TABLE [serve].[ProjectLocationRel] (
    [ProjectId]  INT NOT NULL,
    [LocationId] INT NOT NULL,
    CONSTRAINT [PK_serve_ProjectLocationRel] PRIMARY KEY CLUSTERED ([ProjectId] ASC, [LocationId] ASC),
    CONSTRAINT [FK_serve_ProjectLocationRel_Location] FOREIGN KEY ([LocationId]) REFERENCES [serve].[Location] ([Id]),
    CONSTRAINT [FK_serve_ProjectLocationRel_Project] FOREIGN KEY ([ProjectId]) REFERENCES [serve].[Project] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_ProjectLocationRel_Location_Project]
    ON [serve].[ProjectLocationRel]([LocationId] ASC, [ProjectId] ASC);


GO

