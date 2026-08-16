USE [DB_ECOMMERCE]
GO

-- 1. CREAR CON VALIDACIONES Y PARÁMETROS DE SALIDA (AUTOMERGE DE LOTES)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_Stocks_Create]
(
    @stockProductVariableId INT,
    @stockQuantity INT,
    @stockFactoryDate DATE,
    @stockExpirationDate DATE,
    @stockCreatorId INT,
    @stockStatusId BIT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Validaciones preliminares
    IF @stockProductVariableId IS NULL OR @stockProductVariableId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la variante de producto (@stockProductVariableId) es obligatorio.';
        RETURN;
    END;

    IF @stockQuantity IS NULL OR @stockQuantity < 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La cantidad de stock (@stockQuantity) es obligatoria y no puede ser negativa.';
        RETURN;
    END;

    IF @stockFactoryDate IS NULL OR @stockExpirationDate IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Las fechas de fabricación y vencimiento son obligatorias.';
        RETURN;
    END;

    IF @stockFactoryDate > @stockExpirationDate
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La fecha de fabricación no puede ser posterior a la fecha de vencimiento.';
        RETURN;
    END;

    IF @stockCreatorId IS NULL OR @stockCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador (@stockCreatorId) es obligatorio y debe ser mayor a cero.';
        RETURN;
    END;

    IF @stockStatusId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado del stock (@stockStatusId) es obligatorio.';
        RETURN;
    END;

    -- Validar existencia y estado activo del producto variante
    IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_ProductVariables] WHERE productVariableId = @stockProductVariableId AND productVariableStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La variante de producto especificada no existe o se encuentra inactiva.';
        RETURN;
    END;

    -- Validar creador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @stockCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- Bloque transaccional con lógica de fusión (Auto-Merge)
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ExistingStockId INT;
        
        -- Buscar si ya existe el mismo lote (mismo producto, misma fecha de fabricación y de expiración)
        SELECT @ExistingStockId = stockId
        FROM [SQM_GENERAL].[Tbl_Stocks]
        WHERE stockProductVariableId = @stockProductVariableId
          AND stockFactoryDate = @stockFactoryDate
          AND stockExpirationDate = @stockExpirationDate
          AND stockStatusId = 1;

        IF @ExistingStockId IS NOT NULL
        BEGIN
            -- Si ya existe, sumamos la cantidad (Auto-Merge)
            UPDATE [SQM_GENERAL].[Tbl_Stocks]
            SET stockQuantity = stockQuantity + @stockQuantity,
                stockModificatorId = @stockCreatorId,
                stockModificationDate = GETDATE()
            WHERE stockId = @ExistingStockId;

            SET @o_templateId = @ExistingStockId;
            SET @o_message = 'Lote existente detectado. Cantidad sumada correctamente al stock.';
        END;
        ELSE
        BEGIN
            -- Si no existe, creamos un nuevo lote
            INSERT INTO [SQM_GENERAL].[Tbl_Stocks]
            (
                stockProductVariableId,
                stockQuantity,
                stockFactoryDate,
                stockExpirationDate,
                stockCreatorId,
                stockCreationDate,
                stockStatusId
            )
            VALUES
            (
                @stockProductVariableId,
                @stockQuantity,
                @stockFactoryDate,
                @stockExpirationDate,
                @stockCreatorId,
                GETDATE(),
                @stockStatusId
            );

            SET @o_templateId = SCOPE_IDENTITY();
            SET @o_message = 'Nuevo lote de stock registrado correctamente.';
        END;

        COMMIT TRANSACTION;
        SET @o_code = 200;
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
