USE [DB_ECOMMERCE]
GO

-- 5. FILTRAR (Optimizado)
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[sp_Users_Filter]
    @SearchTerm VARCHAR(100) = NULL
AS
BEGIN
    DECLARE @SearchId INT = TRY_CAST(@SearchTerm AS INT);

    SELECT 
	    U.userId, 
        U.userFullName, 
        U.userPassword, 
        U.userName, 
        U.userEmail, 
        U.userPhoneNumber, 
        U.userBirthDay, 
        U.userStatusId
    FROM [SQM_SECURITY].[Tbl_Users] U (NOLOCK)
    -- Acoplamos la tabla de estados mediante INNER JOIN
    INNER JOIN [SQM_CATALOGS].[Tbl_Status] S (NOLOCK) 
        ON U.userStatusId = S.statusId
   WHERE (
        @SearchTerm IS NULL
        OR userId = @SearchId
        OR userFullName LIKE '%' + @SearchTerm + '%'
        OR userName LIKE '%' + @SearchTerm + '%'
        OR userEmail LIKE '%' + @SearchTerm + '%'
        OR userPhoneNumber LIKE '%' + @SearchTerm + '%'
    )
	AND S.statusName NOT IN ('INACTIVO', 'BLOQUEADO', 'ANULADO')
    OPTION (RECOMPILE);
END
GO
exec [SQM_SECURITY].[sp_Users_Filter] 'm'


select * from [SQM_SECURITY].[Tbl_Users]