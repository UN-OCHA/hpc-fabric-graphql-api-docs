CREATE TABLE [serve].[CustomQuestionDependency] (
    [Id]                        INT           NOT NULL,
    [CustomQuestionId]          INT           NOT NULL,
    [DependsOnCustomQuestionId] INT           NOT NULL,
    [RecordStatus]              VARCHAR (20)  CONSTRAINT [DF_serve_CustomQuestionDependency_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]               DATETIME2 (0) NULL,
    [CreatedAt]                 DATETIME2 (0) NULL,
    [UpdatedAt]                 DATETIME2 (0) NULL,
    [RefreshedAt]               DATETIME2 (0) CONSTRAINT [DF_serve_CustomQuestionDependency_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_CustomQuestionDependency] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_CustomQuestionDependency_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_CustomQuestionDependency_CustomQuestion] FOREIGN KEY ([CustomQuestionId]) REFERENCES [serve].[CustomQuestion] ([Id]),
    CONSTRAINT [FK_serve_CustomQuestionDependency_DependsOn] FOREIGN KEY ([DependsOnCustomQuestionId]) REFERENCES [serve].[CustomQuestion] ([Id]),
    CONSTRAINT [UQ_serve_CustomQuestionDependency] UNIQUE NONCLUSTERED ([CustomQuestionId] ASC, [DependsOnCustomQuestionId] ASC)
);


GO

