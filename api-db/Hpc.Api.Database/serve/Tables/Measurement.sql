CREATE TABLE [serve].[Measurement] (
    [Id]                    INT             NOT NULL,
    [Name]                  NVARCHAR (4000) NULL,
    [PlanId]                INT             NULL,
    [AttachmentId]          INT             NOT NULL,
    [MeasurementPeriodId]   INT             NULL,
    [EntityId]              INT             NULL,
    [EntityTypeId]          SMALLINT        NULL,
    [EntityMainType]        NVARCHAR (50)   NULL,
    [MeasurementType]       NVARCHAR (50)   NOT NULL,
    [CustomReference]       NVARCHAR (255)  NULL,
    [UnitId]                SMALLINT        NULL,
    [CalculationMethod]     NVARCHAR (100)  NULL,
    [Description]           NVARCHAR (1000) NULL,
    [VisibilityGroupId]     TINYINT         CONSTRAINT [DF_serve_Measurement_VisibilityGroupId] DEFAULT ((1)) NOT NULL,
    [AttachmentPrototypeId] INT             NULL,
    [RecordStatus]          NVARCHAR (20)   CONSTRAINT [DF_serve_Measurement_RecordStatus] DEFAULT (N'Active') NOT NULL,
    [ActiveUntil]           DATETIME2 (0)   NULL,
    [IsCommentPublic]       BIT             CONSTRAINT [DF_serve_Measurement_IsCommentPublic] DEFAULT ((0)) NOT NULL,
    [Comments]              NVARCHAR (MAX)  NULL,
    [CreatedAt]             DATETIME2 (0)   NULL,
    [UpdatedAt]             DATETIME2 (0)   NULL,
    [RefreshedAt]           DATETIME2 (0)   CONSTRAINT [DF_serve_Measurement_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_Measurement] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_Measurement_MeasurementType] CHECK ([MeasurementType]=N'Cost' OR [MeasurementType]=N'Caseload' OR [MeasurementType]=N'Indicator'),
    CONSTRAINT [CK_serve_Measurement_RecordStatus] CHECK ([RecordStatus]=N'Deleted' OR [RecordStatus]=N'Inactive' OR [RecordStatus]=N'Active'),
    CONSTRAINT [FK_serve_Measurement_Attachment] FOREIGN KEY ([AttachmentId]) REFERENCES [serve].[Attachment] ([Id]),
    CONSTRAINT [FK_serve_Measurement_AttachmentPrototype] FOREIGN KEY ([AttachmentPrototypeId]) REFERENCES [serve].[AttachmentPrototype] ([Id]),
    CONSTRAINT [FK_serve_Measurement_EntityType] FOREIGN KEY ([EntityTypeId]) REFERENCES [serve].[EntityType] ([Id]),
    CONSTRAINT [FK_serve_Measurement_MeasurementPeriod] FOREIGN KEY ([MeasurementPeriodId]) REFERENCES [serve].[PlanReportingPeriod] ([Id]),
    CONSTRAINT [FK_serve_Measurement_Plan] FOREIGN KEY ([PlanId]) REFERENCES [serve].[Plan] ([Id]),
    CONSTRAINT [FK_serve_Measurement_Unit] FOREIGN KEY ([UnitId]) REFERENCES [serve].[Unit] ([Id]),
    CONSTRAINT [FK_serve_Measurement_VisibilityGroup] FOREIGN KEY ([VisibilityGroupId]) REFERENCES [serve].[VisibilityGroup] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_Measurement_Attachment_API]
    ON [serve].[Measurement]([AttachmentId] ASC, [RecordStatus] ASC, [VisibilityGroupId] ASC, [Id] ASC)
    INCLUDE([Name], [PlanId], [MeasurementPeriodId], [EntityId], [EntityTypeId], [EntityMainType], [MeasurementType], [UnitId], [CalculationMethod], [IsCommentPublic], [AttachmentPrototypeId], [UpdatedAt]);


GO

