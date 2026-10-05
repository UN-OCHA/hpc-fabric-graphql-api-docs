CREATE TABLE [serve].[EntityPrototype] (
    [Id]           INT            NOT NULL,
    [RefCode]      VARCHAR (255)  NOT NULL,
    [Type]         VARCHAR (255)  NOT NULL,
    [PlanId]       INT            NOT NULL,
    [OrderNumber]  INT            NULL,
    [Value]        NVARCHAR (MAX) NOT NULL,
    [RecordStatus] VARCHAR (20)   CONSTRAINT [DF_serve_EntityPrototype_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]  DATETIME2 (0)  NULL,
    [CreatedAt]    DATETIME2 (0)  NULL,
    [UpdatedAt]    DATETIME2 (0)  NULL,
    [RefreshedAt]  DATETIME2 (0)  CONSTRAINT [DF_serve_EntityPrototype_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_EntityPrototype] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_EntityPrototype_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [CK_serve_EntityPrototype_Value_IsJson] CHECK (isjson([Value])=(1)),
    CONSTRAINT [FK_serve_EntityPrototype_Plan] FOREIGN KEY ([PlanId]) REFERENCES [serve].[Plan] ([Id]),
    CONSTRAINT [UQ_serve_EntityPrototype_PlanId_RefCode] UNIQUE NONCLUSTERED ([PlanId] ASC, [RefCode] ASC)
);


GO

