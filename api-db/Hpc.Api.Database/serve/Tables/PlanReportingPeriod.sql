CREATE TABLE [serve].[PlanReportingPeriod] (
    [Id]                    INT           NOT NULL,
    [StartDate]             DATE          NULL,
    [EndDate]               DATE          NULL,
    [ExpiryDate]            DATE          NULL,
    [PeriodNumber]          INT           NULL,
    [PlanId]                INT           NULL,
    [MeasurementsGenerated] BIT           CONSTRAINT [DF_serve_PlanReportingPeriod_MeasurementsGenerated] DEFAULT ((0)) NOT NULL,
    [RecordStatus]          VARCHAR (20)  CONSTRAINT [DF_serve_PlanReportingPeriod_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]           DATETIME2 (0) NULL,
    [CreatedAt]             DATETIME2 (0) NULL,
    [UpdatedAt]             DATETIME2 (0) NULL,
    [RefreshedAt]           DATETIME2 (0) CONSTRAINT [DF_serve_PlanReportingPeriod_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_PlanReportingPeriod] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_PlanReportingPeriod_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_PlanReportingPeriod_Plan] FOREIGN KEY ([PlanId]) REFERENCES [serve].[Plan] ([Id])
);


GO

CREATE NONCLUSTERED INDEX [IX_serve_PlanReportingPeriod_Plan]
    ON [serve].[PlanReportingPeriod]([PlanId] ASC, [RecordStatus] ASC)
    INCLUDE([Id], [StartDate], [EndDate], [PeriodNumber]);


GO

