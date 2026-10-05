CREATE TABLE [serve].[RevisionState] (
    [Id]          TINYINT        NOT NULL,
    [Name]        VARCHAR (30)   NOT NULL,
    [DisplayName] NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (500) NULL,
    [CreatedAt]   DATETIME2 (0)  NULL,
    [UpdatedAt]   DATETIME2 (0)  NULL,
    [RefreshedAt] DATETIME2 (0)  CONSTRAINT [DF_serve_RevisionState_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_RevisionState] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_serve_RevisionState_DisplayName] UNIQUE NONCLUSTERED ([DisplayName] ASC),
    CONSTRAINT [UQ_serve_RevisionState_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);


GO

