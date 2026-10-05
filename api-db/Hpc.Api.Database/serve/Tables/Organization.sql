CREATE TABLE [serve].[Organization] (
    [Id]                INT             NOT NULL,
    [Name]              NVARCHAR (700)  NOT NULL,
    [Abbreviation]      NVARCHAR (150)  NULL,
    [Url]               NVARCHAR (2000) NULL,
    [NativeName]        NVARCHAR (500)  NULL,
    [Comments]          NVARCHAR (MAX)  NULL,
    [Notes]             NVARCHAR (2000) NULL,
    [CollectiveInd]     BIT             CONSTRAINT [DF_serve_Organization_CollectiveInd] DEFAULT ((0)) NOT NULL,
    [IsVerified]        BIT             CONSTRAINT [DF_serve_Organization_IsVerified] DEFAULT ((0)) NOT NULL,
    [NewOrganizationId] INT             NULL,
    [Description]       NVARCHAR (500)  NULL,
    [RecordStatus]      VARCHAR (20)    CONSTRAINT [DF_serve_Organization_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]       DATETIME2 (0)   NULL,
    [CreatedAt]         DATETIME2 (0)   NULL,
    [UpdatedAt]         DATETIME2 (0)   NULL,
    [RefreshedAt]       DATETIME2 (0)   CONSTRAINT [DF_serve_Organization_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_Organization] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_Organization_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active')
);


GO

