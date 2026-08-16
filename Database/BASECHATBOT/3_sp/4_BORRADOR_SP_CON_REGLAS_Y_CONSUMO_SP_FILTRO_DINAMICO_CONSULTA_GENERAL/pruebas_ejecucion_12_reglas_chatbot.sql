USE [DB_EcommerceAgent]
GO

-- ============================================================================
-- SCRIPT DE PRUEBAS DE EJECUCIÓN COMPLETA DE REGLAS CHATBOT (4 PRUEBAS POR REGLA)
-- ============================================================================
-- Este script ejecuta 4 variaciones de prueba para cada una de las 12 reglas del Chatbot.
-- Permite verificar el comportamiento dinámico, estático y de fallback.

DECLARE @RespuestaChatbot NVARCHAR(MAX);
DECLARE @ReglaID INT;

PRINT '====================================================================';
PRINT '--- REGLA 1: SALUDO INICIAL (4 PRUEBAS) ---';
PRINT '====================================================================';

-- Regla 1 / Prueba 1
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'Hola buenas tardes', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 1 - Prueba 1' AS TestCase, 'Hola buenas tardes' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 1 / Prueba 2
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'buenos dias', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 1 - Prueba 2' AS TestCase, 'buenos dias' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 1 / Prueba 3
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'buenas noches que tal', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 1 - Prueba 3' AS TestCase, 'buenas noches que tal' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 1 / Prueba 4
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'hola', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 1 - Prueba 4' AS TestCase, 'hola' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;
GO


DECLARE @RespuestaChatbot NVARCHAR(MAX);
DECLARE @ReglaID INT;

PRINT '====================================================================';
PRINT '--- REGLA 2: BUSCAR PRODUCTO (4 PRUEBAS) ---';
PRINT '====================================================================';

-- Regla 2 / Prueba 1
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'laptop dell', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 2 - Prueba 1' AS TestCase, 'laptop dell' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

DECLARE @RespuestaChatbot NVARCHAR(MAX);
DECLARE @ReglaID INT;
-- Regla 2 / Prueba 2
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'zapatillas', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 2 - Prueba 2' AS TestCase, 'zapatillas' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 2 / Prueba 3
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'monitor', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 2 - Prueba 3' AS TestCase, 'monitor' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 2 / Prueba 4
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'teclado', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 2 - Prueba 4' AS TestCase, 'teclado' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;
GO


DECLARE @RespuestaChatbot NVARCHAR(MAX);
DECLARE @ReglaID INT;

PRINT '====================================================================';
PRINT '--- REGLA 3: MÉTODOS DE PAGO (4 PRUEBAS) ---';
PRINT '====================================================================';

-- Regla 3 / Prueba 1
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'cuales son los metodos de pago', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 3 - Prueba 1' AS TestCase, 'cuales son los metodos de pago' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 3 / Prueba 2
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'puedo pagar con tarjeta', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 3 - Prueba 2' AS TestCase, 'puedo pagar con tarjeta' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 3 / Prueba 3
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'transferencia', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 3 - Prueba 3' AS TestCase, 'transferencia' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 3 / Prueba 4
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'como puedo pagar', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 3 - Prueba 4' AS TestCase, 'como puedo pagar' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;
GO


DECLARE @RespuestaChatbot NVARCHAR(MAX);
DECLARE @ReglaID INT;

PRINT '====================================================================';
PRINT '--- REGLA 4: DESPEDIDA (4 PRUEBAS) ---';
PRINT '====================================================================';

-- Regla 4 / Prueba 1
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'muchas gracias hasta luego', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 4 - Prueba 1' AS TestCase, 'muchas gracias hasta luego' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 4 / Prueba 2
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'chao adios', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 4 - Prueba 2' AS TestCase, 'chao adios' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 4 / Prueba 3
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'gracias por la informacion', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 4 - Prueba 3' AS TestCase, 'gracias por la informacion' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 4 / Prueba 4
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'hasta luego', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 4 - Prueba 4' AS TestCase, 'hasta luego' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;
GO


DECLARE @RespuestaChatbot NVARCHAR(MAX);
DECLARE @ReglaID INT;

PRINT '====================================================================';
PRINT '--- REGLA 5: SIN RESULTADOS (4 PRUEBAS) ---';
PRINT '====================================================================';

-- Regla 5 / Prueba 1
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'cohete espacial supersonico', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 5 - Prueba 1' AS TestCase, 'cohete espacial supersonico' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 5 / Prueba 2
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'submarino nuclear 2099', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 5 - Prueba 2' AS TestCase, 'submarino nuclear 2099' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 5 / Prueba 3
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'unicornio volador 5000', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 5 - Prueba 3' AS TestCase, 'unicornio volador 5000' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 5 / Prueba 4
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'nave alienigena galactica', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 5 - Prueba 4' AS TestCase, 'nave alienigena galactica' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;
GO


