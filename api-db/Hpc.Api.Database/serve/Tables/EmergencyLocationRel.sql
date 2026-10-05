CREATE TABLE [serve].[EmergencyLocationRel] (
    [EmergencyId] SMALLINT NOT NULL,
    [LocationId]  INT      NOT NULL,
    CONSTRAINT [PK_serve_EmergencyLocationRel] PRIMARY KEY CLUSTERED ([EmergencyId] ASC, [LocationId] ASC),
    CONSTRAINT [FK_serve_EmergencyLocationRel_Emergency] FOREIGN KEY ([EmergencyId]) REFERENCES [serve].[Emergency] ([Id]),
    CONSTRAINT [FK_serve_EmergencyLocationRel_Location] FOREIGN KEY ([LocationId]) REFERENCES [serve].[Location] ([Id])
);


GO

