USE [DB_EcommerceAgent];
GO

-- ============================================================================
-- 1. LIMPIEZA / INICIALIZACIÓN DE TABLAS DE REGLAS
-- ============================================================================
SET IDENTITY_INSERT ReglasChatbot OFF;
GO

-- 2. REGLAS UNIFICADAS DEL SISTEMA EXPERTO (ID 1 AL 12)

MERGE INTO ReglasChatbot AS Target
USING (VALUES 
    (1,  'Saludo Inicial',              1, 'cargar_saludos_db',      1),
    (2,  'Buscar Producto',             1, 'buscar_producto_en_db',  1),
    (3,  'Metodos de Pago',             0, NULL,                     1),
    (4,  'Despedida',                   0, NULL,                     1),
    (5,  'Sin Resultados',              0, NULL,                     1),
    (6,  'No Reconocido',               0, NULL,                     1),
    (7,  'Soporte Humano / Asistencia', 1, 'soporte_humano',         1),
    (8,  'Agregar Carrito',             1, 'agregar_carrito',        1),
    (9,  'Consultar Carrito',           1, 'consultar_carrito',      1),
    (10, 'Eliminar Producto Carrito',    1, 'eliminar_carrito',       1),
    (11, 'Procesar Pago',               1, 'procesar_pago',          1),
    (12, 'Consultar Orden',             1, 'consultar_orden',        1)
) AS Source (ReglaID, NombreRegla, AccionDinamica, AccionPython, Activo)
ON Target.ReglaID = Source.ReglaID
WHEN MATCHED THEN 
    UPDATE SET 
        Target.NombreRegla = Source.NombreRegla,
        Target.AccionDinamica = Source.AccionDinamica,
        Target.AccionPython = Source.AccionPython,
        Target.Activo = Source.Activo
WHEN NOT MATCHED THEN
    INSERT (NombreRegla, AccionDinamica, AccionPython, Activo)
    VALUES (Source.NombreRegla, Source.AccionDinamica, Source.AccionPython, Source.Activo);
GO

-- ============================================================================
-- 3. PALABRAS CLAVE Y TRIGGERS ADMINISTRATIVOS (PalabrasClaveRegla)
-- ============================================================================

DELETE FROM PalabrasClaveRegla;
GO

INSERT INTO PalabrasClaveRegla (ReglaID, PalabraClave, Activo)
VALUES 
-- Regla 1: Saludos
(1, 'hola', 1),
(1, 'buenos dias', 1),
(1, 'buenas tardes', 1),
(1, 'buenas noches', 1),
(1, 'que tal', 1),
(1, 'saludos', 1),
(1, 'hola buenas', 1),
(1, 'inicio', 1),
(1, 'comenzar', 1),

-- Regla 3: Métodos de Pago
(3, 'puedo pagar', 1),
(3, 'metodos de pago', 1),
(3, 'formas de pago', 1),
(3, 'como puedo pagar', 1),
(3, 'tarjeta de credito', 1),
(3, 'tarjeta de debito', 1),
(3, 'transferencia bancaria', 1),
(3, 'pago en efectivo', 1),

-- Regla 4: Despedidas
(4, 'hasta luego', 1),
(4, 'muchas gracias', 1),
(4, 'nos vemos', 1),
(4, 'adios', 1),
(4, 'gracias', 1),
(4, 'chao', 1),
(4, 'chao gracias', 1),

-- Regla 7: Soporte Humano / Asistencia
(7, 'hablar con un agente', 1),
(7, 'atencion al cliente', 1),
(7, 'soporte tecnico', 1),
(7, 'ayuda humana', 1),
(7, 'contactar agente', 1),
(7, 'servicio al cliente', 1),
(7, 'soporte', 1),

-- Regla 8: Agregar al Carrito
(8, 'agregar al carrito', 1),
(8, 'anadir al carrito', 1),
(8, 'añadir al carrito', 1),
(8, 'agregar carrito', 1),
(8, 'anadir carrito', 1),
(8, 'añadir carrito', 1),
(8, 'agregar producto', 1),
(8, 'meter al carrito', 1),
(8, 'comprar producto', 1),
(8, 'agrega al carrito', 1),
(8, 'agrega carrito', 1),

-- Regla 9: Consultar Carrito
(9, 'consultar carrito', 1),
(9, 'ver mi carrito', 1),
(9, 'ver carrito', 1),
(9, 'mi carrito', 1),
(9, 'mostrar carrito', 1),
(9, 'revisar carrito', 1),
(9, 'carrito de compras', 1),

-- Regla 10: Eliminar / Vaciar Carrito
(10, 'eliminar del carrito', 1),
(10, 'quitar del carrito', 1),
(10, 'borrar del carrito', 1),
(10, 'vaciar carrito', 1),
(10, 'limpiar carrito', 1),
(10, 'eliminar todo del carrito', 1),
(10, 'borrar todo el carrito', 1),
(10, 'eliminar producto', 1),
(10, 'quitar producto', 1),
(10, 'borrar producto', 1),
(10, 'eliminar el', 1),
(10, 'quitar el', 1),
(10, 'borrar el', 1),
(10, 'eliminar', 1),
(10, 'quitar', 1),
(10, 'borrar', 1),
(10, 'vaciar', 1),
(10, 'limpiar', 1),

-- Regla 11: Procesar Pago / Checkout
(11, 'procesar pago', 1),
(11, 'finalizar compra', 1),
(11, 'pagar carrito', 1),
(11, 'proceder al pago', 1),
(11, 'checkout', 1),
(11, 'completar pedido', 1),

