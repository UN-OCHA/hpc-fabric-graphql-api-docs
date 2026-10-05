CREATE TABLE [serve].[Sector] (
    [Id]                SMALLINT       NOT NULL,
    [Name]              NVARCHAR (100) NOT NULL,
    [SectorType]        NVARCHAR (50)  NULL,
    [SectorCode]        NVARCHAR (50)  NULL,
    [Description]       NVARCHAR (500) NULL,
    [VisibilityGroupId] TINYINT        CONSTRAINT [DF_serve_Sector_VisibilityGroupId] DEFAULT ((1)) NOT NULL,
    [RecordStatus]      VARCHAR (20)   CONSTRAINT [DF_serve_Sector_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]       DATETIME2 (0)  NULL,
    [CreatedAt]         DATETIME2 (0)  NULL,
    [UpdatedAt]         DATETIME2 (0)  NULL,
    [RefreshedAt]       DATETIME2 (0)  CONSTRAINT [DF_serve_Sector_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_Sector] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_Sector_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_Sector_VisibilityGroup] FOREIGN KEY ([VisibilityGroupId]) REFERENCES [serve].[VisibilityGroup] ([Id])
);


GO

