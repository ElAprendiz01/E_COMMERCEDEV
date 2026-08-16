USE [DB_ECOMMERCE]
GO

CREATE OR ALTER VIEW [SQM_GENERAL].[v_ClientCartDetails_Complete]
AS
SELECT 
    -- IDs de Control (Claves para el backend)
    CD.cartDetailId AS DetalleCarritoId,
    C.cartId AS CarritoId,
    C.cartUserId AS UsuarioClienteId, --  Campo clave para filtrar por el cliente logueado este se tiene que hacer autoatico yan carlos para que lo agregues al cliente 
    PV.productVariableId AS VarianteId,
    P.productId AS ProductoId,

    -- Información Visual del Producto
    P.productName AS ProductoNombre,
    P.productDescription AS ProductoDescripcion,
    PV.productVariableValue AS VarianteEspecificacion, 
    
    -- Imagen Principal del Producto (Para mostrar la miniatura en el carrito)
    (
        SELECT TOP 1 PI.productImageURL 
        FROM [SQM_GENERAL].[Tbl_ProductImages] PI 
        WHERE PI.productImageProductId = P.productId 
          AND PI.productImageIsPrincipal = 1 
          AND PI.productImageStatusId = 1
    ) AS ProductoImagenUrl,

    -- Precios y Totales del Ítem
    CD.cartDetailPrice AS PrecioUnitario,
    CD.cartDetailQuantity AS Cantidad,
    CD.cartDetailDiscount AS DescuentoFila,
    CD.cartDetailSubTotal AS SubTotalFila,
    CD.cartDetailTAX AS ImpuestoFila,
    CD.cartDetailTotal AS TotalFila,
    
    -- Moneda
    CURR.currencyISO AS MonedaISO,
    CURR.currencyDescription AS MonedaNombre,

    -- Estado del ítem en el carrito (Para asegurar que solo listemos ítems activos)
    CD.cartDetailStatusId AS DetalleActivo

FROM [SQM_GENERAL].[Tbl_CartDetails] CD
-- Unión con la cabecera del carrito
INNER JOIN [SQM_GENERAL].[Tbl_Carts] C 
    ON CD.cartDetailCartId = C.cartId AND C.cartStatusId = 1
-- Unión con las variantes del producto
LEFT JOIN [SQM_GENERAL].[Tbl_ProductVariables] PV 
    ON CD.cartDetailProductVariableId = PV.productVariableId
-- Unión con el producto base
LEFT JOIN [SQM_GENERAL].[Tbl_Products] P 
    ON PV.productVariableProductId = P.productId
-- Moneda asociada al detalle del carrito
LEFT JOIN [SQM_CATALOGS].[Tbl_Currencies] CURR 
    ON CD.cartDetailCurrencyId = CURR.currencyId;
GO

select * from [SQM_GENERAL].[v_ClientCartDetails_Complete]