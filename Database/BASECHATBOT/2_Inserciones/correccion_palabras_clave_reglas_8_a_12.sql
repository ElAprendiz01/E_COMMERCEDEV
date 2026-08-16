USE [DB_EcommerceAgent];
GO

-- ============================================================================
-- SCRIPT DE CORRECCIÓN Y ALINEACIÓN DE PALABRAS CLAVE PARA TODAS LAS REGLAS
-- ============================================================================

-- 1. Limpiar triggers previamente insertados con desfase
DELETE FROM PalabrasClaveRegla 
WHERE ReglaID IN (3, 7, 8, 9, 10, 11, 12);
GO

-- 2. Insertar Palabras Clave alineadas perfectamente a cada ReglaID
INSERT INTO PalabrasClaveRegla (ReglaID, PalabraClave, Activo)
VALUES 
-- REGLA 3: MÉTODOS DE PAGO (Información estática)
(3, 'metodos de pago', 1),
(3, 'metodo de pago', 1),
(3, 'opciones de pago', 1),
(3, 'formas de pago', 1),
(3, 'como puedo pagar', 1),
(3, 'puedo pagar con', 1),
(3, 'tarjeta', 1),
(3, 'transferencia', 1),
(3, 'efectivo', 1),

-- REGLA 8: AGREGAR CARRITO
(8, 'agregar al carrito', 1),
(8, 'anadir al carrito', 1),
(8, 'añadir al carrito', 1),
(8, 'agregar carrito', 1),
(8, 'anadir carrito', 1),
(8, 'añadir carrito', 1),
(8, 'agregar producto', 1),
(8, 'anadir producto', 1),
(8, 'agregar', 1),
(8, 'anadir', 1),
(8, 'añadir', 1),

-- REGLA 9: CONSULTAR CARRITO
(9, 'ver carrito', 1),
(9, 'mi carrito', 1),
(9, 'consultar carrito', 1),
(9, 'ver mi carrito', 1),
(9, 'carrito', 1),

-- REGLA 10: ELIMINAR PRODUCTO CARRITO / VACIAR
(10, 'eliminar del carrito', 1),
(10, 'quitar del carrito', 1),
(10, 'borrar del carrito', 1),
(10, 'eliminar producto', 1),
(10, 'quitar producto', 1),
(10, 'borrar producto', 1),
(10, 'eliminar', 1),
(10, 'quitar', 1),
(10, 'borrar', 1),
(10, 'vaciar carrito', 1),
(10, 'vaciar mi carrito', 1),
(10, 'limpiar carrito', 1),
(10, 'limpiar mi carrito', 1),

-- REGLA 11: PROCESAR PAGO (Checkout transaccional)
(11, 'procesar pago', 1),
(11, 'finalizar compra', 1),
(11, 'pagar carrito', 1),
(11, 'pagar mi carrito', 1),
(11, 'procesar mi pago', 1),
(11, 'pagar', 1),

-- REGLA 12: CONSULTAR ORDEN
(12, 'estado de mi orden', 1),
(12, 'mi orden', 1),
(12, 'ver pedido', 1),
(12, 'ver mi pedido', 1),
(12, 'rastrear orden', 1),
(12, 'estado orden', 1),
(12, 'consultar orden', 1);
GO

SELECT 
    R.ReglaID, 
    R.NombreRegla, 
    COUNT(P.PalabraClaveID) AS CantidadPalabrasClave
FROM ReglasChatbot R
LEFT JOIN PalabrasClaveRegla P ON R.ReglaID = P.ReglaID AND P.Activo = 1
GROUP BY R.ReglaID, R.NombreRegla
ORDER BY R.ReglaID;
GO
