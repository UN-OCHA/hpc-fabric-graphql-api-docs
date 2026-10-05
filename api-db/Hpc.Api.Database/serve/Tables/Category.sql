CREATE TABLE [serve].[Category] (
    [Id]             INT            NOT NULL,
    [Name]           NVARCHAR (250) NOT NULL,
    [CategoryTypeId] SMALLINT       NOT NULL,
    [Description]    NVARCHAR (500) NULL,
    [ParentId]       INT            NULL,
    [Code]           NVARCHAR (50)  NULL,
    [RecordStatus]   VARCHAR (20)   CONSTRAINT [DF_serve_Category_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]    DATETIME2 (0)  NULL,
    [CreatedAt]      DATETIME2 (0)  NULL,
    [UpdatedAt]      DATETIME2 (0)  NULL,
    [RefreshedAt]    DATETIME2 (0)  CONSTRAINT [DF_serve_Category_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_Category] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_Category_NoSelfParent] CHECK ([ParentId] IS NULL OR [ParentId]<>[Id]),
    CONSTRAINT [CK_serve_Category_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_Category_CategoryType] FOREIGN KEY ([CategoryTypeId]) REFERENCES [serve].[CategoryType] ([Id]),
    CONSTRAINT [FK_serve_Category_Parent] FOREIGN KEY ([ParentId]) REFERENCES [serve].[Category] ([Id])
);


GO

