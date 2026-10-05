CREATE TABLE [serve].[Icon] (
    [Id]           SMALLINT       NOT NULL,
    [Name]         VARCHAR (300)  NOT NULL,
    [FullName]     VARCHAR (300)  NOT NULL,
    [Svg]          NVARCHAR (MAX) NOT NULL,
    [RecordStatus] VARCHAR (20)   CONSTRAINT [DF_serve_Icon_RecordStatus] DEFAULT ('Active') NOT NULL,
    [CreatedAt]    DATETIME2 (0)  NULL,
    [UpdatedAt]    DATETIME2 (0)  NULL,
    [RefreshedAt]  DATETIME2 (0)  CONSTRAINT [DF_serve_Icon_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_Icon] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_Icon_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active')
);


GO

