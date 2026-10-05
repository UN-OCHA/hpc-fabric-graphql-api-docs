CREATE TABLE [serve].[VisibilityGroup] (
    [Id]          TINYINT        NOT NULL,
    [Name]        VARCHAR (20)   NOT NULL,
    [DisplayName] NVARCHAR (50)  NOT NULL,
    [Description] NVARCHAR (500) NULL,
    [CreatedAt]   DATETIME2 (0)  NULL,
    [UpdatedAt]   DATETIME2 (0)  NULL,
    [RefreshedAt] DATETIME2 (0)  CONSTRAINT [DF_serve_VisibilityGroup_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_VisibilityGroup] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_serve_VisibilityGroup_DisplayName] UNIQUE NONCLUSTERED ([DisplayName] ASC),
    CONSTRAINT [UQ_serve_VisibilityGroup_Name] UNIQUE NONCLUSTERED ([Name] ASC)
);


GO

