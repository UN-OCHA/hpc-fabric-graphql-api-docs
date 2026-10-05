CREATE TABLE [serve].[MetricType] (
    [Id]                SMALLINT        NOT NULL,
    [Name]              VARCHAR (100)   NOT NULL,
    [NameFr]            NVARCHAR (100)  NULL,
    [NameEs]            NVARCHAR (100)  NULL,
    [LabelLookup]       NVARCHAR (2000) NULL,
    [OtherName]         NVARCHAR (100)  NULL,
    [HPCType]           NVARCHAR (100)  NULL,
    [MetricHPCCategory] VARCHAR (50)    NULL,
    [Description]       NVARCHAR (500)  NULL,
    [RecordStatus]      VARCHAR (20)    CONSTRAINT [DF_serve_MetricType_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]       DATETIME2 (0)   NULL,
    [CreatedAt]         DATETIME2 (0)   NULL,
    [UpdatedAt]         DATETIME2 (0)   NULL,
    [RefreshedAt]       DATETIME2 (0)   CONSTRAINT [DF_serve_MetricType_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_MetricType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_MetricType_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active')
);


GO

