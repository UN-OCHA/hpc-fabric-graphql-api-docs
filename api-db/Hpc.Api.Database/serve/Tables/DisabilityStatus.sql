CREATE TABLE [serve].[DisabilityStatus] (
    [Id]           SMALLINT       NOT NULL,
    [Name]         NVARCHAR (100) NOT NULL,
    [Description]  NVARCHAR (500) NULL,
    [Kind]         NVARCHAR (50)  NULL,
    [RecordStatus] VARCHAR (20)   CONSTRAINT [DF_serve_DisabilityStatus_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]  DATETIME2 (0)  NULL,
    [CreatedAt]    DATETIME2 (0)  NULL,
    [UpdatedAt]    DATETIME2 (0)  NULL,
    [RefreshedAt]  DATETIME2 (0)  CONSTRAINT [DF_serve_DisabilityStatus_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_DisabilityStatus] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_DisabilityStatus_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active')
);


GO