-- Regla 12: Consultar Estado de Orden
(12, 'estado de mi orden', 1),
(12, 'estado de mi pedido', 1),
(12, 'rastrear orden', 1),
(12, 'rastrear pedido', 1),
(12, 'ver mi orden', 1),
(12, 'ver mi pedido', 1),
(12, 'mis ordenes', 1),
(12, 'mis pedidos', 1);
GO

-- ============================================================================
-- 4. PLANTILLAS DE RESPUESTA DE VARIACIÓN ALEATORIA (SIN EMOJIS, CON SINÓNIMOS)
-- ============================================================================

DELETE FROM PlantillasRespuesta;
GO

INSERT INTO PlantillasRespuesta (ReglaID, TextoRespuesta, Activo)
VALUES 
-- Regla 1: Saludo Inicial
(1, 'Hola. Qué gusto tenerte por aquí. Dime, ¿qué andas buscando hoy en nuestra tienda?', 1),
(1, 'Un cordial saludo. ¿Buscas algún producto, marca o categoría en particular?', 1),
(1, 'Hola. Con gusto te atiendo. Puedes consultar nuestro catálogo, revisar tu carrito o rastrear tus compras.', 1),

-- Regla 2: Buscar Producto (Con marcador de posición [@TABLA])
(2, 'Excelente. Consulté el inventario al instante y encontré estas opciones para ti: \n[@TABLA]', 1),
(2, 'Revisé nuestro catálogo y estos son los artículos disponibles que se adaptan a tu búsqueda: \n[@TABLA]', 1),
(2, 'Aquí tienes el listado de productos que coinciden con lo que solicitaste: \n[@TABLA]', 1),

-- Regla 3: Métodos de Pago
(3, 'Disponemos de diversas opciones de pago: tarjetas de crédito o débito (Visa/MasterCard), transferencia bancaria directa y pago en efectivo.', 1),
(3, 'Puedes abonar tus compras con tarjeta, transferencia o efectivo contra entrega. Al estar listo tu carrito, solo indica "procesar pago".', 1),

-- Regla 4: Despedida
(4, 'Ha sido un gusto atenderte. Si necesitas consultar algo más en otro momento, aquí estaré.', 1),
(4, 'Muchas gracias por tu visita. Que tengas un excelente día. Hasta pronto.', 1),
(4, 'Agradecemos tu preferencia. Cualquier otra duda, quedo a tu disposición.', 1),

-- Regla 5: Sin Resultados
(5, 'Lamentablemente busqué en la base de datos pero no disponemos de existencias de ese artículo.', 1),
(5, 'En este momento no contamos con ese producto en nuestro inventario. ¿Te gustaría intentar buscando otro término o marca?', 1),

-- Regla 6: No Reconocido / Fallback
(6, 'No logré comprender tu mensaje. Recuerda que puedes pedirme buscar productos, escribir "ver carrito" o "procesar pago".', 1),
(6, 'No reconozco esa instrucción. Intenta ingresando el nombre de un artículo o una de las opciones del menú.', 1),

-- Regla 7: Soporte Humano / Asistencia
(7, 'Entendido. Notifiqué al equipo de atención para que un ejecutivo le dé seguimiento personal a tu caso.', 1),
(7, 'Solicitud registrada. Un representante del departamento de soporte te contactará a la brevedad.', 1),
(7, 'De acuerdo. Derivé tu consulta con nuestro personal de servicio al cliente para brindarte asistencia directa.', 1),

-- Regla 8: Agregar al Carrito
(8, 'Buena elección. Añadí el producto a tu carrito de compras.', 1),
(8, 'Listo. El artículo ha sido guardado exitosamente en tu lista de compras.', 1),
(8, 'Agregado. El producto ya forma parte de tu pedido actual.', 1),

-- Regla 9: Consultar Carrito
(9, 'Te comparto el detalle de los productos que tienes seleccionados en tu carrito:\n[@TABLA_CARRITO]\n\nMonto a cancelar: C$ [@TOTAL_CARRITO]', 1),
(9, 'Así se encuentra tu carrito de compras al día de hoy:\n[@TABLA_CARRITO]\n\nTotal estimado: C$ [@TOTAL_CARRITO]', 1),
(9, 'Aquí tienes el desglose de los artículos acumulados en tu pedido:\n[@TABLA_CARRITO]\n\nSuma total: C$ [@TOTAL_CARRITO]', 1),

-- Regla 10: Eliminar Producto Carrito
(10, 'El artículo seleccionado fue retirado de tu carrito.', 1),
(10, 'Procesado. Quitamos ese producto de tu lista de compras.', 1),
(10, 'Listo. Eliminamos el registro de tu pedido actual.', 1),

-- Regla 11: Procesar Pago
(11, 'Operación exitosa. Tu transacción ha sido aprobada y generamos la Orden de Compra #[@ORDEN_ID].', 1),
(11, 'Pago completado con éxito. Quedó registrada la Orden #[@ORDEN_ID]. Muchas gracias por tu compra.', 1),
(11, 'Confirmado. Procesamos tu pago sin inconvenientes. Tu pedido corresponde al número #[@ORDEN_ID].', 1),

-- Regla 12: Consultar Orden
(12, 'Tu pedido reciente es el #[@ORDEN_ID] registrado el [@FECHA_ORDEN]. Estado actual: [@ESTADO_ORDEN] | Total: [@CURRENCY] [@TOTAL_ORDEN].', 1),
(12, 'Verifiqué tu compra: Es la orden #[@ORDEN_ID] del [@FECHA_ORDEN]. Estatus: [@ESTADO_ORDEN] | Importe total: [@CURRENCY] [@TOTAL_ORDEN].', 1),
(12, 'Aquí constan los datos de tu pedido #[@ORDEN_ID] de fecha [@FECHA_ORDEN]: Estado: [@ESTADO_ORDEN] | Monto: [@CURRENCY] [@TOTAL_ORDEN].', 1);
GO
