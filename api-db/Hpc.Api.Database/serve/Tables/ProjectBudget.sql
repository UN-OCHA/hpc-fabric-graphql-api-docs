CREATE TABLE [serve].[ProjectBudget] (
    [Id]                  INT             NOT NULL,
    [ProjectId]           INT             NOT NULL,
    [BudgetSegmentName]   NVARCHAR (255)  NULL,
    [BudgetLineItemName]  NVARCHAR (500)  NULL,
    [BudgetBreakdownType] NVARCHAR (100)  NULL,
    [Amount]              DECIMAL (19, 4) NULL,
    [PercentValue]        DECIMAL (19, 8) NULL,
    [ContentJson]         NVARCHAR (MAX)  NULL,
    [RecordStatus]        VARCHAR (20)    CONSTRAINT [DF_serve_ProjectBudget_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]         DATETIME2 (0)   NULL,
    [CreatedAt]           DATETIME2 (0)   NULL,
    [UpdatedAt]           DATETIME2 (0)   NULL,
    [RefreshedAt]         DATETIME2 (0)   CONSTRAINT [DF_serve_ProjectBudget_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,

    CONSTRAINT [PK_serve_ProjectBudget] PRIMARY KEY CLUSTERED ([Id]),
    CONSTRAINT [CK_serve_ProjectBudget_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_ProjectBudget_Project] FOREIGN KEY ([ProjectId]) REFERENCES [serve].[Project] ([Id])
);
GO

CREATE NONCLUSTERED INDEX [IX_serve_ProjectBudget_ProjectId_RecordStatus]
    ON [serve].[ProjectBudget] ([ProjectId], [RecordStatus]);
GO