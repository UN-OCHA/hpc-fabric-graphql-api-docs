CREATE TABLE [serve].[DisabilityStatusTranslation] (
    [DisabilityStatusId] SMALLINT       NOT NULL,
    [LanguageCode]       VARCHAR (35)   NOT NULL,
    [Name]               NVARCHAR (100) NOT NULL,
    [Description]        NVARCHAR (500) NULL,
    [RecordStatus]       VARCHAR (20)   CONSTRAINT [DF_serve_DisabilityStatusTranslation_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]        DATETIME2 (0)  NULL,
    [CreatedAt]          DATETIME2 (0)  NULL,
    [UpdatedAt]          DATETIME2 (0)  NULL,
    [RefreshedAt]        DATETIME2 (0)  CONSTRAINT [DF_serve_DisabilityStatusTranslation_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_DisabilityStatusTranslation] PRIMARY KEY CLUSTERED ([DisabilityStatusId] ASC, [LanguageCode] ASC),
    CONSTRAINT [CHK_serve_DisabilityStatusTranslation_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_DisabilityStatusTranslation_DisabilityStatus] FOREIGN KEY ([DisabilityStatusId]) REFERENCES [serve].[DisabilityStatus] ([Id]),
    CONSTRAINT [FK_serve_DisabilityStatusTranslation_Language] FOREIGN KEY ([LanguageCode]) REFERENCES [serve].[Language] ([Code])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_DisabilityStatusTranslation_LanguageCode]
    ON [serve].[DisabilityStatusTranslation]([LanguageCode] ASC)
    INCLUDE([DisabilityStatusId], [Name], [RecordStatus]);


GO

