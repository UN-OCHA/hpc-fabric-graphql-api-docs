CREATE TABLE [serve].[GenderTranslation] (
    [GenderId]     SMALLINT       NOT NULL,
    [LanguageCode] VARCHAR (35)   NOT NULL,
    [Name]         NVARCHAR (50)  NOT NULL,
    [ShortName]    NVARCHAR (20)  NULL,
    [Description]  NVARCHAR (500) NULL,
    [RecordStatus] VARCHAR (20)   CONSTRAINT [DF_serve_GenderTranslation_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]  DATETIME2 (0)  NULL,
    [CreatedAt]    DATETIME2 (0)  NULL,
    [UpdatedAt]    DATETIME2 (0)  NULL,
    [RefreshedAt]  DATETIME2 (0)  CONSTRAINT [DF_serve_GenderTranslation_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_GenderTranslation] PRIMARY KEY CLUSTERED ([GenderId] ASC, [LanguageCode] ASC),
    CONSTRAINT [CHK_serve_GenderTranslation_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_GenderTranslation_Gender] FOREIGN KEY ([GenderId]) REFERENCES [serve].[Gender] ([Id]),
    CONSTRAINT [FK_serve_GenderTranslation_Language] FOREIGN KEY ([LanguageCode]) REFERENCES [serve].[Language] ([Code])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_GenderTranslation_LanguageCode]
    ON [serve].[GenderTranslation]([LanguageCode] ASC)
    INCLUDE([GenderId], [Name], [ShortName], [RecordStatus]);


GO

