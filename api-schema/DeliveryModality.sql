-- Create public API view for current visible DeliveryModality records.
CREATE   VIEW api.[DeliveryModality]
AS
SELECT
    [Id],
    [Name],
    [Description],
    [CreatedAt],
    [UpdatedAt]
FROM serve.[DeliveryModality]
WHERE RecordStatus = 'Active'

GO

