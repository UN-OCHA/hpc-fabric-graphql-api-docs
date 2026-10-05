CREATE TABLE [serve].[CustomQuestion] (
    [Id]                INT             NOT NULL,
    [PlanId]            INT             NOT NULL,
    [Name]              NVARCHAR (4000) NOT NULL,
    [FieldType]         NVARCHAR (100)  NULL,
    [Description]       NVARCHAR (MAX)  NULL,
    [SortOrder]         INT             NULL,
    [IsRequired]        BIT             CONSTRAINT [DF_serve_CustomQuestion_IsRequired] DEFAULT ((0)) NOT NULL,
    [IsGrouping]        BIT             CONSTRAINT [DF_serve_CustomQuestion_IsGrouping] DEFAULT ((0)) NOT NULL,
    [MinValue]          DECIMAL (18, 4) NULL,
    [MaxValue]          DECIMAL (18, 4) NULL,
    [MaxLength]         INT             NULL,
    [IsMultiSelect]     BIT             CONSTRAINT [DF_serve_CustomQuestion_IsMultiSelect] DEFAULT ((0)) NOT NULL,
    [RulesJson]         NVARCHAR (MAX)  NULL,
    [LabelJson]         NVARCHAR (MAX)  NULL,
    [DefinitionJson]    NVARCHAR (MAX)  NULL,
    [DisplayLabel]      NVARCHAR (4000) NULL,
    [VisibilityGroupId] TINYINT         CONSTRAINT [DF_serve_CustomQuestion_VisibilityGroupId] DEFAULT ((1)) NOT NULL,
    [RecordStatus]      VARCHAR (20)    CONSTRAINT [DF_serve_CustomQuestion_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]       DATETIME2 (0)   NULL,
    [CreatedAt]         DATETIME2 (0)   NULL,
    [UpdatedAt]         DATETIME2 (0)   NULL,
    [RefreshedAt]       DATETIME2 (0)   CONSTRAINT [DF_serve_CustomQuestion_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_CustomQuestion] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_CustomQuestion_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_CustomQuestion_Plan] FOREIGN KEY ([PlanId]) REFERENCES [serve].[Plan] ([Id]),
    CONSTRAINT [FK_serve_CustomQuestion_VisibilityGroup] FOREIGN KEY ([VisibilityGroupId]) REFERENCES [serve].[VisibilityGroup] ([Id])
);


GO

