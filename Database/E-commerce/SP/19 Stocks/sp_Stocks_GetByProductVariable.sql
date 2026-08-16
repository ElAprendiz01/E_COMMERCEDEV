USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[sp_AttributeProductVariables_GetByProductVariable]
(
    @ProductVariableId INT = NULL,
    @SearchTerm VARCHAR(100) = NULL
)
AS 
BEGIN
    SET NOCOUNT ON;

    DECLARE @TerminoBusqueda VARCHAR(102) = NULL;
    IF @SearchTerm IS NOT NULL AND RTRIM(LTRIM(@SearchTerm)) <> ''
    BEGIN
        SET @TerminoBusqueda = '%' + RTRIM(LTRIM(@SearchTerm)) + '%';
    END

    SELECT 
        IdAtributoVariable,
        ValorAtributo,
        RegistroActivo,
        IdTipoVariable,
        TipoVariable,
        DescripcionTipoVariable,
        IdVariante,
        ValorVariante,
        PrecioVariante,
        CodigoMoneda,
        NombreMoneda,
        IdProducto,
        NombreProducto,
        DescripcionProducto,
        NombreMarca,
        NombreProveedor,
        FechaCreacion,
        CreadoPor,
        FechaModificacion,
        ModificadoPor
    FROM [SQM_GENERAL].[Vw_AttributeProductVariablesDetails] (NOLOCK)
    WHERE 
        (@ProductVariableId IS NULL OR IdVariante = @ProductVariableId)
        AND RegistroActivo = 1
        AND (
            @TerminoBusqueda IS NULL 
            OR NombreProducto LIKE @TerminoBusqueda
            OR DescripcionProducto LIKE @TerminoBusqueda
            OR NombreMarca LIKE @TerminoBusqueda
            OR NombreProveedor LIKE @TerminoBusqueda
            OR TipoVariable LIKE @TerminoBusqueda
            OR ValorAtributo LIKE @TerminoBusqueda
            OR ValorVariante LIKE @TerminoBusqueda
        );
END
GO



exec [SQM_GENERAL].[sp_AttributeProductVariables_GetByProductVariable] 


exec [SQM_GENERAL].[sp_AttributeProductVariables_GetByProductVariable] @SearchTerm = 'a'