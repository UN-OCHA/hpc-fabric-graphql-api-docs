CREATE TABLE [serve].[MetricTypeTranslation] (
    [MetricTypeId] SMALLINT       NOT NULL,
    [LanguageCode] VARCHAR (35)   NOT NULL,
    [Name]         NVARCHAR (100) NOT NULL,
    [Description]  NVARCHAR (500) NULL,
    [RecordStatus] VARCHAR (20)   CONSTRAINT [DF_serve_MetricTypeTranslation_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]  DATETIME2 (0)  NULL,
    [CreatedAt]    DATETIME2 (0)  NULL,
    [UpdatedAt]    DATETIME2 (0)  NULL,
    [RefreshedAt]  DATETIME2 (0)  CONSTRAINT [DF_serve_MetricTypeTranslation_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_MetricTypeTranslation] PRIMARY KEY CLUSTERED ([MetricTypeId] ASC, [LanguageCode] ASC),
    CONSTRAINT [CHK_serve_MetricTypeTranslation_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_MetricTypeTranslation_Language] FOREIGN KEY ([LanguageCode]) REFERENCES [serve].[Language] ([Code]),
    CONSTRAINT [FK_serve_MetricTypeTranslation_MetricType] FOREIGN KEY ([MetricTypeId]) REFERENCES [serve].[MetricType] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_MetricTypeTranslation_LanguageCode]
    ON [serve].[MetricTypeTranslation]([LanguageCode] ASC)
    INCLUDE([MetricTypeId], [Name], [RecordStatus]);


GO

