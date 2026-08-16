USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Currencies_List]
AS BEGIN
    SET NOCOUNT ON;

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
    FROM [SQM_CATALOGS].[vw_Currencies_Detailed] (NOLOCK);
END;
GO

EXEC [SQM_CATALOGS].[sp_Currencies_List];
GO