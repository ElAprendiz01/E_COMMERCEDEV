USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[sp_Marks_Filter]
    @SearchTerm VARCHAR(50) = NULL
AS BEGIN
    SET NOCOUNT ON;

    DECLARE @SearchId INT = TRY_CAST(@SearchTerm AS INT);

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
    WHERE (
        @SearchTerm IS NULL
        OR MarcaID = @SearchId
        OR Marca LIKE '%' + @SearchTerm + '%'
        OR Descripcion LIKE '%' + @SearchTerm + '%'
        OR CreadorNombre LIKE '%' + @SearchTerm + '%'      
        OR ModificadorNombre LIKE '%' + @SearchTerm + '%'  
    ) 
    OPTION (RECOMPILE);
END;
GO

-- Prueba de ejecución (Trae todo)
EXEC [SQM_CATALOGS].[sp_Marks_Filter];
GO


EXEC [SQM_CATALOGS].[sp_Marks_Filter] 'DELL'
GO