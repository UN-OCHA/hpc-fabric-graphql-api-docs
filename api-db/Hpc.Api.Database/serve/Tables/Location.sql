CREATE TABLE [serve].[Location] (
    [Id]           INT              NOT NULL,
    [Name]         NVARCHAR (250)   NOT NULL,
    [AdminLevel]   INT              NULL,
    [ISO3]         NVARCHAR (50)    NULL,
    [Pcode]        NVARCHAR (50)    NULL,
    [Description]  NVARCHAR (500)   NULL,
    [Latitude]     DECIMAL (18, 12) NULL,
    [Longitude]    DECIMAL (18, 12) NULL,
    [ParentId]     INT              NULL,
    [RecordStatus] VARCHAR (20)     CONSTRAINT [DF_serve_Location_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]  DATETIME2 (0)    NULL,
    [CountryId]    INT              NULL,
    [CountryISO3]  NVARCHAR (50)    NULL,
    [Path]         NVARCHAR (2000)  NULL,
    [CreatedAt]    DATETIME2 (0)    NULL,
    [UpdatedAt]    DATETIME2 (0)    NULL,
    [RefreshedAt]  DATETIME2 (0)    CONSTRAINT [DF_serve_Location_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_Location] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_Location_NoSelfParent] CHECK ([ParentId] IS NULL OR [ParentId]<>[Id]),
    CONSTRAINT [CK_serve_Location_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_Location_Parent] FOREIGN KEY ([ParentId]) REFERENCES [serve].[Location] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [nci_msft_1_Location_B08AF2BAEE850A0CDFEDC0BC38FE2A1C]
    ON [serve].[Location]([AdminLevel] ASC)
    INCLUDE([ActiveUntil], [ISO3], [Latitude], [Longitude], [Name], [Pcode], [RecordStatus]);


GO

CREATE NONCLUSTERED INDEX [IX_serve_Location_Country_AdminLevel]
    ON [serve].[Location]([CountryId] ASC, [AdminLevel] ASC, [RecordStatus] ASC)
    INCLUDE([Id], [Name], [ISO3], [Pcode], [Latitude], [Longitude], [ParentId]);


GO

