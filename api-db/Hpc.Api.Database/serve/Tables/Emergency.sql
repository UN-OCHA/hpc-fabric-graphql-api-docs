CREATE TABLE [serve].[Emergency] (
    [Id]                SMALLINT        NOT NULL,
    [Name]              NVARCHAR (500)  NOT NULL,
    [EmergencyType]     NVARCHAR (500)  NULL,
    [Description]       NVARCHAR (4000) NULL,
    [EmergencyDate]     DATE            NOT NULL,
    [GlideNumber]       NVARCHAR (100)  NULL,
    [IsLevel3]          BIT             CONSTRAINT [DF_serve_Emergency_IsLevel3] DEFAULT ((0)) NOT NULL,
    [IsRestricted]      BIT             CONSTRAINT [DF_serve_Emergency_IsRestricted] DEFAULT ((0)) NOT NULL,
    [VisibilityGroupId] TINYINT         CONSTRAINT [DF_serve_Emergency_VisibilityGroupId] DEFAULT ((1)) NOT NULL,
    [RecordStatus]      VARCHAR (20)    CONSTRAINT [DF_serve_Emergency_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]       DATETIME2 (0)   NULL,
    [CreatedAt]         DATETIME2 (0)   NULL,
    [UpdatedAt]         DATETIME2 (0)   NULL,
    [RefreshedAt]       DATETIME2 (0)   CONSTRAINT [DF_serve_Emergency_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_Emergency] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_Emergency_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_Emergency_VisibilityGroup] FOREIGN KEY ([VisibilityGroupId]) REFERENCES [serve].[VisibilityGroup] ([Id])
);


GO

