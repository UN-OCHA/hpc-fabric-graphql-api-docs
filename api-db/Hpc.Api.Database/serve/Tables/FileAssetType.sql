CREATE TABLE [serve].[FileAssetType] (
    [Id]           SMALLINT       NOT NULL,
    [Name]         NVARCHAR (100) NOT NULL,
    [DisplayName]  NVARCHAR (200) NULL,
    [Description]  NVARCHAR (500) NULL,
    [RecordStatus] VARCHAR (20)   CONSTRAINT [DF_serve_FileAssetType_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]  DATETIME2 (0)  NULL,
    [CreatedAt]    DATETIME2 (0)  NULL,
    [UpdatedAt]    DATETIME2 (0)  NULL,
    [RefreshedAt]  DATETIME2 (0)  CONSTRAINT [DF_serve_FileAssetType_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_FileAssetType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_FileAssetType_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [UQ_serve_FileAssetType_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);


GO

