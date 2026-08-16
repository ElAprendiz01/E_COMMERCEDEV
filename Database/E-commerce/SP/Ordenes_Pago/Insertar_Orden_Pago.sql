USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_PaymentOrders_Create]
(
    @orderUserId INT,
    @orderDeliveryAddress INT,
    @orderPaymentMethodId INT,
    @orderSubtotal DECIMAL(18,2) = NULL,
    @orderDiscount DECIMAL(18,2) = NULL,
    @orderShipping DECIMAL(18,2) = 0,
    @orderTAX DECIMAL(18,2) = NULL,
    @orderTotal DECIMAL(18,2) = NULL,
    @orderCurrencyId INT = NULL,
    @orderCreatorId INT,
    @orderStatusId INT,
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- 1. Validaciones preliminares
    IF @orderUserId IS NULL OR @orderUserId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID de usuario (@orderUserId) es obligatorio.';
        RETURN;
    END;

    IF @orderDeliveryAddress IS NULL OR @orderDeliveryAddress <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La dirección de entrega (@orderDeliveryAddress) es obligatoria.';
        RETURN;
    END;

    IF @orderPaymentMethodId IS NULL OR @orderPaymentMethodId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El método de pago (@orderPaymentMethodId) es obligatorio.';
        RETURN;
    END;

    IF @orderCreatorId IS NULL OR @orderCreatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del creador (@orderCreatorId) es obligatorio.';
        RETURN;
    END;

    IF @orderStatusId IS NULL OR @orderStatusId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El estado de la orden (@orderStatusId) es obligatorio.';
        RETURN;
    END;

    -- 2. Validar existencia y estado del usuario comprador y del creador
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @orderUserId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario comprador no existe o se encuentra inactivo.';
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @orderCreatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario creador no existe o se encuentra inactivo.';
        RETURN;
    END;

    -- 3. VALIDACIÓN DE SEGURIDAD: Verificar que la dirección de entrega pertenezca al usuario comprador
    IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_UserAddress] 
                   WHERE userAddressId = @orderDeliveryAddress 
                     AND userAddressUserId = @orderUserId 
                     AND userAddressStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La dirección de entrega seleccionada no existe, está inactiva o no pertenece al usuario comprador.';
        RETURN;
    END;

    -- 4. VALIDACIÓN DE SEGURIDAD: Verificar que el método de pago pertenezca al usuario comprador
    IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_UserPaymentMethods] 
                   WHERE userPaymentMethodId = @orderPaymentMethodId 
                     AND userPaymentMethodUserId = @orderUserId 
                     AND userPaymentMethodStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El método de pago seleccionado no existe, está inactivo o no pertenece al usuario comprador.';
        RETURN;
    END;

    -- 5. Obtener el carrito activo del usuario
    DECLARE @CartId INT;
    SELECT @CartId = cartId 
    FROM [SQM_GENERAL].[Tbl_Carts] 
    WHERE cartUserId = @orderUserId AND cartStatusId = 1;

    IF @CartId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'No se encontró un carrito activo para el usuario especificado.';
        RETURN;
    END;

    -- Validar que el carrito tenga detalles
    IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_CartDetails] WHERE cartDetailCartId = @CartId AND cartDetailStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El carrito de compras está vacío.';
        RETURN;
    END;

    -- 6. Calcular automáticamente los totales del carrito si vienen nulos
    DECLARE @CalculatedSubtotal DECIMAL(18,2) = 0;
    DECLARE @CalculatedDiscount DECIMAL(18,2) = 0;
    DECLARE @CalculatedTAX DECIMAL(18,2) = 0;
    DECLARE @CalculatedTotal DECIMAL(18,2) = 0;
    DECLARE @CalculatedCurrencyId INT;

    SELECT 
        @CalculatedSubtotal = SUM(cartDetailSubTotal),
        @CalculatedDiscount = SUM(cartDetailDiscount),
        @CalculatedTAX = SUM(cartDetailTAX),
        @CalculatedTotal = SUM(cartDetailTotal),
        @CalculatedCurrencyId = MIN(cartDetailCurrencyId)
    FROM [SQM_GENERAL].[Tbl_CartDetails]
    WHERE cartDetailCartId = @CartId AND cartDetailStatusId = 1;

    IF @orderSubtotal IS NULL SET @orderSubtotal = @CalculatedSubtotal;
    IF @orderDiscount IS NULL SET @orderDiscount = @CalculatedDiscount;
    IF @orderTAX IS NULL SET @orderTAX = @CalculatedTAX;
    IF @orderTotal IS NULL SET @orderTotal = @CalculatedTotal + @orderShipping;
    IF @orderCurrencyId IS NULL SET @orderCurrencyId = @CalculatedCurrencyId;

    -- 7. VALIDAR SUFICIENCIA DE STOCK TOTAL ANTES DE INICIAR TRANSACCIÓN (Pre-check con bloqueo de fila UPDLOCK)
    IF EXISTS (
        SELECT 1
        FROM (
            SELECT cartDetailProductVariableId, SUM(cartDetailQuantity) AS ReqQty
            FROM [SQM_GENERAL].[Tbl_CartDetails]
            WHERE cartDetailCartId = @CartId AND cartDetailStatusId = 1
            GROUP BY cartDetailProductVariableId
        ) R
        LEFT JOIN (
            SELECT stockProductVariableId, SUM(stockQuantity) AS AvailQty
            FROM [SQM_GENERAL].[Tbl_Stocks] WITH (UPDLOCK, HOLDLOCK) -- Evita condiciones de carrera adquiriendo bloqueos
            WHERE stockStatusId = 1
            GROUP BY stockProductVariableId
        ) S ON R.cartDetailProductVariableId = S.stockProductVariableId
        WHERE S.stockProductVariableId IS NULL OR S.AvailQty < R.ReqQty
    )
    BEGIN
        DECLARE @FailedProductName VARCHAR(100);
        SELECT TOP 1 @FailedProductName = P.productName
        FROM (
            SELECT cartDetailProductVariableId, SUM(cartDetailQuantity) AS ReqQty
            FROM [SQM_GENERAL].[Tbl_CartDetails]
            WHERE cartDetailCartId = @CartId AND cartDetailStatusId = 1
            GROUP BY cartDetailProductVariableId
        ) R
        LEFT JOIN (
            SELECT stockProductVariableId, SUM(stockQuantity) AS AvailQty
            FROM [SQM_GENERAL].[Tbl_Stocks]
            WHERE stockStatusId = 1
            GROUP BY stockProductVariableId
        ) S ON R.cartDetailProductVariableId = S.stockProductVariableId
        INNER JOIN [SQM_GENERAL].[Tbl_ProductVariables] PV ON R.cartDetailProductVariableId = PV.productVariableId
        INNER JOIN [SQM_GENERAL].[Tbl_Products] P ON PV.productVariableProductId = P.productId
        WHERE S.stockProductVariableId IS NULL OR S.AvailQty < R.ReqQty;

        SET @o_code = -1;
        SET @o_message = 'Stock insuficiente para el producto: ' + ISNULL(@FailedProductName, 'Variante sin stock') + '.';
        RETURN;
    END;

    -- 8. Bloque transaccional del Checkout
    BEGIN TRY
        BEGIN TRANSACTION;

        -- A. Insertar cabecera de la Orden de Pago
        DECLARE @OrderId INT;
        INSERT INTO [SQM_GENERAL].[Tbl_PaymentOrders]
        (
            orderUserId,
            orderDeliveryAddress,
            orderPaymentMethodId,
            orderSubtotal,
            orderDiscount,
            orderShipping,
            orderTAX,
            orderTotal,
            orderCurrencyId,
            orderCreatorId,
            orderCreationDate,
            orderStatusId
        )
        VALUES
        (
            @orderUserId,
            @orderDeliveryAddress,
            @orderPaymentMethodId,
            @orderSubtotal,
            @orderDiscount,
            @orderShipping,
            @orderTAX,
            @orderTotal,
            @orderCurrencyId,
            @orderCreatorId,
            GETDATE(),
            @orderStatusId
        );

       SET @OrderId = SCOPE_IDENTITY();

        -- B. Crear la cabecera de Movimiento de Inventario (Salida por Venta - Tipo 2)
        DECLARE @MovementId INT;
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
            2, -- Salida por Venta
            @OrderId,
            'Venta automática. Orden ID: ' + CAST(@OrderId AS VARCHAR(10)),
            GETDATE(),
            @orderCreatorId,
            GETDATE(),
            1 -- Activo / Procesado
        );

     SET @MovementId = SCOPE_IDENTITY();

        -- C. Cursor para procesar detalles del carrito, descontar stock (FEFO) e insertar detalles de orden y Kardex
        DECLARE @CartDetailId INT,
                @ProdVarId INT,
                @Price DECIMAL(18,2),
                @Qty INT,
                @Discount DECIMAL(18,2),
                @Subtotal DECIMAL(18,2),
                @Tax DECIMAL(18,2),
                @Total DECIMAL(18,2),
                @CurrencyId INT;

        DECLARE cart_cursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT 
            cartDetailId,
            cartDetailProductVariableId,
            cartDetailPrice,
            cartDetailQuantity,
            cartDetailDiscount,
            cartDetailSubTotal,
            cartDetailTAX,
            cartDetailTotal,
            cartDetailCurrencyId
        FROM [SQM_GENERAL].[Tbl_CartDetails]
        WHERE cartDetailCartId = @CartId AND cartDetailStatusId = 1;

        OPEN cart_cursor;
        FETCH NEXT FROM cart_cursor INTO @CartDetailId, @ProdVarId, @Price, @Qty, @Discount, @Subtotal, @Tax, @Total, @CurrencyId;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- 1. Insertar el detalle de la Orden de Pago
            DECLARE @OrderDetailId INT;
            INSERT INTO [SQM_GENERAL].[Tbl_PaymentOrderDetails]
            (
                orderDetailOrderId,
                orderDetailProductVariableId,
                orderDetailPrice,
                orderDetailQuantity,
                orderDetailDiscount,
                orderDetailSubTotal,
                orderDetailTAX,
                orderDetailTotal,
                orderDetailCurrencyId,
                orderDetailCreatorId,
                orderDetailCreationDate,
                orderDetailStatusId
            )
            VALUES
            (
                @OrderId,
                @ProdVarId,
                @Price,
                @Qty,
                @Discount,
                @Subtotal,
                @Tax,
                @Total,
                @CurrencyId,
                @orderCreatorId,
                GETDATE(),
                1 -- Activo
            );

           SET @OrderDetailId = SCOPE_IDENTITY();

            -- 2. Descontar cantidad usando FEFO de Tbl_Stocks y crear detalles de Kardex
            DECLARE @RemainingQtyToDeduct INT = @Qty;
            
            DECLARE @StockId INT,
                    @StockQty INT;

            -- Se adquieren UPDLOCK en el cursor para evitar condiciones de carrera concurrentes
            DECLARE stock_cursor CURSOR LOCAL FAST_FORWARD FOR
            SELECT stockId, stockQuantity
            FROM [SQM_GENERAL].[Tbl_Stocks] WITH (UPDLOCK) 
            WHERE stockProductVariableId = @ProdVarId
              AND stockStatusId = 1
              AND stockQuantity > 0
            ORDER BY stockExpirationDate ASC, stockCreationDate ASC; -- FEFO

            OPEN stock_cursor;
            FETCH NEXT FROM stock_cursor INTO @StockId, @StockQty;

            WHILE @@FETCH_STATUS = 0 AND @RemainingQtyToDeduct > 0
            BEGIN
                DECLARE @DeductedQty INT = 0;

                IF @StockQty >= @RemainingQtyToDeduct
                BEGIN
                    SET @DeductedQty = @RemainingQtyToDeduct;
                    SET @RemainingQtyToDeduct = 0;
                END;
                ELSE
                BEGIN
                    SET @DeductedQty = @StockQty;
                    SET @RemainingQtyToDeduct = @RemainingQtyToDeduct - @StockQty;
                END;

                -- A. Restar de Tbl_Stocks
                UPDATE [SQM_GENERAL].[Tbl_Stocks]
                SET stockQuantity = stockQuantity - @DeductedQty,
                    stockModificatorId = @orderCreatorId,
                    stockModificationDate = GETDATE()
                WHERE stockId = @StockId;

                -- B. Insertar detalle de movimiento (Kardex)
                INSERT INTO [SQM_GENERAL].[Tbl_StockMovementDetails]
                (
                    stockMovementDetailMovementId,
                    stockMovementDetailOrderDetailId,
                    stockMovementDetailStockId,
                    stockMovementDetailQuantity,
                    stockMovementDetailCreatorId,
                    stockMovementDetailCreationDate,
                    stockMovementDetailStatusId
                )
                    VALUES
                (
                    @MovementId,
                    @OrderDetailId,
                    @StockId,
                    @DeductedQty,
                    @orderCreatorId,
                    GETDATE(),
                    1 -- Activo
                );

                FETCH NEXT FROM stock_cursor INTO @StockId, @StockQty;
            END;

            CLOSE stock_cursor;
            DEALLOCATE stock_cursor;

            -- Si después del FEFO todavía falta cantidad por deducir, lanzamos excepción para disparar ROLLBACK
            IF @RemainingQtyToDeduct > 0
            BEGIN
                DECLARE @DeductError VARCHAR(100) = 'Fallo en deducción FEFO para variante ID: ' + CAST(@ProdVarId AS VARCHAR(10));
                THROW 50000, @DeductError, 1;
            END;

            FETCH NEXT FROM cart_cursor INTO @CartDetailId, @ProdVarId, @Price, @Qty, @Discount, @Subtotal, @Tax, @Total, @CurrencyId;
        END;

        CLOSE cart_cursor;
        DEALLOCATE cart_cursor;

        -- D. Inactivar el carrito de compras del usuario
        UPDATE [SQM_GENERAL].[Tbl_Carts]
        SET cartStatusId = 0,
            cartModificatorId = @orderCreatorId,
            cartModificationDate = GETDATE()
        WHERE cartId = @CartId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Checkout realizado con éxito. Orden e inventarios actualizados correctamente.';
        SET @o_templateId = @OrderId;
    END TRY
    BEGIN CATCH
        -- Asegurar el cierre y liberación de cursores en caso de error
        IF CURSOR_STATUS('local', 'cart_cursor') >= 0
        BEGIN
            CLOSE cart_cursor;
            DEALLOCATE cart_cursor;
        END;
        IF CURSOR_STATUS('local', 'stock_cursor') >= 0
        BEGIN
            CLOSE stock_cursor;
            DEALLOCATE stock_cursor;
        END;

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
        SET @o_templateId = NULL;
    END CATCH;
