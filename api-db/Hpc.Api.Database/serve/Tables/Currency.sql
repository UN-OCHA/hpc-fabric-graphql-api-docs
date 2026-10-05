CREATE TABLE [serve].[Currency] (
    [Id]           SMALLINT      NOT NULL,
    [Code]         VARCHAR (50)  NOT NULL,
    [RecordStatus] VARCHAR (20)  CONSTRAINT [DF_serve_Currency_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]  DATETIME2 (0) NULL,
    [CreatedAt]    DATETIME2 (0) NULL,
    [UpdatedAt]    DATETIME2 (0) NULL,
    [RefreshedAt]  DATETIME2 (0) CONSTRAINT [DF_serve_Currency_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_Currency] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_Currency_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active'),
    CONSTRAINT [UQ_serve_Currency_Code] UNIQUE NONCLUSTERED ([Code] ASC)
);


GO

