CREATE TABLE [serve].[AttachmentPrototype] (
    [Id]           INT            NOT NULL,
    [RefCode]      VARCHAR (255)  NOT NULL,
    [Type]         VARCHAR (255)  NOT NULL,
    [Value]        NVARCHAR (MAX) NOT NULL,
    [Value2]       NVARCHAR (MAX) NOT NULL,
    [PlanId]       INT            NOT NULL,
    [RecordStatus] VARCHAR (20)   CONSTRAINT [DF_serve_AttachmentPrototype_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]  DATETIME2 (0)  NULL,
    [CreatedAt]    DATETIME2 (0)  NULL,
    [UpdatedAt]    DATETIME2 (0)  NULL,
    [RefreshedAt]  DATETIME2 (0)  CONSTRAINT [DF_serve_AttachmentPrototype_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_AttachmentPrototype] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_AttachmentPrototype_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [CK_serve_AttachmentPrototype_Value_IsJson] CHECK (isjson([Value])=(1)),
    CONSTRAINT [FK_serve_AttachmentPrototype_Plan] FOREIGN KEY ([PlanId]) REFERENCES [serve].[Plan] ([Id]),
    CONSTRAINT [UQ_serve_AttachmentPrototype_PlanId_RefCode] UNIQUE NONCLUSTERED ([PlanId] ASC, [RefCode] ASC)
);


GO

