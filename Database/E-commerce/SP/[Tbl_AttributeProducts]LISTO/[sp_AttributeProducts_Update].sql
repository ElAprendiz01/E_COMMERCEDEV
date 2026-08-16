USE DB_ECOMMERCE;
GO

CREATE OR ALTER PROCEDURE SQM_CATALOGS.sp_AttributeProducts_Update
(
    @AttributeProductId INT,
    @AttributeProductAttributesTypeId INT,
    @AttributeProductName NVARCHAR(100),
    @AttributeProductDescription NVARCHAR(400) = NULL,
    @AttributeProductModificatorId INT,
    @AttributeProductStatusId INT,
    @o_code INT = NULL OUTPUT,
    @o_message NVARCHAR(400) = NULL OUTPUT,
    @o_templateId INT = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM SQM_CATALOGS.Tbl_AttributeProducts
            WHERE AttributeProductId = @AttributeProductId
        )
        BEGIN
            SET @o_code = 404;
            SET @o_message = N'Registro no encontrado.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Normaliza entradas
        SET @AttributeProductName = LTRIM(RTRIM(ISNULL(@AttributeProductName, N'')));
        SET @AttributeProductDescription = LTRIM(RTRIM(ISNULL(@AttributeProductDescription, N'')));

        -- Valida datos
        IF LEN(@AttributeProductName) = 0
        BEGIN
            SET @o_code = 400;
            SET @o_message = N'El nombre no puede estar vacío.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Evita duplicados por nombre y tipo
        IF EXISTS (
            SELECT 1
            FROM SQM_CATALOGS.Tbl_AttributeProducts
            WHERE AttributeProductName = @AttributeProductName
              AND AttributeProductAttributesTypeId = @AttributeProductAttributesTypeId
              AND AttributeProductId <> @AttributeProductId
        )
        BEGIN
            SET @o_code = 409;
            SET @o_message = N'Ya existe un registro con el mismo nombre y tipo.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Actualizar registro
        UPDATE SQM_CATALOGS.Tbl_AttributeProducts
        SET
            AttributeProductAttributesTypeId = @AttributeProductAttributesTypeId,
            AttributeProductName = @AttributeProductName,
            AttributeProductDescription = @AttributeProductDescription,
            AttributeProductModificatorId = @AttributeProductModificatorId,
            AttributeProductModificationDate = GETDATE(),
            AttributeProductStatusId = @AttributeProductStatusId
        WHERE AttributeProductId = @AttributeProductId;

        COMMIT TRANSACTION;

        SET @o_code = 200;
        SET @o_message = N'Registro actualizado exitosamente.';
        SET @o_templateId = @AttributeProductId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @o_code = ERROR_NUMBER();
        SET @o_message = ERROR_MESSAGE();
    END CATCH
END;
GO
