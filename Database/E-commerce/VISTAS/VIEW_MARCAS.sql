USE [DB_ECOMMERCE]
GO

CREATE OR ALTER VIEW [SQM_CATALOGS].[vw_Marks_Detailed]
AS
SELECT 
    M.markId AS MarcaID,
    M.markName AS Marca,
    M.markDescription AS Descripcion,
    M.markCreatorId AS CreadorID,
    UC.userFullName AS CreadorNombre,
    M.markCreationDate AS FechaCreacion,
    M.markModificatorId AS ModificadorID,
    UM.userFullName AS ModificadorNombre,
    M.markModificationDate AS FechaModificacion,
    M.markStatusId AS EstadoID,
    CASE WHEN M.markStatusId = 1 THEN 'Activo' ELSE 'Inactivo' END AS Estado
FROM [SQM_CATALOGS].[Tbl_Marks] M
INNER JOIN [SQM_SECURITY].[Tbl_Users] UC 
    ON M.markCreatorId = UC.userId
LEFT JOIN [SQM_SECURITY].[Tbl_Users] UM 
    ON M.markModificatorId = UM.userId;
GO