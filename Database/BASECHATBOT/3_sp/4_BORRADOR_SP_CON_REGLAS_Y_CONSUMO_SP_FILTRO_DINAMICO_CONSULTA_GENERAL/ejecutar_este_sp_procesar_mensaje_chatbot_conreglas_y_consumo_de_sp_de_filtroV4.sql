USE [DB_EcommerceAgent];
GO

CREATE OR ALTER PROCEDURE dbo.SP_ProcesarMensajeChatbot
    @w_ConversacionID VARCHAR(50),
    @w_TextoUsuario VARCHAR(1000),
    @o_TextoRespuesta NVARCHAR(MAX) OUTPUT,
    @o_ReglaActivadaID INT OUTPUT,
    @w_UsuarioID VARCHAR(50) = '1'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @v_ConvIDInt INT = TRY_CAST(@w_ConversacionID AS INT);

    -- -------------------------------------------------------------------------
    -- 1. REGISTRAR O RECUPERAR LA CONVERSACIÓN Y EL MENSAJE ENTRANTE DEL USUARIO
    -- -------------------------------------------------------------------------
    IF @v_ConvIDInt IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.HistorialConversaciones WHERE ConversacionID = @v_ConvIDInt)
    BEGIN
        INSERT INTO dbo.HistorialConversaciones (UsuarioID, FechaInicio, Activo)
        VALUES (ISNULL(@w_UsuarioID, '1'), GETDATE(), 1);
        
        SET @v_ConvIDInt = SCOPE_IDENTITY();
    END
    ELSE IF @v_ConvIDInt IS NULL
    BEGIN
        INSERT INTO dbo.HistorialConversaciones (UsuarioID, FechaInicio, Activo)
        VALUES (ISNULL(@w_UsuarioID, '1'), GETDATE(), 1);
        
        SET @v_ConvIDInt = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        IF @w_UsuarioID IS NOT NULL AND @w_UsuarioID <> '1'
        BEGIN
            UPDATE dbo.HistorialConversaciones 
            SET UsuarioID = @w_UsuarioID 
            WHERE ConversacionID = @v_ConvIDInt AND (UsuarioID = '1' OR UsuarioID IS NULL);
        END
    END

    -- Registrar el mensaje del usuario (ChatBot = 0 para usuario)
    INSERT INTO dbo.HistorialMensajes (ConversacionID, ChatBot, Texto, FechaHora, ReglaActivadaID)
    VALUES (@v_ConvIDInt, 0, @w_TextoUsuario, GETDATE(), NULL);

    -- Obtener UsuarioID numérico asociado a la conversación (default 1)
    DECLARE @v_UserId INT = 1;
    SELECT @v_UserId = COALESCE(TRY_CAST(UsuarioID AS INT), TRY_CAST(@w_UsuarioID AS INT), 1)
    FROM dbo.HistorialConversaciones
    WHERE ConversacionID = @v_ConvIDInt;

    IF @v_UserId IS NULL OR @v_UserId <= 0
    BEGIN
        SET @v_UserId = TRY_CAST(@w_UsuarioID AS INT);
        IF @v_UserId IS NULL OR @v_UserId <= 0 SET @v_UserId = 1;
    END

    DECLARE @v_ReglaID INT = NULL;
    DECLARE @v_PlantillaTexto NVARCHAR(MAX) = '';
    DECLARE @v_FiltroTexto VARCHAR(100) = NULL;
    DECLARE @v_EsBusquedaPorDescarte BIT = 0;
    DECLARE @w_TextoLower VARCHAR(1000) = LOWER(TRIM(@w_TextoUsuario));

    -- -------------------------------------------------------------------------
    -- 2. EVALUAR SI EL TEXTO CONTIENE UN TRIGGER DE PALABRA CLAVE
    -- -------------------------------------------------------------------------
    SELECT TOP 1 
        @v_ReglaID = ReglaID
    FROM PalabrasClaveRegla
    WHERE Activo = 1
      AND CHARINDEX(LOWER(PalabraClave), @w_TextoLower) > 0
    ORDER BY LEN(PalabraClave) DESC; -- Preferir coincidencias de frases más largas primero

    -- -------------------------------------------------------------------------
    -- 3. INVERSIÓN DE LA REGLA: Si no coincide con ningún trigger fijo, se asume Buscar Producto (Regla 2)
    -- -------------------------------------------------------------------------
    IF @v_ReglaID IS NULL
    BEGIN
        SET @v_ReglaID = 2; 
        SET @v_EsBusquedaPorDescarte = 1;
    END

    SET @v_FiltroTexto = TRIM(@w_TextoUsuario);
    SET @o_ReglaActivadaID = @v_ReglaID;

    -- -------------------------------------------------------------------------
    -- 4. HELPER EXTRAER NÚMEROS DEL TEXTO (Cantidad / IDs de Producto)
    -- -------------------------------------------------------------------------
    DECLARE @v_FirstNum INT = NULL;
    DECLARE @v_SecondNum INT = NULL;

    DECLARE @v_TextClean VARCHAR(1000) = TRIM(@w_TextoUsuario);
    WHILE CHARINDEX('  ', @v_TextClean) > 0
        SET @v_TextClean = REPLACE(@v_TextClean, '  ', ' ');

    SET @v_TextClean = @v_TextClean + ' '; -- Espacio final de seguridad
    DECLARE @v_Pos INT = 1;
    DECLARE @v_CurrentNum VARCHAR(50) = '';

    WHILE @v_Pos <= DATALENGTH(@v_TextClean)
    BEGIN
        IF SUBSTRING(@v_TextClean, @v_Pos, 1) LIKE '[0-9]'
        BEGIN
            SET @v_CurrentNum = @v_CurrentNum + SUBSTRING(@v_TextClean, @v_Pos, 1);
        END
        ELSE
        BEGIN
            IF LEN(@v_CurrentNum) > 0
            BEGIN
                IF @v_FirstNum IS NULL
                    SET @v_FirstNum = TRY_CAST(@v_CurrentNum AS INT);
                ELSE IF @v_SecondNum IS NULL
                    SET @v_SecondNum = TRY_CAST(@v_CurrentNum AS INT);
                
                SET @v_CurrentNum = '';
            END
        END
        SET @v_Pos = @v_Pos + 1;
    END;

    -- -------------------------------------------------------------------------
    -- 5. CONTROL DE FLUJO SEGÚN LA REGLA ACTIVADA
    -- -------------------------------------------------------------------------

    -- REGLA 1: SALUDO INICIAL
    IF @v_ReglaID = 1
    BEGIN
        SELECT TOP 1 @v_PlantillaTexto = TextoRespuesta FROM PlantillasRespuesta WHERE ReglaID = 1 AND Activo = 1 ORDER BY NEWID();
        SET @o_TextoRespuesta = ISNULL(@v_PlantillaTexto, 'Hola. Qué gusto tenerte por aquí. ¿En qué te puedo asistir hoy?');
    END

    -- REGLA 2: BUSCAR PRODUCTO
    ELSE IF @v_ReglaID = 2
    BEGIN
        DECLARE @CoincidenceScore TABLE (
            ProductID INT, ProductName VARCHAR(50), ProductVariableID INT, ProductVariableName VARCHAR(50),
            ProductVariablePrice DECIMAL(18,2), CurrencyID INT, CurrencyISO CHAR(5), CategoryID INT,
            CategoryName VARCHAR(50), SubcategoryID INT, SubcategoryName VARCHAR(50), SegmentID INT,
            SegmentName VARCHAR(50), MarkID INT, MarkName VARCHAR(50), ProviderID INT,
            ProviderName VARCHAR(50), StockID INT, StockAvilable INT, StockFactoryDate DATE, StockExpirationDate DATE,
            ProductImageURL VARCHAR(MAX),
            CoincidenceScore INT
        );

        INSERT INTO @CoincidenceScore
        EXEC dbo.SP_ListarGeneralProducts_Filtro @01_FilterText = @v_FiltroTexto;

        IF EXISTS (SELECT 1 FROM @CoincidenceScore WHERE StockAvilable > 0)
        BEGIN
            SELECT TOP 1 @v_PlantillaTexto = TextoRespuesta FROM PlantillasRespuesta WHERE ReglaID = 2 AND Activo = 1 ORDER BY NEWID();

            DECLARE @v_ListaFormateada NVARCHAR(MAX) = '';
            SELECT @v_ListaFormateada = @v_ListaFormateada + 
                CHAR(13) + CHAR(10) + '- [ID: ' + CAST(ProductVariableID AS VARCHAR) + '] ' + ProductName + ' (' + ProductVariableName + ') | Precio: ' + 
                CurrencyISO + ' ' + CAST(ProductVariablePrice AS VARCHAR) + ' | Stock: ' + CAST(StockAvilable AS VARCHAR)
            FROM @CoincidenceScore
            WHERE StockAvilable > 0;

            IF @v_PlantillaTexto IS NULL OR @v_PlantillaTexto = ''
                SET @v_PlantillaTexto = 'Excelente. Consulté el inventario al instante y encontré estas opciones para ti:' + CHAR(13) + CHAR(10) + '[@TABLA]';

            SET @o_TextoRespuesta = REPLACE(@v_PlantillaTexto, '[@TABLA]', @v_ListaFormateada);
        END
        ELSE
        BEGIN
            IF @v_EsBusquedaPorDescarte = 1 AND LEN(@v_FiltroTexto) < 4
            BEGIN
                SELECT TOP 1 @v_PlantillaTexto = TextoRespuesta FROM PlantillasRespuesta WHERE ReglaID = 6 AND Activo = 1 ORDER BY NEWID();
                SET @o_TextoRespuesta = ISNULL(@v_PlantillaTexto, 'No logré comprender tu mensaje. Intenta ingresando el nombre de un artículo.');
                SET @o_ReglaActivadaID = 6;
            END
            ELSE
            BEGIN
                SELECT TOP 1 @v_PlantillaTexto = TextoRespuesta FROM PlantillasRespuesta WHERE ReglaID = 5 AND Activo = 1 ORDER BY NEWID();
                SET @o_TextoRespuesta = ISNULL(@v_PlantillaTexto, 'En este momento no contamos con existencias de ese producto.');
                SET @o_ReglaActivadaID = 5;
            END
        END
    END

    -- REGLA 3: MÉTODOS DE PAGO
    ELSE IF @v_ReglaID = 3
    BEGIN
        SELECT TOP 1 @v_PlantillaTexto = TextoRespuesta FROM PlantillasRespuesta WHERE ReglaID = 3 AND Activo = 1 ORDER BY NEWID();
        SET @o_TextoRespuesta = ISNULL(@v_PlantillaTexto, 'Disponemos de diversas opciones de pago: tarjetas de crédito o débito, transferencia bancaria y efectivo.');
    END

    -- REGLA 4: DESPEDIDA
    ELSE IF @v_ReglaID = 4
    BEGIN
        SELECT TOP 1 @v_PlantillaTexto = TextoRespuesta FROM PlantillasRespuesta WHERE ReglaID = 4 AND Activo = 1 ORDER BY NEWID();
        SET @o_TextoRespuesta = ISNULL(@v_PlantillaTexto, 'Ha sido un gusto atenderte. Que tengas un excelente día.');
    END

    -- REGLA 7: SOPORTE HUMANO / ASISTENCIA
    ELSE IF @v_ReglaID = 7
    BEGIN
        SELECT TOP 1 @v_PlantillaTexto = TextoRespuesta FROM PlantillasRespuesta WHERE ReglaID = 7 AND Activo = 1 ORDER BY NEWID();
        SET @o_TextoRespuesta = ISNULL(@v_PlantillaTexto, 'Solicitud registrada. Un representante del departamento de soporte te contactará a la brevedad.');
    END

    -- REGLA 8: AGREGAR CARRITO (Soporta ID numérico directo O Búsqueda por Nombre de Producto con Cantidad dinámica)
    ELSE IF @v_ReglaID = 8
    BEGIN
        DECLARE @v_ProdVarId INT = NULL;
        DECLARE @v_Cantidad INT = 1;

        -- Limpiar comandos desencadenantes para aislar el término de búsqueda o ID
        DECLARE @v_SearchProductStr VARCHAR(500) = @w_TextoLower;
        SET @v_SearchProductStr = REPLACE(@v_SearchProductStr, 'agregar al carrito', '');
        SET @v_SearchProductStr = REPLACE(@v_SearchProductStr, 'anadir al carrito', '');
        SET @v_SearchProductStr = REPLACE(@v_SearchProductStr, 'añadir al carrito', '');
        SET @v_SearchProductStr = REPLACE(@v_SearchProductStr, 'agregar carrito', '');
        SET @v_SearchProductStr = REPLACE(@v_SearchProductStr, 'anadir carrito', '');
        SET @v_SearchProductStr = REPLACE(@v_SearchProductStr, 'añadir carrito', '');
        SET @v_SearchProductStr = REPLACE(@v_SearchProductStr, 'agregar producto', '');
        SET @v_SearchProductStr = REPLACE(@v_SearchProductStr, 'meter al carrito', '');
        SET @v_SearchProductStr = REPLACE(@v_SearchProductStr, 'comprar producto', '');
        SET @v_SearchProductStr = REPLACE(@v_SearchProductStr, 'agrega al carrito', '');
        SET @v_SearchProductStr = REPLACE(@v_SearchProductStr, 'agrega carrito', '');
        SET @v_SearchProductStr = REPLACE(@v_SearchProductStr, 'agrega', '');
        SET @v_SearchProductStr = REPLACE(@v_SearchProductStr, 'agregar', '');
        SET @v_SearchProductStr = TRIM(@v_SearchProductStr);

        -- Caso A: Se proporcionó cantidad + ID numérico directo (ej: "agregar 2 del producto 5")
        IF @v_SecondNum IS NOT NULL
        BEGIN
            SET @v_Cantidad = @v_FirstNum;
            SET @v_ProdVarId = @v_SecondNum;
        END
        -- Caso B: Se proporcionó ID directo exclusivamente numérico (ej: "5" o "producto 5")
        ELSE IF @v_FirstNum IS NOT NULL AND (ISNUMERIC(@v_SearchProductStr) = 1 OR @v_SearchProductStr = CAST(@v_FirstNum AS VARCHAR) OR @v_SearchProductStr = 'producto ' + CAST(@v_FirstNum AS VARCHAR) OR @v_SearchProductStr = 'del producto ' + CAST(@v_FirstNum AS VARCHAR))
        BEGIN
            SET @v_Cantidad = 1;
            SET @v_ProdVarId = @v_FirstNum;
        END

        -- Caso C: Búsqueda por Nombre de Producto (con o sin Cantidad explícita)
        IF @v_ProdVarId IS NULL
        BEGIN
            -- Determinar si el primer número extraído es una CANTIDAD al inicio del texto (ej: "2 iphone 14" o "2 del producto...")
            -- NOTA: Si el texto es "iphone 14", el 14 es parte del nombre del producto, NO la cantidad.
            IF @v_FirstNum IS NOT NULL AND (
                @v_SearchProductStr LIKE CAST(@v_FirstNum AS VARCHAR) + ' %' 
                OR @v_SearchProductStr LIKE CAST(@v_FirstNum AS VARCHAR) + ' del %' 
                OR @v_SearchProductStr LIKE CAST(@v_FirstNum AS VARCHAR) + ' de %' 
                OR @v_SearchProductStr LIKE CAST(@v_FirstNum AS VARCHAR) + ' x %'
                OR @v_SearchProductStr LIKE CAST(@v_FirstNum AS VARCHAR) + ' unidades%'
            )
            BEGIN
                SET @v_Cantidad = @v_FirstNum;
                -- Retirar el número inicial del nombre a buscar
                SET @v_SearchProductStr = TRIM(SUBSTRING(@v_SearchProductStr, LEN(CAST(@v_FirstNum AS VARCHAR)) + 1, 500));
            END
            ELSE
            BEGIN
                SET @v_Cantidad = 1;
            END

            -- Limpiar prefijos y conectores del texto de búsqueda
            IF @v_SearchProductStr LIKE 'del producto %' SET @v_SearchProductStr = TRIM(SUBSTRING(@v_SearchProductStr, 14, 500));
            IF @v_SearchProductStr LIKE 'producto %' SET @v_SearchProductStr = TRIM(SUBSTRING(@v_SearchProductStr, 10, 500));
            IF @v_SearchProductStr LIKE 'de %' SET @v_SearchProductStr = TRIM(SUBSTRING(@v_SearchProductStr, 4, 500));
            IF @v_SearchProductStr LIKE 'el %' SET @v_SearchProductStr = TRIM(SUBSTRING(@v_SearchProductStr, 4, 500));
            IF @v_SearchProductStr LIKE 'un %' SET @v_SearchProductStr = TRIM(SUBSTRING(@v_SearchProductStr, 4, 500));
            IF @v_SearchProductStr LIKE 'uno %' SET @v_SearchProductStr = TRIM(SUBSTRING(@v_SearchProductStr, 5, 500));

            IF LEN(@v_SearchProductStr) > 0
            BEGIN
                DECLARE @SearchCartScore TABLE (
                    ProductID INT, ProductName VARCHAR(50), ProductVariableID INT, ProductVariableName VARCHAR(50),
                    ProductVariablePrice DECIMAL(18,2), CurrencyID INT, CurrencyISO CHAR(5), CategoryID INT,
                    CategoryName VARCHAR(50), SubcategoryID INT, SubcategoryName VARCHAR(50), SegmentID INT,
                    SegmentName VARCHAR(50), MarkID INT, MarkName VARCHAR(50), ProviderID INT,
                    ProviderName VARCHAR(50), StockID INT, StockAvilable INT, StockFactoryDate DATE, StockExpirationDate DATE,
                    ProductImageURL VARCHAR(MAX),
                    CoincidenceScore INT
                );

                INSERT INTO @SearchCartScore
                EXEC dbo.SP_ListarGeneralProducts_Filtro @01_FilterText = @v_SearchProductStr;

                SELECT TOP 1 @v_ProdVarId = ProductVariableID 
                FROM @SearchCartScore 
                WHERE StockAvilable > 0 
                ORDER BY CoincidenceScore DESC;
            END
        END

        -- Resolver si @v_ProdVarId fue pasado como ProductID en lugar de ProductVariableID
        IF @v_ProdVarId IS NOT NULL AND NOT EXISTS (
            SELECT 1 FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_ProductVariables] 
            WHERE productVariableId = @v_ProdVarId AND productVariableStatusId = 1
        )
        BEGIN
            SELECT TOP 1 @v_ProdVarId = productVariableId
            FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_ProductVariables]
            WHERE productVariableProductId = @v_ProdVarId AND productVariableStatusId = 1
            ORDER BY productVariableId ASC;
        END

        IF @v_ProdVarId IS NULL
        BEGIN
            SET @o_TextoRespuesta = 'No fue posible identificar el producto solicitado. Intenta indicando el nombre exacto o su número de ID (ejemplo: "agregar al carrito Sony Xperia 1 V" o "agregar producto 5").';
        END
        ELSE
        BEGIN
            DECLARE @v_Code INT, @v_Message VARCHAR(255), @v_TemplateId INT;

            EXEC [DB_ECOMMERCE].[SQM_GENERAL].[sp_CartDetails_Create]
                @userId = @v_UserId,
                @productVariableId = @v_ProdVarId,
                @quantity = @v_Cantidad,
                @discount = 0.00,
                @creatorId = @v_UserId,
                @statusId = 1,
                @o_code = @v_Code OUTPUT,
                @o_message = @v_Message OUTPUT,
                @o_templateId = @v_TemplateId OUTPUT;

            IF @v_Code = 200
            BEGIN
                DECLARE @v_NombreProducto VARCHAR(100) = '';
                SELECT TOP 1 @v_NombreProducto = P.productName + ' (' + PV.productVariableValue + ')'
                FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_ProductVariables] PV
                INNER JOIN [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_Products] P ON PV.productVariableProductId = P.productId
                WHERE PV.productVariableId = @v_ProdVarId;

                SELECT TOP 1 @v_PlantillaTexto = TextoRespuesta FROM PlantillasRespuesta WHERE ReglaID = 8 AND Activo = 1 ORDER BY NEWID();
                IF @v_PlantillaTexto IS NULL OR @v_PlantillaTexto = ''
                    SET @v_PlantillaTexto = 'Buena elección. Añadí el producto a tu carrito de compras.';

                SET @o_TextoRespuesta = @v_PlantillaTexto + CHAR(13) + CHAR(10) +
                                        '- Producto: ' + ISNULL(@v_NombreProducto, 'ID ' + CAST(@v_ProdVarId AS VARCHAR)) + CHAR(13) + CHAR(10) +
                                        '- Cantidad: ' + CAST(@v_Cantidad AS VARCHAR) + CHAR(13) + CHAR(10) +
                                        'Escribe "ver carrito" para revisar tus productos o "procesar pago" para finalizar.';
            END
            ELSE
            BEGIN
                SET @o_TextoRespuesta = 'No se pudo agregar al carrito: ' + ISNULL(@v_Message, 'Error desconocido');
            END
        END
    END

    -- REGLA 9: CONSULTAR CARRITO
    ELSE IF @v_ReglaID = 9
    BEGIN
        DECLARE @v_CartIdCons INT = NULL;
        SELECT @v_CartIdCons = cartId 
        FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_Carts] 
        WHERE cartUserId = @v_UserId AND cartStatusId = 1;

        IF @v_CartIdCons IS NULL OR NOT EXISTS (
            SELECT 1 FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_CartDetails] 
            WHERE cartDetailCartId = @v_CartIdCons AND cartDetailStatusId = 1
        )
        BEGIN
            SET @o_TextoRespuesta = 'Tu carrito de compras se encuentra vacío en este momento. Agrega artículos explorando nuestro catálogo.';
        END
        ELSE
        BEGIN
            DECLARE @v_TablaCarrito NVARCHAR(MAX) = '';
            DECLARE @v_TotalCarrito DECIMAL(18,2) = 0;

            SELECT 
                @v_TablaCarrito = @v_TablaCarrito + CHAR(13) + CHAR(10) + 
                    '- [ID: ' + CAST(PV.productVariableId AS VARCHAR) + '] ' + P.productName + ' (' + PV.productVariableValue + ') | Cantidad: ' + CAST(CD.cartDetailQuantity AS VARCHAR) + 
                    ' | Precio: ' + CAST(CD.cartDetailPrice AS VARCHAR) + ' | SubTotal: ' + CAST(CD.cartDetailTotal AS VARCHAR),
                @v_TotalCarrito = @v_TotalCarrito + CD.cartDetailTotal
            FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_CartDetails] CD
            INNER JOIN [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_ProductVariables] PV ON CD.cartDetailProductVariableId = PV.productVariableId
            INNER JOIN [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_Products] P ON PV.productVariableProductId = P.productId
            WHERE CD.cartDetailCartId = @v_CartIdCons AND CD.cartDetailStatusId = 1;

            SELECT TOP 1 @v_PlantillaTexto = TextoRespuesta FROM PlantillasRespuesta WHERE ReglaID = 9 AND Activo = 1 ORDER BY NEWID();
            IF @v_PlantillaTexto IS NULL OR @v_PlantillaTexto = ''
                SET @v_PlantillaTexto = 'Te comparto el detalle de los productos que tienes seleccionados en tu carrito:' + CHAR(13) + CHAR(10) + '[@TABLA_CARRITO]' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + 'Monto a cancelar: C$ [@TOTAL_CARRITO]';

            SET @o_TextoRespuesta = REPLACE(REPLACE(@v_PlantillaTexto, '[@TABLA_CARRITO]', @v_TablaCarrito), '[@TOTAL_CARRITO]', CAST(@v_TotalCarrito AS VARCHAR));
        END
    END

    -- REGLA 10: ELIMINAR / VACIAR CARRITO (Soporta ID numérico directo, Nombre de Producto o Vaciar Todo)
    ELSE IF @v_ReglaID = 10
    BEGIN
        DECLARE @v_CartIdDel INT = NULL;
        SELECT @v_CartIdDel = cartId 
        FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_Carts] 
        WHERE cartUserId = @v_UserId AND cartStatusId = 1;

        IF @v_CartIdDel IS NULL OR NOT EXISTS (
            SELECT 1 FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_CartDetails] 
            WHERE cartDetailCartId = @v_CartIdDel AND cartDetailStatusId = 1
        )
        BEGIN
            SET @o_TextoRespuesta = 'No registras artículos activos en tu carrito para remover.';
        END
        ELSE IF @w_TextoLower LIKE '%vaciar%' OR @w_TextoLower LIKE '%limpiar%' OR @w_TextoLower LIKE '%borrar todo%' OR @w_TextoLower LIKE '%eliminar todo%'
        BEGIN
            UPDATE [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_CartDetails]
            SET cartDetailStatusId = 0, cartDetailModificationDate = GETDATE()
            WHERE cartDetailCartId = @v_CartIdDel AND cartDetailStatusId = 1;

            SET @o_TextoRespuesta = 'Procesado. Se ha vaciado la totalidad de tu carrito de compras.';
        END
        ELSE
        BEGIN
            DECLARE @v_CartDetailId INT = NULL;

            -- Limpiar la cadena del mensaje quitando palabras desencadenantes
            DECLARE @v_SearchDelStr VARCHAR(500) = @w_TextoLower;
            SET @v_SearchDelStr = REPLACE(@v_SearchDelStr, 'eliminar del carrito', '');
            SET @v_SearchDelStr = REPLACE(@v_SearchDelStr, 'quitar del carrito', '');
            SET @v_SearchDelStr = REPLACE(@v_SearchDelStr, 'borrar del carrito', '');
            SET @v_SearchDelStr = REPLACE(@v_SearchDelStr, 'eliminar producto', '');
            SET @v_SearchDelStr = REPLACE(@v_SearchDelStr, 'quitar producto', '');
            SET @v_SearchDelStr = REPLACE(@v_SearchDelStr, 'borrar producto', '');
            SET @v_SearchDelStr = REPLACE(@v_SearchDelStr, 'eliminar el', '');
            SET @v_SearchDelStr = REPLACE(@v_SearchDelStr, 'quitar el', '');
            SET @v_SearchDelStr = REPLACE(@v_SearchDelStr, 'borrar el', '');
            SET @v_SearchDelStr = REPLACE(@v_SearchDelStr, 'eliminar', '');
            SET @v_SearchDelStr = REPLACE(@v_SearchDelStr, 'quitar', '');
            SET @v_SearchDelStr = REPLACE(@v_SearchDelStr, 'borrar', '');
            SET @v_SearchDelStr = TRIM(@v_SearchDelStr);

            IF @v_SearchDelStr LIKE 'el %' SET @v_SearchDelStr = TRIM(SUBSTRING(@v_SearchDelStr, 4, 500));
            IF @v_SearchDelStr LIKE 'del producto %' SET @v_SearchDelStr = TRIM(SUBSTRING(@v_SearchDelStr, 14, 500));
            IF @v_SearchDelStr LIKE 'producto %' SET @v_SearchDelStr = TRIM(SUBSTRING(@v_SearchDelStr, 10, 500));

            -- 1. Si el string resultante es EXCLUSIVAMENTE numérico (ej: "3" o "18"), buscar por ID exacto
            IF ISNUMERIC(@v_SearchDelStr) = 1
            BEGIN
                DECLARE @v_NumID INT = TRY_CAST(@v_SearchDelStr AS INT);
                SELECT TOP 1 @v_CartDetailId = cartDetailId
                FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_CartDetails]
                WHERE cartDetailCartId = @v_CartIdDel 
                  AND cartDetailStatusId = 1
                  AND (cartDetailProductVariableId = @v_NumID OR cartDetailId = @v_NumID);
            END

            -- 2. Si NO fue encontrado por ID exclusivamente numérico (o si incluye texto como "air max 90"), buscar por NOMBRE en el carrito
            IF @v_CartDetailId IS NULL AND LEN(@v_SearchDelStr) > 0
            BEGIN
                SELECT TOP 1 @v_CartDetailId = CD.cartDetailId
                FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_CartDetails] CD
                INNER JOIN [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_ProductVariables] PV ON CD.cartDetailProductVariableId = PV.productVariableId
                INNER JOIN [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_Products] P ON PV.productVariableProductId = P.productId
                WHERE CD.cartDetailCartId = @v_CartIdDel 
                  AND CD.cartDetailStatusId = 1
                  AND (LOWER(P.productName) LIKE '%' + @v_SearchDelStr + '%' OR LOWER(PV.productVariableValue) LIKE '%' + @v_SearchDelStr + '%');
            END

            -- 3. Fallback: Si sigue sin encontrarse pero había un número en el mensaje (ej: "eliminar 3")
            IF @v_CartDetailId IS NULL AND @v_FirstNum IS NOT NULL
            BEGIN
                SELECT TOP 1 @v_CartDetailId = cartDetailId
                FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_CartDetails]
                WHERE cartDetailCartId = @v_CartIdDel 
                  AND cartDetailStatusId = 1
                  AND (cartDetailProductVariableId = @v_FirstNum OR cartDetailId = @v_FirstNum);
            END

            IF @v_CartDetailId IS NULL
            BEGIN
                SET @o_TextoRespuesta = 'No se encontró el producto especificado en tu carrito activo. Indica el ID del producto (ejemplo: "eliminar producto 3"), el nombre o escribe "vaciar carrito".';
            END
            ELSE
            BEGIN
                DECLARE @v_CodeDel INT, @v_MsgDel VARCHAR(255), @v_TplDel INT;

                EXEC [DB_ECOMMERCE].[SQM_GENERAL].[sp_CartDetails_Delete]
                    @cartDetailId = @v_CartDetailId,
                    @cartDetailModificatorId = @v_UserId,
                    @o_code = @v_CodeDel OUTPUT,
                    @o_message = @v_MsgDel OUTPUT,
                    @o_templateId = @v_TplDel OUTPUT;

                IF @v_CodeDel = 200
                BEGIN
                    SELECT TOP 1 @v_PlantillaTexto = TextoRespuesta FROM PlantillasRespuesta WHERE ReglaID = 10 AND Activo = 1 ORDER BY NEWID();
                    SET @o_TextoRespuesta = ISNULL(@v_PlantillaTexto, 'El artículo seleccionado fue retirado de tu carrito.');
                END
                ELSE
                BEGIN
                    SET @o_TextoRespuesta = 'No fue posible eliminar el producto: ' + ISNULL(@v_MsgDel, 'Error desconocido');
                END
            END
        END
    END

    -- REGLA 11: PROCESAR PAGO
    ELSE IF @v_ReglaID = 11
    BEGIN
        DECLARE @v_CartIdPay INT = NULL;
        SELECT @v_CartIdPay = cartId 
        FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_Carts] 
        WHERE cartUserId = @v_UserId AND cartStatusId = 1;

        IF @v_CartIdPay IS NULL OR NOT EXISTS (
            SELECT 1 FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_CartDetails] 
            WHERE cartDetailCartId = @v_CartIdPay AND cartDetailStatusId = 1
        )
        BEGIN
            SET @o_TextoRespuesta = 'Tu carrito se encuentra vacío. Añade productos antes de solicitar el pago.';
        END
        ELSE
        BEGIN
            DECLARE @v_AddrId INT = NULL;
            SELECT TOP 1 @v_AddrId = userAddressId 
            FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_UserAddress] 
            WHERE userAddressUserId = @v_UserId AND userAddressStatusId = 1
            ORDER BY userAddressId ASC;

            DECLARE @v_PayMethodId INT = NULL;
            SELECT TOP 1 @v_PayMethodId = userPaymentMethodId 
            FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_UserPaymentMethods] 
            WHERE userPaymentMethodUserId = @v_UserId AND userPaymentMethodStatusId = 1
            ORDER BY userPaymentMethodId ASC;

            IF @v_AddrId IS NULL
            BEGIN
                SET @o_TextoRespuesta = 'No registras una dirección de entrega activa en tu perfil. Por favor agrega una dirección para procesar el pedido.';
            END
            ELSE IF @v_PayMethodId IS NULL
            BEGIN
                SET @o_TextoRespuesta = 'No cuentas con un método de pago activo registrado. Por favor asocia una forma de pago para finalizar.';
            END
            ELSE
            BEGIN
                DECLARE @v_CodePay INT, @v_MsgPay VARCHAR(255), @v_OrderIdGenerado INT;

                EXEC [DB_ECOMMERCE].[SQM_GENERAL].[sp_PaymentOrders_Create]
                    @orderUserId = @v_UserId,
                    @orderDeliveryAddress = @v_AddrId,
                    @orderPaymentMethodId = @v_PayMethodId,
                    @orderSubtotal = NULL,
                    @orderDiscount = NULL,
                    @orderShipping = 50.00,
                    @orderTAX = NULL,
                    @orderTotal = NULL,
                    @orderCurrencyId = 1,
                    @orderCreatorId = @v_UserId,
                    @orderStatusId = 1,
                    @o_code = @v_CodePay OUTPUT,
                    @o_message = @v_MsgPay OUTPUT,
                    @o_templateId = @v_OrderIdGenerado OUTPUT;

                IF @v_CodePay = 200
                BEGIN
                    SELECT TOP 1 @v_PlantillaTexto = TextoRespuesta FROM PlantillasRespuesta WHERE ReglaID = 11 AND Activo = 1 ORDER BY NEWID();
                    IF @v_PlantillaTexto IS NULL OR @v_PlantillaTexto = ''
                        SET @v_PlantillaTexto = 'Operación exitosa. Tu transacción ha sido aprobada y generamos la Orden de Compra #[@ORDEN_ID].';

                    SET @o_TextoRespuesta = REPLACE(@v_PlantillaTexto, '[@ORDEN_ID]', CAST(@v_OrderIdGenerado AS VARCHAR));
                END
                ELSE
                BEGIN
                    SET @o_TextoRespuesta = 'No se logró procesar el pago: ' + ISNULL(@v_MsgPay, 'Inconveniente en la orden de pago.');
                END
            END
        END
    END

    -- REGLA 12: CONSULTAR ORDEN
    ELSE IF @v_ReglaID = 12
    BEGIN
        DECLARE @v_OrdId INT = NULL, @v_OrdStatus VARCHAR(50) = NULL, @v_OrdTotal DECIMAL(18,2) = NULL, @v_OrdDate DATETIME = NULL, @v_OrdCurrency CHAR(5) = NULL;

        SELECT TOP 1 
            @v_OrdId = orderId,
            @v_OrdStatus = statusName,
            @v_OrdTotal = total,
            @v_OrdDate = creationDate,
            @v_OrdCurrency = currencyISO
        FROM [DB_ECOMMERCE].[SQM_GENERAL].[VW_PAYMENT_ORDERS]
        WHERE userId = @v_UserId
        ORDER BY orderId DESC;

        IF @v_OrdId IS NULL
        BEGIN
            SET @o_TextoRespuesta = 'No constan órdenes o pedidos registrados a tu nombre.';
        END
        ELSE
        BEGIN
            SELECT TOP 1 @v_PlantillaTexto = TextoRespuesta FROM PlantillasRespuesta WHERE ReglaID = 12 AND Activo = 1 ORDER BY NEWID();
            IF @v_PlantillaTexto IS NULL OR @v_PlantillaTexto = ''
                SET @v_PlantillaTexto = 'Tu pedido reciente es el #[@ORDEN_ID] registrado el [@FECHA_ORDEN]. Estado actual: [@ESTADO_ORDEN] | Total: [@CURRENCY] [@TOTAL_ORDEN].';

            SET @o_TextoRespuesta = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                @v_PlantillaTexto, 
                '[@ORDEN_ID]', CAST(@v_OrdId AS VARCHAR)),
                '[@FECHA_ORDEN]', CONVERT(VARCHAR, @v_OrdDate, 103)),
                '[@ESTADO_ORDEN]', ISNULL(@v_OrdStatus, 'Procesando')),
                '[@CURRENCY]', ISNULL(@v_OrdCurrency, 'NIO')),
                '[@TOTAL_ORDEN]', CAST(@v_OrdTotal AS VARCHAR));
        END
    END

    -- FLUJO GENERAL POR DEFECTO
    ELSE
    BEGIN
        SELECT TOP 1 @v_PlantillaTexto = TextoRespuesta FROM PlantillasRespuesta WHERE ReglaID = @v_ReglaID AND Activo = 1 ORDER BY NEWID();
        SET @o_TextoRespuesta = ISNULL(@v_PlantillaTexto, 'Agradecemos tu comunicación.');
    END

    -- -------------------------------------------------------------------------
    -- 6. REGISTRAR LA RESPUESTA FINAL EMITIDA POR EL BOT
    -- -------------------------------------------------------------------------
    INSERT INTO dbo.HistorialMensajes (ConversacionID, ChatBot, Texto, FechaHora, ReglaActivadaID)
    VALUES (@v_ConvIDInt, 1, LEFT(@o_TextoRespuesta, 1000), GETDATE(), @o_ReglaActivadaID);

END
GO
