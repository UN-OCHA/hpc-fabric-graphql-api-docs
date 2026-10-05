CREATE TABLE [serve].[Gender] (
    [Id]           SMALLINT       NOT NULL,
    [Name]         NVARCHAR (50)  NOT NULL,
    [ShortName]    NVARCHAR (20)  NOT NULL,
    [Description]  NVARCHAR (500) NULL,
    [RecordStatus] VARCHAR (20)   CONSTRAINT [DF_serve_Gender_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]  DATETIME2 (0)  NULL,
    [CreatedAt]    DATETIME2 (0)  NULL,
    [UpdatedAt]    DATETIME2 (0)  NULL,
    [RefreshedAt]  DATETIME2 (0)  CONSTRAINT [DF_serve_Gender_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_Gender] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_Gender_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active')
);


GO

