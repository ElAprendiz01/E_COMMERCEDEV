USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_SECURITY].[sp_Users_ChangePassword]
(
    @userId INT,
    @userModificatorId INT,
    @userPasswordPlain VARCHAR(256),
    @o_code INT = NULL OUTPUT,
    @o_message VARCHAR(255) = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @userId)
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'El usuario no existe.';
        RETURN;
    END;

    IF @userPasswordPlain IS NULL OR LTRIM(RTRIM(@userPasswordPlain)) = ''
    BEGIN
        SET @o_code = -1;
        SET @o_message = 'La nueva contraseña no puede estar vacía.';
        RETURN;
    END;

    DECLARE @UserPasswordEncrypted VARBINARY(256);

    BEGIN TRY
        BEGIN TRANSACTION;

        OPEN SYMMETRIC KEY KEY_HASH DECRYPTION BY CERTIFICATE CERT_ECOMMERCE;
        SET @UserPasswordEncrypted = SQM_SECURITY.Fn_EncryptByKey(@userPasswordPlain);
        CLOSE SYMMETRIC KEY KEY_HASH;

        UPDATE [SQM_SECURITY].[Tbl_Users]
        SET userPassword = @UserPasswordEncrypted,
            userModificatorId = @userModificatorId,
            userModificationDate = GETDATE()
        WHERE userId = @userId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = 'Contraseña actualizada con éxito.';
    END TRY
    BEGIN CATCH
        IF EXISTS (SELECT 1 FROM sys.openkeys WHERE key_name = 'KEY_HASH') CLOSE SYMMETRIC KEY KEY_HASH;
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
    END CATCH;
END;
GO


DECLARE @v_code INT;
DECLARE @v_message VARCHAR(255);

EXEC [SQM_SECURITY].[sp_Users_ChangePassword]
    @userId = 1,
    @userModificatorId = 1,
    @userPasswordPlain = 'perofiel',
    @o_code = @v_code OUTPUT,
    @o_message = @v_message OUTPUT;

SELECT 
    @v_code AS CodigoResultado, 
    @v_message AS MensajeResultado;

	select * from  [SQM_SECURITY].[Tbl_Users]
 