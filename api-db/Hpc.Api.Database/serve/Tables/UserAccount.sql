CREATE TABLE [serve].[UserAccount] (
    [Id]           INT            NOT NULL,
    [Email]        NVARCHAR (500) NULL,
    [Name]         NVARCHAR (200) NOT NULL,
    [IsActive]     BIT            CONSTRAINT [DF_serve_UserAccount_IsActive] DEFAULT ((1)) NOT NULL,
    [RecordStatus] VARCHAR (20)   CONSTRAINT [DF_serve_UserAccount_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]  DATETIME2 (0)  NULL,
    [CreatedAt]    DATETIME2 (0)  NULL,
    [UpdatedAt]    DATETIME2 (0)  NULL,
    [RefreshedAt]  DATETIME2 (0)  CONSTRAINT [DF_serve_UserAccount_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_UserAccount] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_UserAccount_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [UQ_serve_UserAccount_Email] UNIQUE NONCLUSTERED ([Email] ASC)
);


GO

