USE [DB_EcommerceAgent]
GO

-- Asegurar que la columna Texto en HistorialMensajes permita mensajes de cualquier longitud y soporte caracteres UTF-8/emojis
IF EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'HistorialMensajes' AND COLUMN_NAME = 'Texto'
)
BEGIN
    ALTER TABLE dbo.HistorialMensajes ALTER COLUMN Texto NVARCHAR(MAX);
END
GO
