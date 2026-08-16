


USE [DB_ECOMMERCE]
GO

CREATE OR ALTER VIEW [SQM_CATALOGS].[vw_Currencies_Detailed]
AS
SELECT 
    C.currencyId AS [MonedaID],
    C.currencyName AS [Moneda],
    C.currencyISO AS [ISO],
    C.currencyCode AS [CodigoNumerico],
    C.currencyDescription AS [Descripcion],
    C.currencyCreatorId AS [CreadorID],
    UC.userFullName AS [CreadorNombre],
    C.currencyCreationDate AS [FechaCreacion],
    C.currencyModificatorId AS [ModificadorID],
    UM.userFullName AS [ModificadorNombre],
    C.currencyModificationDate AS [FechaModificacion],
    C.currencyStatusId AS [EstadoID],
    CASE WHEN C.currencyStatusId = 1 THEN 'Activo' ELSE 'Inactivo' END AS [Estado]
FROM [SQM_CATALOGS].[Tbl_Currencies] C
INNER JOIN [SQM_SECURITY].[Tbl_Users] UC 
    ON C.currencyCreatorId = UC.userId
LEFT JOIN [SQM_SECURITY].[Tbl_Users] UM 
    ON C.currencyModificatorId = UM.userId;
GO

select * from [SQM_CATALOGS].[vw_Currencies_Detailed]