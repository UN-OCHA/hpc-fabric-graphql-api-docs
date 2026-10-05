CREATE TABLE [serve].[ProjectAttachmentTarget] (
    [Id]                            INT             NOT NULL,
    [ProjectId]                     INT             NOT NULL,
    [AttachmentId]                  INT             NOT NULL,
    [MetricTypeId]                  SMALLINT        NULL,
    [LocationId]                    INT             NULL,
    [GenderId]                      SMALLINT        NULL,
    [AgeGroupId]                    SMALLINT        NULL,
    [PopulationStatusId]            SMALLINT        NULL,
    [SettlementTypeId]              SMALLINT        NULL,
    [DisabilityStatusId]            SMALLINT        NULL,
    [HealthInterventionCategoryId]  SMALLINT        NULL,
    [MaternalStatusId]              SMALLINT        NULL,
    [DisaggregationCategoryOtherId] SMALLINT        NULL,
    [IsTotal]                       BIT             CONSTRAINT [DF_serve_ProjectAttachmentTarget_IsTotal] DEFAULT ((0)) NOT NULL,
    [ValueNum]                      DECIMAL (19, 4) NULL,
    [VisibilityGroupId]             TINYINT         CONSTRAINT [DF_serve_ProjectAttachmentTarget_VisibilityGroupId] DEFAULT ((1)) NOT NULL,
    [CreatedAt]                     DATETIME2 (0)   NULL,
    [UpdatedAt]                     DATETIME2 (0)   NULL,
    [RefreshedAt]                   DATETIME2 (0)   CONSTRAINT [DF_serve_ProjectAttachmentTarget_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_ProjectAttachmentTarget] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_serve_ProjectAttachmentTarget_Attachment] FOREIGN KEY ([AttachmentId]) REFERENCES [serve].[Attachment] ([Id]),
    CONSTRAINT [FK_serve_ProjectAttachmentTarget_Project] FOREIGN KEY ([ProjectId]) REFERENCES [serve].[Project] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_ProjectAttachmentTarget_Attachment_Project]
    ON [serve].[ProjectAttachmentTarget]([AttachmentId] ASC, [ProjectId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_serve_ProjectAttachmentTarget_Project_Attachment]
    ON [serve].[ProjectAttachmentTarget]([ProjectId] ASC, [AttachmentId] ASC);


GO

