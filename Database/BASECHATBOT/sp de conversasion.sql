USE [DB_EcommerceAgent]
GO

CREATE OR ALTER PROCEDURE dbo.sp_GuardarConversacion
    @ConversacionID BIGINT = NULL, 
    @UsuarioID VARCHAR(100),
    @ChatBot BIT,
    @Texto NVARCHAR(MAX), -- Cambiado a NVARCHAR para soportar emojis y textos largos
    @ReglaActivadaID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @IDFinal BIGINT = @ConversacionID;

        -- 1. Si el ID viene nulo o no existe en la base de datos, creamos una nueva conversación
        IF @IDFinal IS NULL OR NOT EXISTS (SELECT 1 FROM dbo.HistorialConversaciones WITH (NOLOCK) WHERE ConversacionID = @IDFinal)
        BEGIN
            INSERT INTO dbo.HistorialConversaciones (UsuarioID, FechaInicio, Activo)
            VALUES (@UsuarioID, GETDATE(), 1);
            
            SET @IDFinal = SCOPE_IDENTITY();
        END

        -- 2. Insertar el mensaje ligado a la conversación
        INSERT INTO dbo.HistorialMensajes (ConversacionID, ChatBot, Texto, FechaHora, ReglaActivadaID)
        VALUES (@IDFinal, @ChatBot, @Texto, GETDATE(), @ReglaActivadaID);

        COMMIT TRANSACTION;

        -- 3. Retornar el ID final asignado
        SELECT @IDFinal AS ConversacionID;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Re-lanzar el error original para que FastAPI lo capture correctamente
        THROW;
    END CATCH
END;
GO