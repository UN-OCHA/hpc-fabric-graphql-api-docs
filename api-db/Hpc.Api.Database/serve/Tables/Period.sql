CREATE TABLE [serve].[Period] (
    [Id]           INT            NOT NULL,
    [Name]         NVARCHAR (150) NOT NULL,
    [Description]  NVARCHAR (500) NULL,
    [PeriodType]   NVARCHAR (50)  NOT NULL,
    [CalendarYear] INT            NULL,
    [StartDate]    DATE           NOT NULL,
    [EndDate]      DATE           NOT NULL,
    [RecordStatus] VARCHAR (20)   CONSTRAINT [DF_serve_Period_RecordStatus] DEFAULT ('Active') NOT NULL,
    [ActiveUntil]  DATETIME2 (0)  NULL,
    [CreatedAt]    DATETIME2 (0)  NULL,
    [UpdatedAt]    DATETIME2 (0)  NULL,
    [RefreshedAt]  DATETIME2 (0)  CONSTRAINT [DF_serve_Period_RefreshedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_serve_Period] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_serve_Period_RecordStatus] CHECK ([RecordStatus]='Deleted' OR [RecordStatus]='Inactive' OR [RecordStatus]='Active')
);


GO

