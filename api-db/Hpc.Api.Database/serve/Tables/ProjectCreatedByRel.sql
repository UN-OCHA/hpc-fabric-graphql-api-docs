CREATE TABLE [serve].[ProjectCreatedByRel] (
    [ProjectId]     INT NOT NULL,
    [UserAccountId] INT NOT NULL,
    CONSTRAINT [PK_serve_ProjectCreatedByRel] PRIMARY KEY CLUSTERED ([ProjectId] ASC, [UserAccountId] ASC),
    CONSTRAINT [FK_serve_ProjectCreatedByRel_Project] FOREIGN KEY ([ProjectId]) REFERENCES [serve].[Project] ([Id]),
    CONSTRAINT [FK_serve_ProjectCreatedByRel_UserAccount] FOREIGN KEY ([UserAccountId]) REFERENCES [serve].[UserAccount] ([Id])
);


GO

