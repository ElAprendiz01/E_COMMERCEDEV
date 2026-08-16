USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Currencies_Filter]
    @SearchTerm VARCHAR(50) = NULL, 
    @StatusId BIT = NULL
AS BEGIN
    SET NOCOUNT ON;

    DECLARE @SearchId INT = TRY_CAST(@SearchTerm AS INT);

    SELECT 
        MonedaID, 
        Moneda, 
        ISO, 
        CodigoNumerico, 
        Descripcion, 
        CreadorID, 
        CreadorNombre, 
        FechaCreacion, 
        ModificadorID, 
        ModificadorNombre, 
        FechaModificacion, 
        EstadoID, 
        Estado
    FROM [SQM_CATALOGS].[vw_Currencies_Detailed] (NOLOCK)
    WHERE (
        @SearchTerm IS NULL
        OR MonedaID = @SearchId
        OR Moneda LIKE '%' + @SearchTerm + '%'
        OR ISO LIKE '%' + @SearchTerm + '%'
        OR CodigoNumerico LIKE '%' + @SearchTerm + '%'
    ) AND (@StatusId IS NULL OR EstadoID = @StatusId)
    OPTION (RECOMPILE);
END;
GO

-- Pruebas de ejecución
EXEC [SQM_CATALOGS].[sp_Currencies_Filter];
EXEC [SQM_CATALOGS].[sp_Currencies_Filter] 'nio';
GO