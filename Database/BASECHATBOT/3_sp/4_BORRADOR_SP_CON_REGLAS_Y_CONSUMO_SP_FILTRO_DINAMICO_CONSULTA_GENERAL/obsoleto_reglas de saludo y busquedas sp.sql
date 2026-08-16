USE [DB_EcommerceAgent]
GO

------------------------------------------------------------
-- 1. Insertar la regla "No Entendido" si no existe
------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM ReglasChatbot WHERE NombreRegla = 'No Entendido')
BEGIN
    INSERT INTO ReglasChatbot (NombreRegla, AccionDinamica, AccionPython, Activo)
    VALUES ('No Entendido', 0, NULL, 1);

    DECLARE @NewReglaID INT = SCOPE_IDENTITY();

    INSERT INTO PlantillasRespuesta (ReglaID, TextoRespuesta, Activo)
    VALUES (@NewReglaID, 
    'Lo siento, no entendí tu petición. ¿Podrías ser más específico? Aquí tienes algunas opciones: buscar producto, ver categorías, consultar stock.', 1);
END
GO

------------------------------------------------------------
-- 2. SP del agente que usa el SP de productos
------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.SP_AgenteRespuestaProductos
    @TextoUsuario VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ReglaID INT;

    -- Buscar regla por palabra clave
    SELECT TOP 1 @ReglaID = R.ReglaID
    FROM PalabrasClaveRegla PK
    INNER JOIN ReglasChatbot R ON PK.ReglaID = R.ReglaID
    WHERE @TextoUsuario LIKE '%' + PK.PalabraClave + '%'
      AND PK.Activo = 1
      AND R.Activo = 1;

    -- Si no encontró regla, usar la de "No Entendido"
    IF @ReglaID IS NULL
        SELECT TOP 1 @ReglaID = ReglaID
        FROM ReglasChatbot
       -- WHERE NombreRegla = 'No Entendido' AND Activo = 1;

    -- 1. Siempre devolver la respuesta del agente
    SELECT TOP 1 TextoRespuesta AS RespuestaAgente
    FROM PlantillasRespuesta
    --WHERE ReglaID = @ReglaID AND Activo = 1
    ORDER BY NEWID();

    -- 2. Si la regla es "Buscar Producto", llamar al SP de filtro
    IF EXISTS (SELECT 1 FROM ReglasChatbot WHERE ReglaID = @ReglaID AND NombreRegla = 'Buscar Producto')
    BEGIN
        EXEC dbo.SP_ListarGeneralProducts_Filtro @01_FilterText = @TextoUsuario;
    END
END
GO

/**/

USE [DB_EcommerceAgent]
GO

USE [DB_EcommerceAgent]
GO

CREATE OR ALTER PROCEDURE dbo.SP_AgenteRespuestaProductos
    @TextoUsuario VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ReglaID INT;

    -- Buscar regla por palabra clave
    SELECT TOP 1 @ReglaID = R.ReglaID
    FROM PalabrasClaveRegla PK
    INNER JOIN ReglasChatbot R ON PK.ReglaID = R.ReglaID
    WHERE @TextoUsuario LIKE '%' + PK.PalabraClave + '%'
      AND PK.Activo = 1
      AND R.Activo = 1;

    -- Si no encontró regla, asumimos "Buscar Producto" para intentar búsqueda
    IF @ReglaID IS NULL
        SELECT TOP 1 @ReglaID = ReglaID
        FROM ReglasChatbot
        WHERE NombreRegla = 'Buscar Producto' AND Activo = 1;

    -- 1. Obtener respuesta de la regla
    SELECT TOP 1 TextoRespuesta AS RespuestaAgente
    FROM PlantillasRespuesta
    WHERE ReglaID = @ReglaID AND Activo = 1
    ORDER BY NEWID();

    -- 2. Intentar búsqueda de productos
    EXEC dbo.SP_ListarGeneralProducts_Filtro @01_FilterText = @TextoUsuario;

    -- 3. Si no devuelve nada, usar "No Entendido"
    IF NOT EXISTS (
        SELECT 1
        FROM DB_ECOMMERCE.SQM_GENERAL.VW_GENERAL_PRODUCTS
        WHERE ProductName LIKE '%' + @TextoUsuario + '%'
           OR CategoryName LIKE '%' + @TextoUsuario + '%'
           OR ProviderName LIKE '%' + @TextoUsuario + '%'
           OR MarkName LIKE '%' + @TextoUsuario + '%'
    )
    BEGIN
        SELECT TOP 1 TextoRespuesta AS RespuestaAgente
