CREATE TABLE [serve].[CustomQuestionOption] (
    [Id]               INT            NOT NULL,
    [CustomQuestionId] INT            NOT NULL,
    [OptionCode]       NVARCHAR (250) NULL,
    [OptionValue]      NVARCHAR (MAX) NOT NULL,
    [OptionLabel]      NVARCHAR (MAX) NULL,
    [OptionJson]       NVARCHAR (MAX) NULL,
    [SortOrder]        INT            NOT NULL,
    [RecordStatus]     VARCHAR (20)   CONSTRAINT [DF_serve_CustomQuestionOption_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]      DATETIME2 (0)  NULL,
    [CreatedAt]        DATETIME2 (0)  NULL,
    [UpdatedAt]        DATETIME2 (0)  NULL,
    [RefreshedAt]      DATETIME2 (0)  CONSTRAINT [DF_serve_CustomQuestionOption_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_CustomQuestionOption] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_CustomQuestionOption_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [FK_serve_CustomQuestionOption_CustomQuestion] FOREIGN KEY ([CustomQuestionId]) REFERENCES [serve].[CustomQuestion] ([Id]),
    CONSTRAINT [UQ_serve_CustomQuestionOption_Order] UNIQUE NONCLUSTERED ([CustomQuestionId] ASC, [SortOrder] ASC)
);


GO