END;
GO


-- EJEMPLO DE PRUEBA DE CHECKOUT SEGURO

DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

EXEC  [SQM_GENERAL].[sp_PaymentOrders_Create]
    @orderUserId = 1,                 
    @orderDeliveryAddress = 3,        
    @orderPaymentMethodId = 1,    
    @orderSubtotal = NULL,           
    @orderDiscount = NULL,            -- NULL para que lo calcule automáticamente
    @orderShipping = 50.00,           
    @orderTAX = NULL,                 -- NULL para que calcule IVA 15% automáticamente
    @orderTotal = NULL,               -- NULL para calcular Subtotal + Shipping automáticamente
    @orderCurrencyId = 1,             
    @orderCreatorId = 1,             
    @orderStatusId = 1,               
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

SELECT 
    @v_code AS [CodigoRespuesta],
    @v_message AS [MensajeRespuesta],
    @v_templateId AS [OrderIdGenerado];
GO






SELECT * FROM [SQM_SECURITY].[Tbl_Users];

-- 2. Tabla de Direcciones (Esquema GENERAL)
SELECT * FROM [SQM_GENERAL].[Tbl_UserAddress];

-- 3. Tabla de Métodos de Pago (Esquema GENERAL)
SELECT * FROM [SQM_GENERAL].[Tbl_UserPaymentMethods];

