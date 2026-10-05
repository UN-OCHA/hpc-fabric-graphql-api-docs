CREATE TABLE [serve].[DisaggregationCategoryOtherTranslation] (
    [DisaggregationCategoryOtherId] SMALLINT       NOT NULL,
    [LanguageCode]                  VARCHAR (35)   NOT NULL,
    [Name]                          NVARCHAR (250) NOT NULL,
    [Description]                   NVARCHAR (500) NULL,
    [RecordStatus]                  VARCHAR (20)   CONSTRAINT [DF_serve_DisaggregationCategoryOtherTranslation_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]                   DATETIME2 (0)  NULL,
    [CreatedAt]                     DATETIME2 (0)  NULL,
    [UpdatedAt]                     DATETIME2 (0)  NULL,
    [RefreshedAt]                   DATETIME2 (0)  CONSTRAINT [DF_serve_DisaggregationCategoryOtherTranslation_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_DisaggregationCategoryOtherTranslation] PRIMARY KEY CLUSTERED ([DisaggregationCategoryOtherId] ASC, [LanguageCode] ASC),
    CONSTRAINT [CHK_serve_DisaggregationCategoryOtherTranslation_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_DisaggregationCategoryOtherTranslation_DisaggregationCategoryOther] FOREIGN KEY ([DisaggregationCategoryOtherId]) REFERENCES [serve].[DisaggregationCategoryOther] ([Id]),
    CONSTRAINT [FK_serve_DisaggregationCategoryOtherTranslation_Language] FOREIGN KEY ([LanguageCode]) REFERENCES [serve].[Language] ([Code])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_DisaggregationCategoryOtherTranslation_LanguageCode]
    ON [serve].[DisaggregationCategoryOtherTranslation]([LanguageCode] ASC)
    INCLUDE([DisaggregationCategoryOtherId], [Name], [RecordStatus]);


GO

