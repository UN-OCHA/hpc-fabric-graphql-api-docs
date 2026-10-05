CREATE TABLE [serve].[CategoryType] (
    [Id]           SMALLINT       NOT NULL,
    [Name]         VARCHAR (100)  NOT NULL,
    [DisplayName]  NVARCHAR (250) NOT NULL,
    [Description]  NVARCHAR (500) NULL,
    [RecordStatus] VARCHAR (20)   CONSTRAINT [DF_serve_CategoryType_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]  DATETIME2 (0)  NULL,
    [CreatedAt]    DATETIME2 (0)  NULL,
    [UpdatedAt]    DATETIME2 (0)  NULL,
    [RefreshedAt]  DATETIME2 (0)  CONSTRAINT [DF_serve_CategoryType_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_CategoryType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_CategoryType_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [UQ_serve_CategoryType_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);


GO

