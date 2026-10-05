CREATE TABLE [serve].[LogframeEntity] (
    [Id]                   INT             NOT NULL,
    [EntityTypeId]         SMALLINT        NOT NULL,
    [PlanId]               INT             NOT NULL,
    [Name]                 NVARCHAR (4000) NOT NULL,
    [Description]          NVARCHAR (1000) NULL,
    [VisibilityGroupId]    TINYINT         CONSTRAINT [DF_serve_LogframeEntity_VisibilityGroupId] DEFAULT ((1)) NOT NULL,
    [RecordStatus]         VARCHAR (20)    CONSTRAINT [DF_serve_LogframeEntity_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]          DATETIME2 (0)   NULL,
    [CoordinationEntityId] INT             NULL,
    [CustomReference]      NVARCHAR (100)  NULL,
    [ComposedReference]    VARCHAR (100)   NULL,
    [SortOrder]            INT             NULL,
    [HpcEntityPrototypeId] INT             NULL,
    [NamePrefix]           NVARCHAR (200)  NULL,
    [CreatedAt]            DATETIME2 (0)   NULL,
    [UpdatedAt]            DATETIME2 (0)   NULL,
    [RefreshedAt]          DATETIME2 (0)   CONSTRAINT [DF_serve_LogframeEntity_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_LogframeEntity] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_LogframeEntity_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_LogframeEntity_EntityType] FOREIGN KEY ([EntityTypeId]) REFERENCES [serve].[EntityType] ([Id]),
    CONSTRAINT [FK_serve_LogframeEntity_Plan] FOREIGN KEY ([PlanId]) REFERENCES [serve].[Plan] ([Id]),
    CONSTRAINT [FK_serve_LogframeEntity_VisibilityGroup] FOREIGN KEY ([VisibilityGroupId]) REFERENCES [serve].[VisibilityGroup] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_LogframeEntity_Plan_Active]
    ON [serve].[LogframeEntity]([PlanId] ASC, [RecordStatus] ASC, [VisibilityGroupId] ASC, [SortOrder] ASC, [Id] ASC)
    INCLUDE([Name], [EntityTypeId], [CoordinationEntityId], [HpcEntityPrototypeId], [CustomReference], [ComposedReference]);


GO

CREATE NONCLUSTERED INDEX [nci_msft_1_LogframeEntity_527BFC4CD2407483D5F78BE006BD8115]
    ON [serve].[LogframeEntity]([PlanId] ASC, [RecordStatus] ASC, [VisibilityGroupId] ASC)
    INCLUDE([ComposedReference], [CoordinationEntityId], [CustomReference], [Description], [EntityTypeId], [HpcEntityPrototypeId], [Name], [SortOrder]);


GO