DECLARE @RespuestaChatbot NVARCHAR(MAX);
DECLARE @ReglaID INT;

PRINT '====================================================================';
PRINT '--- REGLA 6: NO RECONOCIDO / CORTO (4 PRUEBAS) ---';
PRINT '====================================================================';

-- Regla 6 / Prueba 1
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'xyz', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 6 - Prueba 1' AS TestCase, 'xyz' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 6 / Prueba 2
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'qw', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 6 - Prueba 2' AS TestCase, 'qw' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 6 / Prueba 3
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'abc', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 6 - Prueba 3' AS TestCase, 'abc' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 6 / Prueba 4
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = '12', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 6 - Prueba 4' AS TestCase, '12' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;
GO


DECLARE @RespuestaChatbot NVARCHAR(MAX);
DECLARE @ReglaID INT;

PRINT '====================================================================';
PRINT '--- REGLA 7: NO ENTENDIDO (4 PRUEBAS) ---';
PRINT '====================================================================';

-- Regla 7 / Prueba 1
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = '????', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 7 - Prueba 1' AS TestCase, '????' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 7 / Prueba 2
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'asdfghjkl', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 7 - Prueba 2' AS TestCase, 'asdfghjkl' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 7 / Prueba 3
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = '......', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 7 - Prueba 3' AS TestCase, '......' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 7 / Prueba 4
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = '!!!', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 7 - Prueba 4' AS TestCase, '!!!' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;
GO


DECLARE @RespuestaChatbot NVARCHAR(MAX);
DECLARE @ReglaID INT;

PRINT '====================================================================';
PRINT '--- REGLA 8: AGREGAR CARRITO (4 PRUEBAS) ---';
PRINT '====================================================================';

-- Regla 8 / Prueba 1: Especificando Cantidad e ID (2 del 1)
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'agregar 2 del producto 1', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 8 - Prueba 1' AS TestCase, 'agregar 1 del producto 1' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;


DECLARE @RespuestaChatbot NVARCHAR(MAX);
DECLARE @ReglaID INT;
-- Regla 2 / Prueba 2
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'zapatillas', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 2 - Prueba 2' AS TestCase, 'zapatillas' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

DECLARE @RespuestaChatbot NVARCHAR(MAX);
DECLARE @ReglaID INT;
-- Regla 8 / Prueba 2: Solo especificando ID (Producto 1, cantidad defecto 1)
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'agregar 2 del producto 18', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 8 - Prueba 2' AS TestCase, 'agregar 2 del producto 18' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 8 / Prueba 3: Con sinónimo de añadir (3 del producto 2)
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'anadir al carrito 3 del producto 2', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 8 - Prueba 3' AS TestCase, 'anadir al carrito 3 del producto 2' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 8 / Prueba 4: Frase simple (agregar carrito 1)
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'agregar carrito producto 1', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 8 - Prueba 4' AS TestCase, 'agregar carrito producto 1' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;
GO


DECLARE @RespuestaChatbot NVARCHAR(MAX);
DECLARE @ReglaID INT;

PRINT '====================================================================';
PRINT '--- REGLA 9: CONSULTAR CARRITO (4 PRUEBAS) ---';
PRINT '====================================================================';

-- Regla 9 / Prueba 1
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'ver carrito', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 9 - Prueba 1' AS TestCase, 'ver carrito' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 9 / Prueba 2
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'mi carrito', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 9 - Prueba 2' AS TestCase, 'mi carrito' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 9 / Prueba 3
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'consultar carrito', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 9 - Prueba 3' AS TestCase, 'consultar carrito' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 9 / Prueba 4
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'carrito', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 9 - Prueba 4' AS TestCase, 'carrito' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;
GO


DECLARE @RespuestaChatbot NVARCHAR(MAX);
DECLARE @ReglaID INT;

PRINT '====================================================================';
PRINT '--- REGLA 10: ELIMINAR PRODUCTO CARRITO (4 PRUEBAS) ---';
PRINT '====================================================================';

-- Regla 10 / Prueba 1: Eliminar un producto específico por ID
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'eliminar producto 1', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 10 - Prueba 1' AS TestCase, 'eliminar producto 1' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 10 / Prueba 2: Quitar producto 2
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'quitar del carrito producto 2', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 10 - Prueba 2' AS TestCase, 'quitar del carrito producto 2' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 10 / Prueba 3: Intentar eliminar un producto que no está
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'borrar del carrito producto 999', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 10 - Prueba 3' AS TestCase, 'borrar del carrito producto 999' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 10 / Prueba 4: Vaciar completamente el carrito
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'vaciar mi carrito', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 10 - Prueba 4' AS TestCase, 'vaciar mi carrito' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;
GO


