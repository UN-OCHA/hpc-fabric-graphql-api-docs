CREATE TABLE [serve].[HealthInterventionCategoryTranslation] (
    [HealthInterventionCategoryId] SMALLINT       NOT NULL,
    [LanguageCode]                 VARCHAR (35)   NOT NULL,
    [Name]                         NVARCHAR (100) NOT NULL,
    [Description]                  NVARCHAR (500) NULL,
    [RecordStatus]                 VARCHAR (20)   CONSTRAINT [DF_serve_HealthInterventionCategoryTranslation_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]                  DATETIME2 (0)  NULL,
    [CreatedAt]                    DATETIME2 (0)  NULL,
    [UpdatedAt]                    DATETIME2 (0)  NULL,
    [RefreshedAt]                  DATETIME2 (0)  CONSTRAINT [DF_serve_HealthInterventionCategoryTranslation_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_HealthInterventionCategoryTranslation] PRIMARY KEY CLUSTERED ([HealthInterventionCategoryId] ASC, [LanguageCode] ASC),
    CONSTRAINT [CHK_serve_HealthInterventionCategoryTranslation_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_HealthInterventionCategoryTranslation_HealthInterventionCategory] FOREIGN KEY ([HealthInterventionCategoryId]) REFERENCES [serve].[HealthInterventionCategory] ([Id]),
    CONSTRAINT [FK_serve_HealthInterventionCategoryTranslation_Language] FOREIGN KEY ([LanguageCode]) REFERENCES [serve].[Language] ([Code])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_HealthInterventionCategoryTranslation_LanguageCode]
    ON [serve].[HealthInterventionCategoryTranslation]([LanguageCode] ASC)
    INCLUDE([HealthInterventionCategoryId], [Name], [RecordStatus]);


GO

