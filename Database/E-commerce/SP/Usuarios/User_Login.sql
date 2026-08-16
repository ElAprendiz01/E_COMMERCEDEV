USE [DB_ECOMMERCE];
GO

CREATE or alter PROCEDURE [SQM_SECURITY].[sp_Users_Login]
    @userEmail VARCHAR(150),
    @userPasswordPlain VARCHAR(255),
    @o_code INT OUTPUT,
    @o_message VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- 1. Abrimos tu llave de seguridad (Vital para poder leer las contraseñas)
        OPEN SYMMETRIC KEY KEY_HASH DECRYPTION BY CERTIFICATE CERT_ECOMMERCE;

        -- Variables para guardar los datos si el usuario existe
        DECLARE @userId INT, @userFullName VARCHAR(255), @dbPasswordDecrypted VARCHAR(255);

        -- 2. Buscamos al usuario y desencriptamos su contraseña usando TU función
        SELECT 
            @userId = U.userId,
            @userFullName = U.userFullName,
            @dbPasswordDecrypted = SQM_SECURITY.Fn_DecryptByKey(U.userPassword) 
        FROM [SQM_SECURITY].[Tbl_Users] U (NOLOCK)
        INNER JOIN [SQM_CATALOGS].[Tbl_Status] S (NOLOCK) ON U.userStatusId = S.statusId
        WHERE U.userEmail = @userEmail
          AND S.statusName NOT IN ('INACTIVO', 'BLOQUEADO', 'ANULADO');

        -- 3. Cerramos la llave por seguridad
        CLOSE SYMMETRIC KEY KEY_HASH;

        -- 4. Validamos si el usuario existe y si la contraseña coincide
        IF @userId IS NOT NULL AND @dbPasswordDecrypted = @userPasswordPlain
        BEGIN
            -- ¡Login Exitoso!
            SET @o_code = 200; 
            SET @o_message = 'Login exitoso';

            -- Devolvemos los datos para que C# genere el Token JWT
            SELECT 
                @userId AS userId, 
                @userFullName AS userFullName, 
                @userEmail AS userEmail;
        END
        ELSE
        BEGIN
            -- Si falla la contraseña o el correo
            SET @o_code = 400; 
            SET @o_message = 'Correo o contraseña incorrectos, o usuario inactivo.';
        END

    END TRY
    BEGIN CATCH
        -- Si hay un error, nos aseguramos de cerrar la llave para que no se quede abierta
        IF EXISTS (SELECT * FROM sys.openkeys WHERE key_name = 'KEY_HASH')
            CLOSE SYMMETRIC KEY KEY_HASH;

        SET @o_code = 500; 
        SET @o_message = 'Error interno: ' + ERROR_MESSAGE();
    END CATCH
END
GO