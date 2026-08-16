USE [DB_ECOMMERCE]
GO

-- 4. LISTAR
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[sp_Users_List]
AS
BEGIN
    OPEN SYMMETRIC KEY KEY_HASH DECRYPTION BY CERTIFICATE CERT_ECOMMERCE;
    
  SELECT
        U.userId, 
        U.userFullName, 
        U.userName, 
        SQM_SECURITY.Fn_DecryptByKey(U.userPassword) AS [userPasswordDecrypted], 
        U.userEmail, 
        U.userPhoneNumber, 
        U.userCountryId, 
        U.userGenderId, 
        U.userBirthDay, 
        U.userStatusId
    FROM [SQM_SECURITY].[Tbl_Users] U (NOLOCK)
	INNER JOIN [SQM_CATALOGS].[Tbl_Status] S (NOLOCK) 
        ON U.userStatusId = S.statusId -- Relación de la llave foránea
    WHERE 
        S.statusName NOT IN ('INACTIVO', 'BLOQUEADO', 'ANULADO')
	
    
    CLOSE SYMMETRIC KEY KEY_HASH;
END
GO



OPEN MASTER KEY
DECRYPTION BY PASSWORD = 'Ecommerce2026!';

ALTER MASTER KEY
DROP ENCRYPTION BY SERVICE MASTER KEY;

ALTER MASTER KEY
ADD ENCRYPTION BY SERVICE MASTER KEY;

exec  [SQM_SECURITY].[sp_Users_List]

select * from [SQM_CATALOGS].[Tbl_Status]
select * from [SQM_SECURITY].[Tbl_Users]


EXEC [SQM_GENERAL].[sp_GetClientCart] @UserId = 1;

