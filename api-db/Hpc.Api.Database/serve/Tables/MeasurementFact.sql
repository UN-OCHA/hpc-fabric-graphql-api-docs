CREATE TABLE [serve].[MeasurementFact] (
    [Id]                            INT             NOT NULL,
    [AttachmentId]                  INT             NOT NULL,
    [MeasurementId]                 INT             NOT NULL,
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
    [IsTotal]                       BIT             CONSTRAINT [DF_serve_MeasurementFact_IsTotal] DEFAULT ((0)) NOT NULL,
    [ValueNum]                      DECIMAL (19, 4) NULL,
    [CustomMetricName]              NVARCHAR (100)  NULL,
    [DerivedMetricSource]           NVARCHAR (50)   NULL,
    [VisibilityGroupId]             TINYINT         CONSTRAINT [DF_serve_MeasurementFact_VisibilityGroupId] DEFAULT ((1)) NOT NULL,
    [CreatedAt]                     DATETIME2 (0)   NULL,
    [UpdatedAt]                     DATETIME2 (0)   NULL,
    [RefreshedAt]                   DATETIME2 (0)   CONSTRAINT [DF_serve_MeasurementFact_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_MeasurementFact] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_serve_MeasurementFact_AgeGroup] FOREIGN KEY ([AgeGroupId]) REFERENCES [serve].[AgeGroup] ([Id]),
    CONSTRAINT [FK_serve_MeasurementFact_Attachment] FOREIGN KEY ([AttachmentId]) REFERENCES [serve].[Attachment] ([Id]),
    CONSTRAINT [FK_serve_MeasurementFact_DeliveryModality] FOREIGN KEY ([DeliveryModalityId]) REFERENCES [serve].[DeliveryModality] ([Id]),
    CONSTRAINT [FK_serve_MeasurementFact_DisabilityStatus] FOREIGN KEY ([DisabilityStatusId]) REFERENCES [serve].[DisabilityStatus] ([Id]),
    CONSTRAINT [FK_serve_MeasurementFact_DisaggregationCategoryOther] FOREIGN KEY ([DisaggregationCategoryOtherId]) REFERENCES [serve].[DisaggregationCategoryOther] ([Id]),
    CONSTRAINT [FK_serve_MeasurementFact_Gender] FOREIGN KEY ([GenderId]) REFERENCES [serve].[Gender] ([Id]),
    CONSTRAINT [FK_serve_MeasurementFact_HealthInterventionCategory] FOREIGN KEY ([HealthInterventionCategoryId]) REFERENCES [serve].[HealthInterventionCategory] ([Id]),
    CONSTRAINT [FK_serve_MeasurementFact_Location] FOREIGN KEY ([LocationId]) REFERENCES [serve].[Location] ([Id]),
    CONSTRAINT [FK_serve_MeasurementFact_MaternalStatus] FOREIGN KEY ([MaternalStatusId]) REFERENCES [serve].[MaternalStatus] ([Id]),
    CONSTRAINT [FK_serve_MeasurementFact_Measurement] FOREIGN KEY ([MeasurementId]) REFERENCES [serve].[Measurement] ([Id]),
    CONSTRAINT [FK_serve_MeasurementFact_MetricType] FOREIGN KEY ([MetricTypeId]) REFERENCES [serve].[MetricType] ([Id]),
    CONSTRAINT [FK_serve_MeasurementFact_PopulationStatus] FOREIGN KEY ([PopulationStatusId]) REFERENCES [serve].[PopulationStatus] ([Id]),
    CONSTRAINT [FK_serve_MeasurementFact_SettlementType] FOREIGN KEY ([SettlementTypeId]) REFERENCES [serve].[SettlementType] ([Id]),
    CONSTRAINT [FK_serve_MeasurementFact_VisibilityGroup] FOREIGN KEY ([VisibilityGroupId]) REFERENCES [serve].[VisibilityGroup] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_MeasurementFact_AttachmentId]
    ON [serve].[MeasurementFact]([AttachmentId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_serve_MeasurementFact_MeasurementId]
    ON [serve].[MeasurementFact]([MeasurementId] ASC);


GO

CREATE NONCLUSTERED INDEX [nci_msft_1_MeasurementFact_359944650953EAB17B546641D3D4724E]
    ON [serve].[MeasurementFact]([VisibilityGroupId] ASC, [AttachmentId] ASC, [LocationId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_serve_MeasurementFact_Measurement_IsTotal_Location_Id]
    ON [serve].[MeasurementFact]([MeasurementId] ASC, [IsTotal] ASC, [LocationId] ASC, [Id] ASC)
    INCLUDE([AttachmentId], [MetricTypeId], [GenderId], [AgeGroupId], [PopulationStatusId], [SettlementTypeId], [DisabilityStatusId], [HealthInterventionCategoryId], [MaternalStatusId], [DisaggregationCategoryOtherId], [DeliveryModalityId], [CustomMetricName], [ValueNum]);


GO

CREATE NONCLUSTERED INDEX [nci_msft_1_MeasurementFact_F1945161D99CF58322AB0D207A707E74]
    ON [serve].[MeasurementFact]([IsTotal] ASC, [LocationId] ASC, [MeasurementId] ASC, [VisibilityGroupId] ASC)
    INCLUDE([AgeGroupId], [AttachmentId], [CustomMetricName], [DeliveryModalityId], [DisabilityStatusId], [DisaggregationCategoryOtherId], [GenderId], [HealthInterventionCategoryId], [MaternalStatusId], [MetricTypeId], [PopulationStatusId], [SettlementTypeId], [ValueNum]);


GO

CREATE NONCLUSTERED INDEX [IX_serve_MeasurementFact_Measurement_Total_NullLocation]
    ON [serve].[MeasurementFact]([MeasurementId] ASC)
    INCLUDE([Id], [AttachmentId], [MetricTypeId], [LocationId], [GenderId], [AgeGroupId], [PopulationStatusId], [SettlementTypeId], [DisabilityStatusId], [HealthInterventionCategoryId], [MaternalStatusId], [DisaggregationCategoryOtherId], [DeliveryModalityId], [CustomMetricName], [IsTotal], [ValueNum]) WHERE ([IsTotal]=(1) AND [LocationId] IS NULL);


GO

