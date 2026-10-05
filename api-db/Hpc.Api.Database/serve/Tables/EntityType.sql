CREATE TABLE [serve].[EntityType] (
    [Id]              SMALLINT       NOT NULL,
    [Name]            VARCHAR (100)  NOT NULL,
    [DisplayName]     NVARCHAR (150) NOT NULL,
    [EntitySubType]   VARCHAR (150)  NULL,
    [PgSqlEntityType] VARCHAR (50)   NULL,
    [PgSqlRefCode]    VARCHAR (10)   NULL,
    [Description]     NVARCHAR (500) NULL,
    [RecordStatus]    VARCHAR (20)   CONSTRAINT [DF_serve_EntityType_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]     DATETIME2 (0)  NULL,
    [CreatedAt]       DATETIME2 (0)  NULL,
    [UpdatedAt]       DATETIME2 (0)  NULL,
    [RefreshedAt]     DATETIME2 (0)  CONSTRAINT [DF_serve_EntityType_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_EntityType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_EntityType_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [UQ_serve_EntityType_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);


GO

