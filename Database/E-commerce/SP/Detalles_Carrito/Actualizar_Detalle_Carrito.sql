USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_CartDetails_UpdateQuantity]
(
    @cartDetailId INT,                  -- ID específico de la línea del carrito que queremos editar
    @newQuantity INT,                   -- La NUEVA cantidad absoluta que desea el usuario (ej: 5)
    @modificatorId INT,                 -- ID del usuario que hace el cambio este logicamente en el clinte se hace automatico con el id de usario que se registro 
    @o_code INT = NULL OUTPUT,          -- Código de respuesta (200 = OK, -1 = Error)
    @o_message VARCHAR(255) = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    
    -- 1. VALIDACIONES DE ENTRADA (Tipos de datos y rangos)
    
    IF @cartDetailId IS NULL OR @cartDetailId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del detalle de carrito (@cartDetailId) debe ser un número entero mayor a cero.';
        RETURN;
    END;

    IF @newQuantity IS NULL OR @newQuantity <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La nueva cantidad (@newQuantity) debe ser un número entero mayor a cero. Si desea eliminarlo, use el SP de eliminación.';
        RETURN;
    END;

    IF @modificatorId IS NULL OR @modificatorId <= 0
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El ID del modificador (@modificatorId) es obligatorio y debe ser un número válido.';
        RETURN;
    END;

    
    -- 2. VALIDAR EXISTENCIA DEL REGISTRO EN EL CARRITO
    
    DECLARE @ProductVariableId INT;
    DECLARE @CartId INT;

    SELECT 
        @ProductVariableId = cartDetailProductVariableId,
        @CartId = cartDetailCartId
    FROM [SQM_GENERAL].[Tbl_CartDetails]
    WHERE cartDetailId = @cartDetailId AND cartDetailStatusId = 1;

    IF @ProductVariableId IS NULL
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El detalle de carrito especificado no existe o ya no se encuentra activo.';
        RETURN;
    END;

    -- Validar que el usuario modificador exista y esté activo
    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @modificatorId AND userStatusId = 1)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario que intenta modificar no existe o está inactivo.';
        RETURN;
    END;

    
    -- 3. VALIDACIÓN DE INVENTARIO (STOCK DISPONIBLE)
    
    DECLARE @AvailableStock INT = 0;
    SELECT @AvailableStock = COALESCE(SUM(stockQuantity), 0)
    FROM [SQM_GENERAL].[Tbl_Stocks]
    WHERE stockProductVariableId = @ProductVariableId 
      AND stockStatusId = 1 
      AND stockExpirationDate >= CAST(GETDATE() AS DATE);

    IF @AvailableStock < @newQuantity
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'Stock insuficiente para cambiar a la cantidad solicitada. Stock disponible: ' + CAST(@AvailableStock AS VARCHAR(10));
        RETURN;
    END;

    
    -- 4. OBTENER EL PRECIO ORIGINAL Y REALIZAR CÁLCULOS MATEMÁTICOS
    
    DECLARE @ProductPrice DECIMAL(18,2);
    DECLARE @Discount DECIMAL(18,2) = 0.00; -- aqui dejamos la aprte de los cupones por cualquier cosa no eat habilitado pero  si puede ser funcionala 
    DECLARE @CalculatedSubTotal DECIMAL(18,2);
    DECLARE @CalculatedTAX DECIMAL(18,2);
    DECLARE @CalculatedTotal DECIMAL(18,2);
    DECLARE @TaxRate DECIMAL(5,2) = 0.15;  -- Ejemplo: IVA del 15%  creo que ese es en nuestro pais 

    -- Jalamos el precio unitario directamente de la fila actual (o driamos  jalarlo de la tabla de productos)
    SELECT @ProductPrice = cartDetailPrice 
    FROM [SQM_GENERAL].[Tbl_CartDetails] 
    WHERE cartDetailId = @cartDetailId;

    -- Operaciones Matemáticas Autónomas para no estar metiendo los fatos manualmnete 
    SET @CalculatedSubTotal = (@ProductPrice * @newQuantity);
    SET @CalculatedTAX      = (@CalculatedSubTotal * @TaxRate);
    SET @CalculatedTotal    = (@CalculatedSubTotal + @CalculatedTAX) - @Discount;

    
    -- 5. ACTUALIZACIÓN PROTEGIDA CON TRANSACCIÓN
    
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [SQM_GENERAL].[Tbl_CartDetails]
        SET cartDetailQuantity = @newQuantity,
            cartDetailSubTotal = @CalculatedSubTotal,
            cartDetailTAX      = @CalculatedTAX,
            cartDetailTotal    = @CalculatedTotal,
            cartDetailModificatorId = @modificatorId,
            cartDetailModificationDate = GETDATE()
        WHERE cartDetailId = @cartDetailId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Cantidad y cálculos del carrito actualizados dinámicamente con éxito.';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
    END CATCH;
END;
GO

-- Declaración y ejecución de ejemplo para pruebas

DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);

EXEC [SQM_GENERAL].[sp_CartDetails_UpdateQuantity]
    @cartDetailId = 1, -- Asegúrese de usar un ID existente en Tbl_CartDetails
    @newQuantity = 5,
    @modificatorId = 1,
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado;



select * from [SQM_GENERAL].[Tbl_CartDetails]

