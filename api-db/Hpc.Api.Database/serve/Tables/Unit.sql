CREATE TABLE [serve].[Unit] (
    [Id]           SMALLINT       NOT NULL,
    [Name]         NVARCHAR (250) NOT NULL,
    [NameFrench]   NVARCHAR (250) NOT NULL,
    [Description]  NVARCHAR (500) NULL,
    [RecordStatus] VARCHAR (20)   CONSTRAINT [DF_serve_Unit_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]  DATETIME2 (0)  NULL,
    [CreatedAt]    DATETIME2 (0)  NULL,
    [UpdatedAt]    DATETIME2 (0)  NULL,
    [RefreshedAt]  DATETIME2 (0)  CONSTRAINT [DF_serve_Unit_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_Unit] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_Unit_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active')
);


GO

