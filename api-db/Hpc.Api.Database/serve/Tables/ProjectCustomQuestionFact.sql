CREATE TABLE [serve].[ProjectCustomQuestionFact] (
    [Id]                INT             NOT NULL,
    [ProjectId]         INT             NOT NULL,
    [PlanId]            INT             NOT NULL,
    [CustomQuestionId]  INT             NOT NULL,
    [ValueText]         NVARCHAR (MAX)  NULL,
    [ValueNumber]       DECIMAL (18, 4) NULL,
    [ValueBit]          BIT             NULL,
    [ValueJson]         NVARCHAR (MAX)  NULL,
    [VisibilityGroupId] TINYINT         CONSTRAINT [DF_serve_ProjectCustomQuestionFact_VisibilityGroupId] DEFAULT ((1)) NOT NULL,
    [RecordStatus]      VARCHAR (20)    CONSTRAINT [DF_serve_ProjectCustomQuestionFact_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]       DATETIME2 (0)   NULL,
    [CreatedAt]         DATETIME2 (0)   NULL,
    [UpdatedAt]         DATETIME2 (0)   NULL,
    [RefreshedAt]       DATETIME2 (0)   CONSTRAINT [DF_serve_ProjectCustomQuestionFact_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_ProjectCustomQuestionFact] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_ProjectCustomQuestionFact_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_ProjectCustomQuestionFact_CustomQuestion] FOREIGN KEY ([CustomQuestionId]) REFERENCES [serve].[CustomQuestion] ([Id]),
    CONSTRAINT [FK_serve_ProjectCustomQuestionFact_Plan] FOREIGN KEY ([PlanId]) REFERENCES [serve].[Plan] ([Id]),
    CONSTRAINT [FK_serve_ProjectCustomQuestionFact_Project] FOREIGN KEY ([ProjectId]) REFERENCES [serve].[Project] ([Id]),
    CONSTRAINT [FK_serve_ProjectCustomQuestionFact_VisibilityGroup] FOREIGN KEY ([VisibilityGroupId]) REFERENCES [serve].[VisibilityGroup] ([Id])
);


GO

