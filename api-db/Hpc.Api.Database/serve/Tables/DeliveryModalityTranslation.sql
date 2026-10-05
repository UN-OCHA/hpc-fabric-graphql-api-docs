CREATE TABLE [serve].[DeliveryModalityTranslation] (
    [DeliveryModalityId] SMALLINT       NOT NULL,
    [LanguageCode]       VARCHAR (35)   NOT NULL,
    [Name]               NVARCHAR (150) NOT NULL,
    [Description]        NVARCHAR (500) NULL,
    [RecordStatus]       VARCHAR (20)   CONSTRAINT [DF_serve_DeliveryModalityTranslation_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]        DATETIME2 (0)  NULL,
    [CreatedAt]          DATETIME2 (0)  NULL,
    [UpdatedAt]          DATETIME2 (0)  NULL,
    [RefreshedAt]        DATETIME2 (0)  CONSTRAINT [DF_serve_DeliveryModalityTranslation_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_DeliveryModalityTranslation] PRIMARY KEY CLUSTERED ([DeliveryModalityId] ASC, [LanguageCode] ASC),
    CONSTRAINT [CHK_serve_DeliveryModalityTranslation_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_DeliveryModalityTranslation_DeliveryModality] FOREIGN KEY ([DeliveryModalityId]) REFERENCES [serve].[DeliveryModality] ([Id]),
    CONSTRAINT [FK_serve_DeliveryModalityTranslation_Language] FOREIGN KEY ([LanguageCode]) REFERENCES [serve].[Language] ([Code])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_DeliveryModalityTranslation_LanguageCode]
    ON [serve].[DeliveryModalityTranslation]([LanguageCode] ASC)
    INCLUDE([DeliveryModalityId], [Name], [RecordStatus]);


GO

