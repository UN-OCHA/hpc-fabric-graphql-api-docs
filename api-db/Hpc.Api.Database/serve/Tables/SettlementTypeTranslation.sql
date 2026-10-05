CREATE TABLE [serve].[SettlementTypeTranslation] (
    [SettlementTypeId] SMALLINT       NOT NULL,
    [LanguageCode]     VARCHAR (35)   NOT NULL,
    [Name]             NVARCHAR (100) NOT NULL,
    [Description]      NVARCHAR (500) NULL,
    [RecordStatus]     VARCHAR (20)   CONSTRAINT [DF_serve_SettlementTypeTranslation_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]      DATETIME2 (0)  NULL,
    [CreatedAt]        DATETIME2 (0)  NULL,
    [UpdatedAt]        DATETIME2 (0)  NULL,
    [RefreshedAt]      DATETIME2 (0)  CONSTRAINT [DF_serve_SettlementTypeTranslation_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_SettlementTypeTranslation] PRIMARY KEY CLUSTERED ([SettlementTypeId] ASC, [LanguageCode] ASC),
    CONSTRAINT [CHK_serve_SettlementTypeTranslation_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_SettlementTypeTranslation_Language] FOREIGN KEY ([LanguageCode]) REFERENCES [serve].[Language] ([Code]),
    CONSTRAINT [FK_serve_SettlementTypeTranslation_SettlementType] FOREIGN KEY ([SettlementTypeId]) REFERENCES [serve].[SettlementType] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_SettlementTypeTranslation_LanguageCode]
    ON [serve].[SettlementTypeTranslation]([LanguageCode] ASC)
    INCLUDE([SettlementTypeId], [Name], [RecordStatus]);


GO

