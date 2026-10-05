CREATE TABLE [serve].[ProjectContactRel] (
    [ProjectId] INT NOT NULL,
    [ContactId] INT NOT NULL,
    CONSTRAINT [PK_serve_ProjectContactRel] PRIMARY KEY CLUSTERED ([ProjectId] ASC, [ContactId] ASC),
    CONSTRAINT [FK_serve_ProjectContactRel_Contact] FOREIGN KEY ([ContactId]) REFERENCES [serve].[Contact] ([Id]),
    CONSTRAINT [FK_serve_ProjectContactRel_Project] FOREIGN KEY ([ProjectId]) REFERENCES [serve].[Project] ([Id])
);


GO

