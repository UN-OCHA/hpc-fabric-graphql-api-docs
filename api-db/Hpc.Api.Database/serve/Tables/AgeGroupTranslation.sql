CREATE TABLE [serve].[AgeGroupTranslation] (
    [AgeGroupId]   SMALLINT       NOT NULL,
    [LanguageCode] VARCHAR (35)   NOT NULL,
    [Name]         NVARCHAR (100) NOT NULL,
    [Description]  NVARCHAR (500) NULL,
    [RecordStatus] VARCHAR (20)   CONSTRAINT [DF_serve_AgeGroupTranslation_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]  DATETIME2 (0)  NULL,
    [CreatedAt]    DATETIME2 (0)  NULL,
    [UpdatedAt]    DATETIME2 (0)  NULL,
    [RefreshedAt]  DATETIME2 (0)  CONSTRAINT [DF_serve_AgeGroupTranslation_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_AgeGroupTranslation] PRIMARY KEY CLUSTERED ([AgeGroupId] ASC, [LanguageCode] ASC),
    CONSTRAINT [CHK_serve_AgeGroupTranslation_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_AgeGroupTranslation_AgeGroup] FOREIGN KEY ([AgeGroupId]) REFERENCES [serve].[AgeGroup] ([Id]),
    CONSTRAINT [FK_serve_AgeGroupTranslation_Language] FOREIGN KEY ([LanguageCode]) REFERENCES [serve].[Language] ([Code])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_AgeGroupTranslation_LanguageCode]
    ON [serve].[AgeGroupTranslation]([LanguageCode] ASC)
    INCLUDE([AgeGroupId], [Name], [RecordStatus]);


GO

