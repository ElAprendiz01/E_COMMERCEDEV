USE [DB_EcommerceAgent]
GO

CREATE OR ALTER PROCEDURE dbo.sp_GuardarConversacion
    @ConversationJson NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ConversacionID VARCHAR(50);
    DECLARE @UsuarioID VARCHAR(100);
    DECLARE @Idioma VARCHAR(10);
    DECLARE @UltimaIntencion VARCHAR(50);
    DECLARE @CarritoID VARCHAR(50);
    DECLARE @PedidoID VARCHAR(50);

    -- 1. Extraer los datos principales de la conversación
    SELECT 
        @ConversacionID = conversation_id,
        @UsuarioID = user_id
    FROM OPENJSON(@ConversationJson)
    WITH (
        conversation_id VARCHAR(50) '$.conversation_id',
        user_id VARCHAR(100) '$.user_id'
    );

    -- 2. Extraer los datos del contexto y variables de sesión
    SELECT 
        @Idioma = [language],
        @UltimaIntencion = last_intent,
        @CarritoID = cart_id,
        @PedidoID = order_id
    FROM OPENJSON(@ConversationJson, '$.context')
    WITH (
        [language] VARCHAR(10) '$.language',
        session_variables NVARCHAR(MAX) AS JSON
    )
    CROSS APPLY OPENJSON(session_variables)
    WITH (
        last_intent VARCHAR(50) '$.last_intent',
        cart_id VARCHAR(50) '$.cart_id',
        order_id VARCHAR(50) '$.order_id'
    );

    -- 3. Insertar o actualizar la cabecera de la conversación
    IF NOT EXISTS (SELECT 1 FROM Conversaciones WHERE ConversacionID = @ConversacionID)
    BEGIN
        INSERT INTO Conversaciones (ConversacionID, UsuarioID, Idioma, UltimaIntencion, CarritoID, PedidoID)
        VALUES (@ConversacionID, @UsuarioID, @Idioma, @UltimaIntencion, @CarritoID, @PedidoID);
    END
    ELSE
    BEGIN
        UPDATE Conversaciones
        SET Idioma = @Idioma,
            UltimaIntencion = @UltimaIntencion,
            CarritoID = @CarritoID,
            PedidoID = @PedidoID
        WHERE ConversacionID = @ConversacionID;

        -- Limpiar los mensajes anteriores para evitar duplicados si se envía el historial completo actualizado
        DELETE FROM Mensajes WHERE ConversacionID = @ConversacionID;
    END

    -- 4. Insertar los mensajes detallados de la conversación
    INSERT INTO Mensajes (ConversacionID, Rol, FechaHora, Intencion, Contenido, Metadata)
    SELECT 
        @ConversacionID,
        rol,
        CAST(fecha_hora AS DATETIME2),
        intencion,
        contenido,
        metadata
    FROM OPENJSON(@ConversationJson, '$.messages')
    WITH (
        rol VARCHAR(20) '$.role',
        fecha_hora VARCHAR(50) '$.timestamp',
        intencion VARCHAR(50) '$.intent',
        contenido NVARCHAR(MAX) '$.content',
        metadata NVARCHAR(MAX) '$.metadata' AS JSON
    );
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_ObtenerHistorialConversacion
    @ConversacionID VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Devolvemos los datos mapeados con alias en inglés para mantener compatibilidad directa con los esquemas del backend
    SELECT 
        m.MensajeID AS Id,
        m.Rol AS Role,
        m.FechaHora AS Timestamp,
        m.Intencion AS Intent,
        m.Contenido AS Content,
        m.Metadata AS Metadata
    FROM Mensajes m
    WHERE m.ConversacionID = @ConversacionID
    ORDER BY m.FechaHora ASC;
END;
GO


exec sp_ObtenerHistorialConversacion '1'