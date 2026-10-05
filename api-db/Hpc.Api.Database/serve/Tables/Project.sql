CREATE TABLE [serve].[Project] (
    [Id]                    INT             NOT NULL,
    [Name]                  NVARCHAR (700)  NOT NULL,
    [ProjectCode]           NVARCHAR (250)  NULL,
    [Description]           NVARCHAR (2000) NULL,
    [StartDate]             DATE            NULL,
    [EndDate]               DATE            NULL,
    [IsPublished]           BIT             CONSTRAINT [DF_serve_Project_IsPublished] DEFAULT ((0)) NOT NULL,
    [Objective]             NVARCHAR (MAX)  NULL,
    [VisibilityGroupId]     TINYINT         CONSTRAINT [DF_serve_Project_VisibilityGroupId] DEFAULT ((1)) NOT NULL,
    [ImplementingPartners]  NVARCHAR (MAX)  NULL,
    [ImplementationStatus]  NVARCHAR (50)   NULL,
    [CurrentRequestedFunds] DECIMAL (18, 2) NULL,
    [TotalProjectTarget]    DECIMAL (19, 4) NULL,
    [RecordStatus]          VARCHAR (20)    CONSTRAINT [DF_serve_Project_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]           DATETIME2 (0)   NULL,
    [PlanId]                INT             NULL,
    [PgSqlPdf]              NVARCHAR (1000) NULL,
    [CreatedAt]             DATETIME2 (0)   NULL,
    [UpdatedAt]             DATETIME2 (0)   NULL,
    [RefreshedAt]           DATETIME2 (0)   CONSTRAINT [DF_serve_Project_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_Project] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_Project_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_Project_Plan] FOREIGN KEY ([PlanId]) REFERENCES [serve].[Plan] ([Id]),
    CONSTRAINT [FK_serve_Project_VisibilityGroup] FOREIGN KEY ([VisibilityGroupId]) REFERENCES [serve].[VisibilityGroup] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_Project_Plan_Published_ProjectCode]
    ON [serve].[Project]([PlanId] ASC, [IsPublished] ASC, [RecordStatus] ASC, [VisibilityGroupId] ASC, [ProjectCode] ASC, [Id] ASC)
    INCLUDE([Name], [StartDate], [EndDate], [ImplementationStatus], [CurrentRequestedFunds], [TotalProjectTarget], [UpdatedAt]);


GO