USE [DB_EcommerceAgent]
GO

CREATE OR ALTER PROCEDURE dbo.SP_AgenteRespuestaProductos
    @TextoUsuario VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ReglaID INT;
    DECLARE @HayProductos BIT = 0;

    -- Buscar regla por palabra clave
    SELECT TOP 1 @ReglaID = R.ReglaID
    FROM dbo.PalabrasClaveRegla PK
    INNER JOIN ReglasChatbot R ON PK.ReglaID = R.ReglaID
    WHERE @TextoUsuario LIKE '%' + PK.PalabraClave + '%'
      AND PK.Activo = 1
      AND R.Activo = 1;

    -- Si no encontró regla, asumimos "Buscar Producto"
    IF @ReglaID IS NULL
        SELECT TOP 1 @ReglaID = ReglaID
        FROM ReglasChatbot
        WHERE NombreRegla = 'Buscar Producto' AND Activo = 1;

    -- 1. Obtener respuesta del agente
    SELECT TOP 1 TextoRespuesta AS RespuestaAgente
    FROM PlantillasRespuesta
    WHERE ReglaID = @ReglaID AND Activo = 1
    ORDER BY NEWID();

    -- 2. Ejecutar búsqueda de productos y marcar si hay resultados
    DECLARE @Tabla TABLE (
        ProductID INT,
        ProductName VARCHAR(200),
        ProductVariableID INT,
        ProductVariableName VARCHAR(200),
        ProductVariablePrice DECIMAL(18,2),
        CurrencyID INT,
        CurrencyISO VARCHAR(10),
        CategoryID INT,
        CategoryName VARCHAR(200),
        SubcategoryID INT,
        SubcategoryName VARCHAR(200),
        SegmentID INT,
        SegmentName VARCHAR(200),
        MarkID INT,
        MarkName VARCHAR(200),
        ProviderID INT,
        ProviderName VARCHAR(200),
        StockID INT,
        StockAvilable INT,
        StockFactoryDate DATETIME,
        StockExpirationDate DATETIME
    );

    INSERT INTO @Tabla
    EXEC dbo.SP_ListarGeneralProducts_Filtro @01_FilterText = @TextoUsuario;

    IF EXISTS (SELECT 1 FROM @Tabla)
        SET @HayProductos = 1;

    SELECT * FROM @Tabla;

    -- 3. Si no hay productos, devolver "No Entendido"
    IF @HayProductos = 0
    BEGIN
        SELECT TOP 1 TextoRespuesta AS RespuestaAgente
        FROM PlantillasRespuesta
        WHERE ReglaID = (SELECT ReglaID FROM ReglasChatbot WHERE NombreRegla = 'No Entendido' AND Activo = 1)
          AND Activo = 1
        ORDER BY NEWID();
    END
END
GO




-- Caso genérico
EXEC dbo.SP_AgenteRespuestaProductos @TextoUsuario = 'producto';

-- Caso específico (filtra correctamente)
EXEC dbo.SP_AgenteRespuestaProductos @TextoUsuario = 'Dell';
EXEC dbo.SP_AgenteRespuestaProductos @TextoUsuario = 'NIKE';

-- Caso no entendido (no existe en la vista)
EXEC dbo.SP_AgenteRespuestaProductos @TextoUsuario = 'asdfgh';


