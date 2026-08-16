USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Marks_List]
AS BEGIN
    SET NOCOUNT ON;

    SELECT 
        MarcaID,
        Marca,
        Descripcion,
        CreadorID,
        CreadorNombre,
        FechaCreacion,
        ModificadorID,
        ModificadorNombre,
        FechaModificacion,
        EstadoID,
        Estado
    FROM [SQM_CATALOGS].[vw_Marks_Detailed] (NOLOCK)
    WHERE EstadoID = 1;
END;
GO

EXEC [SQM_CATALOGS].[sp_Marks_List];
GO