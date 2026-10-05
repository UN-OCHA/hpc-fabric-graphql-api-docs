CREATE TABLE [serve].[AttachmentFact] (
    [Id]                            INT             NOT NULL,
    [AttachmentId]                  INT             NOT NULL,
    [MetricTypeId]                  SMALLINT        NOT NULL,
    [LocationId]                    INT             NULL,
    [GenderId]                      SMALLINT        NULL,
    [AgeGroupId]                    SMALLINT        NULL,
    [PopulationStatusId]            SMALLINT        NULL,
    [SettlementTypeId]              SMALLINT        NULL,
    [DisabilityStatusId]            SMALLINT        NULL,
    [HealthInterventionCategoryId]  SMALLINT        NULL,
    [MaternalStatusId]              SMALLINT        NULL,
    [DisaggregationCategoryOtherId] SMALLINT        NULL,
    [DeliveryModalityId]            SMALLINT        NULL,
    [RevisionStateId]               TINYINT         NULL,
    [IsTotal]                       BIT             CONSTRAINT [DF_serve_AttachmentFact_IsTotal] DEFAULT ((0)) NOT NULL,
    [ValueNum]                      DECIMAL (19, 4) NULL,
    [CustomMetricName]              NVARCHAR (100)  NULL,
    [VisibilityGroupId]             TINYINT         CONSTRAINT [DF_serve_AttachmentFact_VisibilityGroupId] DEFAULT ((1)) NOT NULL,
    [CreatedAt]                     DATETIME2 (0)   NULL,
    [UpdatedAt]                     DATETIME2 (0)   NULL,
    [RefreshedAt]                   DATETIME2 (0)   CONSTRAINT [DF_serve_AttachmentFact_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    [DerivedMetricSource]           NVARCHAR (50)   NULL,
    [SectorId]                      SMALLINT        NULL,
    CONSTRAINT [PK_serve_AttachmentFact] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_AttachmentFact_Sector] FOREIGN KEY ([SectorId]) REFERENCES [serve].[Sector] ([Id]),
    CONSTRAINT [FK_serve_AttachmentFact_AgeGroup] FOREIGN KEY ([AgeGroupId]) REFERENCES [serve].[AgeGroup] ([Id]),
    CONSTRAINT [FK_serve_AttachmentFact_Attachment] FOREIGN KEY ([AttachmentId]) REFERENCES [serve].[Attachment] ([Id]),
    CONSTRAINT [FK_serve_AttachmentFact_DeliveryModality] FOREIGN KEY ([DeliveryModalityId]) REFERENCES [serve].[DeliveryModality] ([Id]),
    CONSTRAINT [FK_serve_AttachmentFact_DisabilityStatus] FOREIGN KEY ([DisabilityStatusId]) REFERENCES [serve].[DisabilityStatus] ([Id]),
    CONSTRAINT [FK_serve_AttachmentFact_DisaggregationCategoryOther] FOREIGN KEY ([DisaggregationCategoryOtherId]) REFERENCES [serve].[DisaggregationCategoryOther] ([Id]),
    CONSTRAINT [FK_serve_AttachmentFact_Gender] FOREIGN KEY ([GenderId]) REFERENCES [serve].[Gender] ([Id]),
    CONSTRAINT [FK_serve_AttachmentFact_HealthInterventionCategory] FOREIGN KEY ([HealthInterventionCategoryId]) REFERENCES [serve].[HealthInterventionCategory] ([Id]),
    CONSTRAINT [FK_serve_AttachmentFact_Location] FOREIGN KEY ([LocationId]) REFERENCES [serve].[Location] ([Id]),
    CONSTRAINT [FK_serve_AttachmentFact_MaternalStatus] FOREIGN KEY ([MaternalStatusId]) REFERENCES [serve].[MaternalStatus] ([Id]),
    CONSTRAINT [FK_serve_AttachmentFact_MetricType] FOREIGN KEY ([MetricTypeId]) REFERENCES [serve].[MetricType] ([Id]),
    CONSTRAINT [FK_serve_AttachmentFact_PopulationStatus] FOREIGN KEY ([PopulationStatusId]) REFERENCES [serve].[PopulationStatus] ([Id]),
    CONSTRAINT [FK_serve_AttachmentFact_RevisionState] FOREIGN KEY ([RevisionStateId]) REFERENCES [serve].[RevisionState] ([Id]),
    CONSTRAINT [FK_serve_AttachmentFact_SettlementType] FOREIGN KEY ([SettlementTypeId]) REFERENCES [serve].[SettlementType] ([Id]),
    CONSTRAINT [FK_serve_AttachmentFact_VisibilityGroup] FOREIGN KEY ([VisibilityGroupId]) REFERENCES [serve].[VisibilityGroup] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [nci_msft_1_AttachmentFact_FD8D5B9271382A32FF726026D0B6A2C9]
    ON [serve].[AttachmentFact]([AttachmentId] ASC, [VisibilityGroupId] ASC, [LocationId] ASC)
    INCLUDE([AgeGroupId], [CustomMetricName], [DeliveryModalityId], [DerivedMetricSource], [DisabilityStatusId], [DisaggregationCategoryOtherId], [GenderId], [HealthInterventionCategoryId], [Id], [IsTotal], [MaternalStatusId], [MetricTypeId], [PopulationStatusId], [RevisionStateId], [SettlementTypeId], [ValueNum]);


GO

CREATE NONCLUSTERED INDEX [IX_serve_AttachmentFact_Attachment_IsTotal_Location_Id]
    ON [serve].[AttachmentFact]([AttachmentId] ASC, [IsTotal] ASC, [LocationId] ASC, [Id] ASC)
    INCLUDE([MetricTypeId], [RevisionStateId], [GenderId], [AgeGroupId], [PopulationStatusId], [SettlementTypeId], [DisabilityStatusId], [HealthInterventionCategoryId], [MaternalStatusId], [DisaggregationCategoryOtherId], [DeliveryModalityId], [CustomMetricName], [ValueNum]);


GO

CREATE NONCLUSTERED INDEX [IX_serve_AttachmentFact_Attachment_Total_NullLocation]
    ON [serve].[AttachmentFact]([AttachmentId] ASC)
    INCLUDE([Id], [MetricTypeId], [RevisionStateId], [LocationId], [GenderId], [AgeGroupId], [PopulationStatusId], [SettlementTypeId], [DisabilityStatusId], [HealthInterventionCategoryId], [MaternalStatusId], [DisaggregationCategoryOtherId], [DeliveryModalityId], [CustomMetricName], [IsTotal], [ValueNum]) WHERE ([IsTotal]=(1) AND [LocationId] IS NULL);


GO

