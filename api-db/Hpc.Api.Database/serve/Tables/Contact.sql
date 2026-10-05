CREATE TABLE [serve].[Contact] (
    [Id]           INT            NOT NULL,
    [Name]         NVARCHAR (255) NOT NULL,
    [Email]        NVARCHAR (254) NULL,
    [Phone]        NVARCHAR (50)  NULL,
    [Website]      NVARCHAR (255) NULL,
    [Address]      NVARCHAR (255) NULL,
    [Department]   NVARCHAR (100) NULL,
    [JobTitle]     NVARCHAR (100) NULL,
    [Role]         NVARCHAR (100) NULL,
    [RecordStatus] VARCHAR (20)   CONSTRAINT [DF_serve_Contact_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]  DATETIME2 (0)  NULL,
    [CreatedAt]    DATETIME2 (0)  NULL,
    [UpdatedAt]    DATETIME2 (0)  NULL,
    [RefreshedAt]  DATETIME2 (0)  CONSTRAINT [DF_serve_Contact_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_Contact] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_Contact_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active')
);


GO

