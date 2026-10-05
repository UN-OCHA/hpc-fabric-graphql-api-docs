CREATE TABLE [serve].[FileAsset] (
    [Id]                INT             NOT NULL,
    [Name]              NVARCHAR (500)  NOT NULL,
    [OriginalName]      NVARCHAR (500)  NULL,
    [MimeType]          NVARCHAR (100)  NULL,
    [Credit]            NVARCHAR (1000) NULL,
    [VisibilityGroupId] TINYINT         NOT NULL,
    [FileAssetTypeId]   SMALLINT        NOT NULL,
    [FilePath]          NVARCHAR (1000) NULL,
    [Url]               NVARCHAR (1000) NOT NULL,
    [RecordStatus]      VARCHAR (20)    CONSTRAINT [DF_serve_FileAsset_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]       DATETIME2 (0)   NULL,
    [CreatedAt]         DATETIME2 (0)   NULL,
    [UpdatedAt]         DATETIME2 (0)   NULL,
    [RefreshedAt]       DATETIME2 (0)   CONSTRAINT [DF_serve_FileAsset_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    [AzureFileURL]     NVARCHAR (500) NULL,
    CONSTRAINT [PK_serve_FileAsset] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_FileAsset_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_FileAsset_FileAssetType] FOREIGN KEY ([FileAssetTypeId]) REFERENCES [serve].[FileAssetType] ([Id]),
    CONSTRAINT [FK_serve_FileAsset_VisibilityGroup] FOREIGN KEY ([VisibilityGroupId]) REFERENCES [serve].[VisibilityGroup] ([Id])
);


GO

