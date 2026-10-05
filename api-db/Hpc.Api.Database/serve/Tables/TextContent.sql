CREATE TABLE [serve].[TextContent] (
    [Id]                INT             NOT NULL,
    [Name]              NVARCHAR (500)  NOT NULL,
    [Title]             NVARCHAR (500)  NULL,
    [Description]       NVARCHAR (1000) NULL,
    [ContentHtml]       NVARCHAR (MAX)  NOT NULL,
    [ContentPlainText]  NVARCHAR (MAX)  NULL,
    [AsOfDate]          DATETIME2 (0)   NULL,
    [VisibilityGroupId] TINYINT         NOT NULL,
    [TextContentTypeId] SMALLINT        NOT NULL,
    [RecordStatus]      VARCHAR (20)    CONSTRAINT [DF_serve_TextContent_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]       DATETIME2 (0)   NULL,
    [CreatedAt]         DATETIME2 (0)   NULL,
    [UpdatedAt]         DATETIME2 (0)   NULL,
    [RefreshedAt]       DATETIME2 (0)   CONSTRAINT [DF_serve_TextContent_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_TextContent] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_TextContent_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_TextContent_TextContentType] FOREIGN KEY ([TextContentTypeId]) REFERENCES [serve].[TextContentType] ([Id]),
    CONSTRAINT [FK_serve_TextContent_VisibilityGroup] FOREIGN KEY ([VisibilityGroupId]) REFERENCES [serve].[VisibilityGroup] ([Id])
);


GO