-- 4. Tabla de Monedas (Esquema CATALOGS)
SELECT * FROM [SQM_CATALOGS].[Tbl_Currencies];

-- 5. Tabla de Estados/Estatus (Esquema CATALOGS)
SELECT * FROM [SQM_CATALOGS].[Tbl_Status];


DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);
DECLARE @v_templateId INT;

-- 2. Ejecutar el procedimiento almacenado con los datos de la imagen
EXEC  [SQM_GENERAL].[sp_PaymentOrders_Create]
    @orderUserId = 1,                 -- HECTOR JOSE CALERO ALANIZ (userId = 1)
    @orderDeliveryAddress = 2,        -- Ciudad Sandino, Managua (userAddressId = 2)
    @orderPaymentMethodId = 1,        -- Método de pago del usuario (userPaymentMethodId = 1)
    @orderSubtotal = NULL,            -- NULL para que lo calcule automáticamente del carrito
    @orderDiscount = NULL,            -- NULL para que lo calcule automáticamente del carrito
    @orderShipping = 50.00,           -- se pues  definir un costo de envío fijo o bien le mentemos logica para la ditancia a esto vaina 
    @orderTAX = NULL,                 -- NULL para que lo calcule automáticamente del carrito
    @orderTotal = NULL,               -- NULL para que sume Subtotal + Shipping automáticamente
    @orderCurrencyId = 2,             -- Córdoba Oro (currencyId = 2)
    @orderCreatorId = 1,              -- Creador: HECTOR JOSE CALERO (userId = 1)
    @orderStatusId = 1,               -- Estado: ACTIVO (statusId = 1)
    
    -- Pasar los parámetros de salida
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT,
    @o_templateId = @v_templateId OUTPUT;

-- 3. Mostrar los resultados de la ejecución
SELECT 
    @v_code AS [CodigoRespuesta],
    @v_message AS [MensajeRespuesta],
    @v_templateId AS [OrderIdGenerado];
GO