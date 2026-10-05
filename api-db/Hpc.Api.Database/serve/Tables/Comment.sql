CREATE TABLE [serve].[Comment] (
    [Id]                INT            NOT NULL,
    [EntityTypeId]      SMALLINT       NOT NULL,
    [EntityId]          INT            NOT NULL,
    [UserAccountId]     INT            NOT NULL,
    [CommentText]       NVARCHAR (MAX) NOT NULL,
    [Step]              NVARCHAR (255) NULL,
    [VisibilityGroupId] TINYINT        NULL,
    [RecordStatus]      VARCHAR (20)   CONSTRAINT [DF_serve_Comment_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]       DATETIME2 (0)  NULL,
    [CreatedAt]         DATETIME2 (0)  NULL,
    [UpdatedAt]         DATETIME2 (0)  NULL,
    [RefreshedAt]       DATETIME2 (0)  CONSTRAINT [DF_serve_Comment_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_Comment] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_Comment_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_Comment_EntityType] FOREIGN KEY ([EntityTypeId]) REFERENCES [serve].[EntityType] ([Id]),
    CONSTRAINT [FK_serve_Comment_UserAccount] FOREIGN KEY ([UserAccountId]) REFERENCES [serve].[UserAccount] ([Id]),
    CONSTRAINT [FK_serve_Comment_VisibilityGroup] FOREIGN KEY ([VisibilityGroupId]) REFERENCES [serve].[VisibilityGroup] ([Id])
);


GO

