CREATE TABLE [serve].[Attachment] (
    [Id]                    INT             NOT NULL,
    [Name]                  NVARCHAR (4000) NULL,
    [PlanId]                INT             NULL,
    [EntityId]              INT             NULL,
    [EntityTypeId]          SMALLINT        NULL,
    [EntityMainType]        NVARCHAR (50)   NULL,
    [AttachmentType]        NVARCHAR (50)   NOT NULL,
    [CustomReference]       NVARCHAR (255)  NULL,
    [HasDisaggregatedData]  BIT             CONSTRAINT [DF_serve_Attachment_HasDisaggregatedData] DEFAULT ((0)) NOT NULL,
    [UnitId]                SMALLINT        NULL,
    [CalculationMethod]     NVARCHAR (100)  NULL,
    [Description]           NVARCHAR (1000) NULL,
    [VisibilityGroupId]     TINYINT         CONSTRAINT [DF_serve_Attachment_VisibilityGroupId] DEFAULT ((1)) NOT NULL,
    [AttachmentPrototypeId] INT             NULL,
    [RecordStatus]          NVARCHAR (20)   CONSTRAINT [DF_serve_Attachment_RecordStatus] DEFAULT (N'Active') NOT NULL,
    [ActiveUntil]           DATETIME2 (0)   NULL,
    [CreatedAt]             DATETIME2 (0)   NULL,
    [UpdatedAt]             DATETIME2 (0)   NULL,
    [RefreshedAt]           DATETIME2 (0)   CONSTRAINT [DF_serve_Attachment_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_Attachment] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_Attachment_AttachmentType] CHECK ([AttachmentType]=N'Cost' OR [AttachmentType]=N'Caseload' OR [AttachmentType]=N'Indicator'),
    CONSTRAINT [CK_serve_Attachment_RecordStatus] CHECK ([RecordStatus]=N'Deleted' OR [RecordStatus]=N'Inactive' OR [RecordStatus]=N'Active'),
    CONSTRAINT [FK_serve_Attachment_AttachmentPrototype] FOREIGN KEY ([AttachmentPrototypeId]) REFERENCES [serve].[AttachmentPrototype] ([Id]),
    CONSTRAINT [FK_serve_Attachment_EntityType] FOREIGN KEY ([EntityTypeId]) REFERENCES [serve].[EntityType] ([Id]),
    CONSTRAINT [FK_serve_Attachment_Plan] FOREIGN KEY ([PlanId]) REFERENCES [serve].[Plan] ([Id]),
    CONSTRAINT [FK_serve_Attachment_Unit] FOREIGN KEY ([UnitId]) REFERENCES [serve].[Unit] ([Id]),
    CONSTRAINT [FK_serve_Attachment_VisibilityGroup] FOREIGN KEY ([VisibilityGroupId]) REFERENCES [serve].[VisibilityGroup] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_Attachment_EntityMainType_EntityId_AttachmentType]
    ON [serve].[Attachment]([EntityMainType] ASC, [EntityId] ASC, [AttachmentType] ASC, [RecordStatus] ASC, [VisibilityGroupId] ASC, [Id] ASC)
    INCLUDE([PlanId], [EntityTypeId], [HasDisaggregatedData], [UnitId], [AttachmentPrototypeId], [UpdatedAt]);


GO

