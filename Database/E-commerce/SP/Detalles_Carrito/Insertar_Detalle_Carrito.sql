USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_CartDetails_Create]
(
    @userId INT,
    @productVariableId INT,
    @quantity INT,
    @discount DECIMAL(18,2) = 0,
    @creatorId INT,
    @statusId BIT = 1,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- 1. Validaciones Preliminares de Nulidad y Rango
    IF @userId IS NULL OR @userId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de usuario (@userId) es obligatorio.';
        RETURN;
    END;

    IF @productVariableId IS NULL OR @productVariableId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de la variante de producto (@productVariableId) es obligatorio.';
        RETURN;
    END;

    IF @quantity IS NULL OR @quantity <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La cantidad (@quantity) debe ser mayor a cero.';
        RETURN;
    END;

    IF @discount IS NULL OR @discount < 0
    BEGIN
        SET @discount = 0; -- Valor por defecto
    END;

    IF @creatorId IS NULL OR @creatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador (@creatorId) es obligatorio.';
        RETURN;
    END;

    IF @statusId IS NULL
    BEGIN
        SET @statusId = 1;
    END;

    -- 2. Validar existencia y estado del usuario comprador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @userId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario comprador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- 3. Validar existencia y estado del creador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @creatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador especificado no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- 4. Validar existencia de la Variante de Producto Activa y obtener precio/moneda
    -- Si @productVariableId fue enviado como ProductID, resolver automáticamente su variante activa:
    IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_ProductVariables] WHERE productVariableId = @productVariableId AND productVariableStatusId = 1)
    BEGIN
        SELECT TOP 1 @productVariableId = productVariableId
        FROM [SQM_GENERAL].[Tbl_ProductVariables]
        WHERE productVariableProductId = @productVariableId AND productVariableStatusId = 1
        ORDER BY productVariableId ASC;
    END;

    DECLARE @Price DECIMAL(18,2);
    DECLARE @CurrencyId INT;

    SELECT @Price = productVariablePrice, 
           @CurrencyId = productVariableCurrencyId
    FROM [SQM_GENERAL].[Tbl_ProductVariables] 
    WHERE productVariableId = @productVariableId AND productVariableStatusId = 1;

    IF @Price IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La variante de producto especificada no existe, está inactiva o no tiene precio definido.';
        RETURN;
    END;

    -- 5. Validación de Inventario (Stock disponible no expirado en Tbl_Stocks)
    DECLARE @AvailableStock INT = 0;
    SELECT @AvailableStock = COALESCE(SUM(stockQuantity), 0)
    FROM [SQM_GENERAL].[Tbl_Stocks]
    WHERE stockProductVariableId = @productVariableId 
      AND stockStatusId = 1 
      AND stockExpirationDate >= CAST(GETDATE() AS DATE);

    IF @AvailableStock < @quantity
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Stock insuficiente. Stock disponible y no expirado: ' + CAST(@AvailableStock AS VARCHAR(10));
        RETURN;
    END;

    -- 6. Autogestionar Cabecera del Carrito (Get or Create)
    DECLARE @CartId INT;
    
    -- Intentar obtener el carrito activo para el usuario
    SELECT @CartId = cartId 
    FROM [SQM_GENERAL].[Tbl_Carts] 
    WHERE cartUserId = @userId AND cartStatusId = 1;

    -- Si no existe, lo creamos de forma automática en una transacción
    IF @CartId IS NULL
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            INSERT INTO [SQM_GENERAL].[Tbl_Carts] 
            (
                cartUserId, 
                cartCreatorId, 
                cartCreationDate, 
                cartStatusId
            )
            VALUES 
            (
                @userId, 
                @creatorId, 
                GETDATE(), 
                1 -- Carrito activo
            );

            SET @CartId = SCOPE_IDENTITY();

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
            SET @o_code = ERROR_NUMBER();
            SET @o_message = 'Error al crear la cabecera del carrito: ' + ERROR_MESSAGE();
            RETURN;
        END CATCH;
    END;

    -- 7. Validación de Registro Duplicado en el mismo Carrito (Combinar cantidades)
    DECLARE @ExistingDetailId INT;
    DECLARE @ExistingQuantity INT;
    SELECT @ExistingDetailId = cartDetailId, 
           @ExistingQuantity = cartDetailQuantity
    FROM [SQM_GENERAL].[Tbl_CartDetails]
    WHERE cartDetailCartId = @CartId 
      AND cartDetailProductVariableId = @productVariableId 
      AND cartDetailStatusId = 1;

    -- Declaración de variables para cálculos automáticos en base a precio real
    DECLARE @CalculatedSubTotal DECIMAL(18,2);
    DECLARE @CalculatedTAX DECIMAL(18,2);
    DECLARE @CalculatedTotal DECIMAL(18,2);

    IF @ExistingDetailId IS NOT NULL
    BEGIN
        -- Validar stock sumando las cantidades acumuladas
        DECLARE @NewTotalQuantity INT = @ExistingQuantity + @quantity;
        
        IF @AvailableStock < @NewTotalQuantity
        BEGIN
            SET @o_code = -1;
            SET @o_message = 'Stock insuficiente al acumular la cantidad en el carrito. Stock disponible: ' + CAST(@AvailableStock AS VARCHAR(10)) + ', Requerido acumulado: ' + CAST(@NewTotalQuantity AS VARCHAR(10));
            RETURN;
        END;

        -- Calcular nuevos valores financieros acumulados
        SET @CalculatedSubTotal = @NewTotalQuantity * @Price;
        SET @CalculatedTAX = (@CalculatedSubTotal - @discount) * 0.15; -- IVA 15%
        SET @CalculatedTotal = (@CalculatedSubTotal - @discount) + @CalculatedTAX;

        -- Actualizar acumulado
        BEGIN TRY
            BEGIN TRANSACTION;

            UPDATE [SQM_GENERAL].[Tbl_CartDetails]
            SET cartDetailQuantity = @NewTotalQuantity,
                cartDetailPrice = @Price,
                cartDetailDiscount = @discount,
                cartDetailSubTotal = @CalculatedSubTotal,
                cartDetailTAX = @CalculatedTAX,
                cartDetailTotal = @CalculatedTotal,
                cartDetailModificatorId = @creatorId,
                cartDetailModificationDate = GETDATE()
            WHERE cartDetailId = @ExistingDetailId;

            COMMIT TRANSACTION;

            SET @o_code = 200;
            SET @o_message = 'Cantidad de producto acumulada en el detalle de carrito existente.';
            SET @o_templateId = @ExistingDetailId;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
            SET @o_code = ERROR_NUMBER();
            SET @o_message = ERROR_MESSAGE();
            SET @o_templateId = NULL;
        END CATCH;
        
        RETURN;
    END;

    -- 8. Inserción de un detalle nuevo en el carrito
    -- Calcular valores financieros basados en precio del catálogo
    SET @CalculatedSubTotal = @quantity * @Price;
    SET @CalculatedTAX = (@CalculatedSubTotal - @discount) * 0.15; -- IVA 15%
    SET @CalculatedTotal = (@CalculatedSubTotal - @discount) + @CalculatedTAX;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [SQM_GENERAL].[Tbl_CartDetails] 
        (
            cartDetailCartId, 
            cartDetailProductVariableId, 
            cartDetailPrice, 
            cartDetailQuantity, 
            cartDetailDiscount, 
            cartDetailSubTotal, 
            cartDetailTAX, 
            cartDetailTotal, 
            cartDetailCurrencyId, 
            cartDetailCreatorId, 
            cartDetailCreationDate, 
            cartDetailStatusId
        )
        VALUES 
        (
            @CartId, 
            @productVariableId, 
            @Price, 
            @quantity, 
            @discount, 
            @CalculatedSubTotal, 
            @CalculatedTAX, 
            @CalculatedTotal, 
            @CurrencyId, 
            @creatorId, 
            GETDATE(), 
            @statusId
        );

        SET @o_templateId = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Detalle de carrito insertado correctamente (y cabecera gestionada).';
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


-- EJEMPLO DE PRUEBA / EJECUCIÓN CON AUTOGESTIÓN DE CABECERA

DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

EXEC [SQM_GENERAL].[sp_CartDetails_Create]
    @userId = 1,                 -- El SP buscará el carrito activo de este usuario, si no hay, creará uno
    @productVariableId = 1,      -- Variante a comprar
    @quantity = 2,               -- Cantidad a agregar
    @discount = 0.00,            -- Descuento
    @creatorId = 1,              -- Creador
    @statusId = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado, 
    @v_templateId AS CartDetailIdGenerado;
GO


select * from [SQM_GENERAL].[Tbl_Carts]

select * from [SQM_GENERAL].[Tbl_CartDetails]