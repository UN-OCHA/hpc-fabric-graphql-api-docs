CREATE TABLE [dba].[LegacyDisTypes] (
    [Id]                     BIGINT         IDENTITY (1, 1) NOT NULL,
    [PlanId]                 INT            NULL,
    [AttachmentId]           INT            NULL,
    [AttachmentVersionId]    INT            NULL,
    [MeasurementId]          BIGINT         NULL,
    [MeasurementVersionId]   BIGINT         NULL,
    [ReportingPeriodId]      INT            NULL,
    [LegacyHpcLocId]         INT            NULL,
    [LegacyHpcLocPcode]      NVARCHAR (100) NULL,
    [LegacyHpcLocParentId]   NVARCHAR (100) NULL,
    [LegacyHpcLocName]       NVARCHAR (200) NULL,
    [LegacyHpcLocParentName] NVARCHAR (200) NULL,
    [LegacyHpcCatId]         NVARCHAR (100) NULL,
    [LegacyHpcCatName]       NVARCHAR (250) NULL,
    [LegacyHpcCatLabel]      NVARCHAR (250) NULL,
    [LegacyHpcMetName]       NVARCHAR (200) NULL,
    [LegacyHpcMetType]       NVARCHAR (200) NULL,
    [LegacyValueType]        NVARCHAR (50)  NULL,
    [LegacySourceTable]      NVARCHAR (100) NULL,
    CONSTRAINT [PK_LegacyDisTypes] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_LegacyDisTypes_LegacyText]
    ON [dba].[LegacyDisTypes]([LegacyHpcCatName] ASC, [LegacyHpcCatLabel] ASC, [LegacyHpcMetType] ASC, [LegacyValueType] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_LegacyDisTypes_MainLookup]
    ON [dba].[LegacyDisTypes]([PlanId] ASC, [AttachmentId] ASC, [AttachmentVersionId] ASC, [MeasurementId] ASC, [MeasurementVersionId] ASC, [ReportingPeriodId] ASC);


GO

