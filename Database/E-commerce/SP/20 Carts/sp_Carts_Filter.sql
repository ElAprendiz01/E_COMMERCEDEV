USE [DB_ECOMMERCE]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_Carts_Filter]
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        d.cartDetailId               AS DetalleCarritoId,
        d.cartDetailCartId           AS CarritoId,
        c.cartUserId                 AS UsuarioClienteId,
        d.cartDetailProductVariableId AS VarianteId,
        p.productID                  AS ProductoId,
        p.productName                AS ProductoNombre,
        p.productDescription         AS ProductoDescripcion,
        pv.productVariableValue       AS VarianteEspecificacion,
        pi.productImageURL           AS ProductoImagenUrl,
        d.cartDetailPrice            AS PrecioUnitario,
        d.cartDetailQuantity         AS Cantidad,
        d.cartDetailDiscount         AS DescuentoFila,
        d.cartDetailSubTotal         AS SubTotalFila,
        d.cartDetailTAX              AS ImpuestoFila,
        d.cartDetailTotal            AS TotalFila,
        co.currencyISO               AS MonedaISO,
        co.currencyName              AS MonedaNombre
    FROM [SQM_GENERAL].[Tbl_Carts] c WITH (NOLOCK)
    INNER JOIN [SQM_GENERAL].[Tbl_CartDetails] d WITH (NOLOCK) ON c.cartId = d.cartDetailCartId
    INNER JOIN [SQM_GENERAL].[Tbl_ProductVariables] pv WITH (NOLOCK) ON d.cartDetailProductVariableId = pv.productVariableId
    INNER JOIN [SQM_GENERAL].[Tbl_Products] p WITH (NOLOCK) ON pv.productVariableProductId = p.productID
    LEFT JOIN [SQM_GENERAL].[Tbl_ProductImages] pi WITH (NOLOCK) ON p.productID = pi.productImageProductId AND pi.productImageIsPrincipal = 1
    LEFT JOIN [SQM_CATALOGS].[Tbl_Currencies] co WITH (NOLOCK) ON d.cartDetailCurrencyId = co.currencyId
    WHERE c.cartUserId = @UserId 
      AND c.cartStatusId = 1 
      AND d.cartDetailStatusId = 1; --  Excluye los detalles inactivados (cartDetailStatusId = 0)
END
GO

EXEC [SQM_GENERAL].[sp_Carts_Filter] @UserId = 1;