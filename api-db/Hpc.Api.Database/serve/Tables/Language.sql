CREATE TABLE [serve].[Language] (
    [Code]        VARCHAR (35)   NOT NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [NativeName]  NVARCHAR (100) NULL,
    [IsRtl]       BIT            CONSTRAINT [DF_serve_Language_IsRtl] DEFAULT ((0)) NOT NULL,
    [IsActive]    BIT            CONSTRAINT [DF_serve_Language_IsActive] DEFAULT ((1)) NOT NULL,
    [SortOrder]   INT            NULL,
    [CreatedAt]   DATETIME2 (0)  NULL,
    [UpdatedAt]   DATETIME2 (0)  NULL,
    [RefreshedAt] DATETIME2 (0)  CONSTRAINT [DF_serve_Language_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_Language] PRIMARY KEY CLUSTERED ([Code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_Language_IsActive_SortOrder]
    ON [serve].[Language]([IsActive] ASC, [SortOrder] ASC)
    INCLUDE([Name], [NativeName], [IsRtl]);


GO

