CREATE TABLE [serve].[PlanTextContentRel] (
    [PlanId]        INT NOT NULL,
    [TextContentId] INT NOT NULL,
    CONSTRAINT [PK_serve_PlanTextContentRel] PRIMARY KEY CLUSTERED ([PlanId] ASC, [TextContentId] ASC),
    CONSTRAINT [FK_serve_PlanTextContentRel_Plan] FOREIGN KEY ([PlanId]) REFERENCES [serve].[Plan] ([Id]),
    CONSTRAINT [FK_serve_PlanTextContentRel_TextContent] FOREIGN KEY ([TextContentId]) REFERENCES [serve].[TextContent] ([Id])
);


GO

