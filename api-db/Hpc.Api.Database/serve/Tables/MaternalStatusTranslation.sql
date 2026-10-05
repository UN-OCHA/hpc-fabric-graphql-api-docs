CREATE TABLE [serve].[MaternalStatusTranslation] (
    [MaternalStatusId] SMALLINT       NOT NULL,
    [LanguageCode]     VARCHAR (35)   NOT NULL,
    [Name]             NVARCHAR (100) NOT NULL,
    [Description]      NVARCHAR (500) NULL,
    [RecordStatus]     VARCHAR (20)   CONSTRAINT [DF_serve_MaternalStatusTranslation_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]      DATETIME2 (0)  NULL,
    [CreatedAt]        DATETIME2 (0)  NULL,
    [UpdatedAt]        DATETIME2 (0)  NULL,
    [RefreshedAt]      DATETIME2 (0)  CONSTRAINT [DF_serve_MaternalStatusTranslation_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_MaternalStatusTranslation] PRIMARY KEY CLUSTERED ([MaternalStatusId] ASC, [LanguageCode] ASC),
    CONSTRAINT [CHK_serve_MaternalStatusTranslation_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_MaternalStatusTranslation_Language] FOREIGN KEY ([LanguageCode]) REFERENCES [serve].[Language] ([Code]),
    CONSTRAINT [FK_serve_MaternalStatusTranslation_MaternalStatus] FOREIGN KEY ([MaternalStatusId]) REFERENCES [serve].[MaternalStatus] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_MaternalStatusTranslation_LanguageCode]
    ON [serve].[MaternalStatusTranslation]([LanguageCode] ASC)
    INCLUDE([MaternalStatusId], [Name], [RecordStatus]);


GO

