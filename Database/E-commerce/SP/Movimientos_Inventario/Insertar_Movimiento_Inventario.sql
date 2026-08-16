USE [DB_ECOMMERCE]
GO

-- 1. CREAR CON VALIDACIONES Y PARÁMETROS DE SALIDA
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_StockMovements_Create]
(
    @stockMovementType INT,
    @stockMovementOrderId INT = NULL,
    @stockMovementReference NVARCHAR(100) = NULL,
    @stockMovementDate DATETIME,
    @stockMovementCreatorId INT,
    @stockMovementStatusId INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares
    IF @stockMovementType IS NULL OR @stockMovementType <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de movimiento de stock (@stockMovementType) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @stockMovementDate IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La fecha del movimiento (@stockMovementDate) es obligatoria.';
        RETURN;
    END;

    IF @stockMovementCreatorId IS NULL OR @stockMovementCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador (@stockMovementCreatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @stockMovementStatusId IS NULL OR @stockMovementStatusId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del movimiento (@stockMovementStatusId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    -- Validar existencia y estado activo del tipo de movimiento
    IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_StockMovementTypes] WHERE stockMovementTypeId = @stockMovementType AND stockMovementTypeStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El tipo de movimiento de stock especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar creador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @stockMovementCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar estado
    IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_Status] WHERE statusId = @stockMovementStatusId AND statusStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado especificado para el movimiento no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Validar orden de pago si se especifica
    IF @stockMovementOrderId IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_PaymentOrders] WHERE orderId = @stockMovementOrderId)
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'La orden de pago especificada no existe.';
            RETURN;
        END;
    END;

    -- Bloque transaccional para la inserción
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [SQM_GENERAL].[Tbl_StockMovements]
        (
            stockMovementType,
            stockMovementOrderId,
            stockMovementReference,
            stockMovementDate,
            stockMovementCreatorId,
            stockMovementCreationDate,
            stockMovementStatusId
        )
        VALUES
        (
            @stockMovementType,
            @stockMovementOrderId,
            TRIM(@stockMovementReference),
            @stockMovementDate,
            @stockMovementCreatorId,
            GETDATE(),
            @stockMovementStatusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Movimiento de inventario creado correctamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
        SET @o_templateId = NULL;
    END CATCH;
END;
GO




DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

-- Ejecutar el procedimiento
EXEC [SQM_GENERAL].[sp_StockMovements_Create]
    @stockMovementType = 1,                         -- ID del catálogo Tbl_StockMovementTypes
    @stockMovementOrderId = NULL,                    -- NULL si es un ajuste manual / ID si pertenece a una Ordenen este caso tenemos 1 y 2
    @stockMovementReference = 'Ajuste inicial ', 
    @stockMovementDate = '2026-07-06 20:00:00',     -- Fecha del movimiento
    @stockMovementCreatorId = 1,                    -- Héctor Calero (userId = 1) 
    @stockMovementStatusId = 1,                     -- Estado: ACTIVO (statusId = 1)
    
    -- Parámetros de salida
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

-- Mostrar los resultados en consola
SELECT 
    @v_code AS [CodigoRespuesta],
    @v_message AS [MensajeRespuesta],
    @v_templateId AS [MovementIdGenerado];
GO



SELECT * FROM [SQM_CATALOGS].[Tbl_StockMovementTypes];

SELECT * FROM [SQM_GENERAL].[Tbl_PaymentOrders];

SELECT * FROM [SQM_SECURITY].[Tbl_Users];


SELECT * FROM [SQM_CATALOGS].[Tbl_Status];