CREATE TABLE [serve].[PopulationStatusTranslation] (
    [PopulationStatusId] SMALLINT       NOT NULL,
    [LanguageCode]       VARCHAR (35)   NOT NULL,
    [Name]               NVARCHAR (150) NOT NULL,
    [ShortName]          NVARCHAR (20)  NULL,
    [Description]        NVARCHAR (500) NULL,
    [RecordStatus]       VARCHAR (20)   CONSTRAINT [DF_serve_PopulationStatusTranslation_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]        DATETIME2 (0)  NULL,
    [CreatedAt]          DATETIME2 (0)  NULL,
    [UpdatedAt]          DATETIME2 (0)  NULL,
    [RefreshedAt]        DATETIME2 (0)  CONSTRAINT [DF_serve_PopulationStatusTranslation_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_PopulationStatusTranslation] PRIMARY KEY CLUSTERED ([PopulationStatusId] ASC, [LanguageCode] ASC),
    CONSTRAINT [CHK_serve_PopulationStatusTranslation_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_PopulationStatusTranslation_Language] FOREIGN KEY ([LanguageCode]) REFERENCES [serve].[Language] ([Code]),
    CONSTRAINT [FK_serve_PopulationStatusTranslation_PopulationStatus] FOREIGN KEY ([PopulationStatusId]) REFERENCES [serve].[PopulationStatus] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_PopulationStatusTranslation_LanguageCode]
    ON [serve].[PopulationStatusTranslation]([LanguageCode] ASC)
    INCLUDE([PopulationStatusId], [Name], [ShortName], [RecordStatus]);


GO

