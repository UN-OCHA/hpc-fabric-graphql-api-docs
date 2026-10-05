CREATE TABLE [serve].[CoordinationEntity] (
    [Id]                   INT            NOT NULL,
    [EntityTypeId]         SMALLINT       NOT NULL,
    [PlanId]               INT            NULL,
    [Name]                 NVARCHAR (100) NOT NULL,
    [Description]          NVARCHAR (500) NULL,
    [CustomReference]      VARCHAR (100)  NULL,
    [ComposedReference]    VARCHAR (100)  NULL,
    [VisibilityGroupId]    TINYINT        CONSTRAINT [DF_serve_CoordinationEntity_VisibilityGroupId] DEFAULT ((1)) NOT NULL,
    [RecordStatus]         VARCHAR (20)   CONSTRAINT [DF_serve_CoordinationEntity_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]          DATETIME2 (0)  NULL,
    [IsOverriding]         BIT            CONSTRAINT [DF_serve_CoordinationEntity_IsOverriding] DEFAULT ((0)) NOT NULL,
    [HPCTags]              NVARCHAR (250) NULL,
    [IconId]               SMALLINT       NULL,
    [HpcEntityPrototypeId] INT            NULL,
    [CreatedAt]            DATETIME2 (0)  NULL,
    [UpdatedAt]            DATETIME2 (0)  NULL,
    [RefreshedAt]          DATETIME2 (0)  CONSTRAINT [DF_serve_CoordinationEntity_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_CoordinationEntity] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_CoordinationEntity_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_CoordinationEntity_EntityType] FOREIGN KEY ([EntityTypeId]) REFERENCES [serve].[EntityType] ([Id]),
    CONSTRAINT [FK_serve_CoordinationEntity_Icon] FOREIGN KEY ([IconId]) REFERENCES [serve].[Icon] ([Id]),
    CONSTRAINT [FK_serve_CoordinationEntity_Plan] FOREIGN KEY ([PlanId]) REFERENCES [serve].[Plan] ([Id]),
    CONSTRAINT [FK_serve_CoordinationEntity_VisibilityGroup] FOREIGN KEY ([VisibilityGroupId]) REFERENCES [serve].[VisibilityGroup] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_CoordinationEntity_Plan_Active]
    ON [serve].[CoordinationEntity]([PlanId] ASC, [RecordStatus] ASC, [VisibilityGroupId] ASC, [Id] ASC)
    INCLUDE([Name], [EntityTypeId], [IconId], [HpcEntityPrototypeId], [CustomReference], [ComposedReference]);


GO