DECLARE @RespuestaChatbot NVARCHAR(MAX);
DECLARE @ReglaID INT;

-- Volvemos a agregar un ítem para probar el checkout de la Regla 11
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'agregar 1 del producto 1', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;

PRINT '====================================================================';
PRINT '--- REGLA 11: PROCESAR PAGO (4 PRUEBAS) ---';
PRINT '====================================================================';

-- Regla 11 / Prueba 1: Checkout normal con carrito lleno
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'procesar pago', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 11 - Prueba 1' AS TestCase, 'procesar pago' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 11 / Prueba 2: Intentar pagar inmediatamente después con carrito ya procesado (vacío)
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'finalizar compra', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 11 - Prueba 2' AS TestCase, 'finalizar compra' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 11 / Prueba 3: Sinónimo "pagar carrito" (carrito vacío)
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'pagar carrito', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 11 - Prueba 3' AS TestCase, 'pagar carrito' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 11 / Prueba 4: Sinónimo "pagar" (carrito vacío)
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'pagar', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 11 - Prueba 4' AS TestCase, 'pagar' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;
GO


DECLARE @RespuestaChatbot NVARCHAR(MAX);
DECLARE @ReglaID INT;

PRINT '====================================================================';
PRINT '--- REGLA 12: CONSULTAR ORDEN (4 PRUEBAS) ---';
PRINT '====================================================================';

-- Regla 12 / Prueba 1: Rastrear última orden recién creada
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'estado de mi orden', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 12 - Prueba 1' AS TestCase, 'estado de mi orden' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 12 / Prueba 2: Consultar mi orden
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'mi orden', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 12 - Prueba 2' AS TestCase, 'mi orden' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 12 / Prueba 3: Ver pedido
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'ver pedido', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 12 - Prueba 3' AS TestCase, 'ver pedido' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;

-- Regla 12 / Prueba 4: Rastrear orden
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'rastrear orden', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 12 - Prueba 4' AS TestCase, 'rastrear orden' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;
GO






-- EJEMPLOS DE PRUEBA COMPLETA DE TODAS LAS REGLAS


DECLARE @RespuestaChatbot NVARCHAR(MAX);
DECLARE @ReglaID INT;

-- Prueba 1: Saludo
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = '1', @w_TextoUsuario = 'Hola buenos dias', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT @RespuestaChatbot AS Bot_Dice, @ReglaID AS Regla_Disparada;

-- Prueba 2: Buscar Producto
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = '1', @w_TextoUsuario = 'laptop dell', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT @RespuestaChatbot AS Bot_Dice, @ReglaID AS Regla_Disparada;

-- Prueba 8: Agregar Producto al Carrito
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = '1', @w_TextoUsuario = 'agregar 2 del producto 1', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT @RespuestaChatbot AS Bot_Dice, @ReglaID AS Regla_Disparada;

-- Prueba 9: Consultar Carrito
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = '1', @w_TextoUsuario = 'ver carrito', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT @RespuestaChatbot AS Bot_Dice, @ReglaID AS Regla_Disparada;

-- Prueba 10: Eliminar Producto
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = '1', @w_TextoUsuario = 'eliminar producto 1', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT @RespuestaChatbot AS Bot_Dice, @ReglaID AS Regla_Disparada;

-- Prueba 11: Procesar Pago (Checkout)
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = '1', @w_TextoUsuario = 'procesar pago', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT @RespuestaChatbot AS Bot_Dice, @ReglaID AS Regla_Disparada;

-- Prueba 12: Consultar Orden
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = '1', @w_TextoUsuario = 'estado de mi orden', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT @RespuestaChatbot AS Bot_Dice, @ReglaID AS Regla_Disparada;
GO




---------------- stock4

select * from [SQM_GENERAL].[Tbl_Stocks]

DECLARE @RespuestaChatbot NVARCHAR(MAX);
DECLARE @ReglaID INT;
-- Regla 2 / Prueba 2
EXEC dbo.SP_ProcesarMensajeChatbot @w_ConversacionID = 'sesion_prueba_1', @w_TextoUsuario = 'zapatillas', @o_TextoRespuesta = @RespuestaChatbot OUTPUT, @o_ReglaActivadaID = @ReglaID OUTPUT;
SELECT 'Regla 2 - Prueba 2' AS TestCase, 'zapatillas' AS EntradaUsuario, @ReglaID AS ReglaDisparada, @RespuestaChatbot AS BotDice;
