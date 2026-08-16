import { useState, useEffect, useMemo } from 'react';
import { Alert, Platform } from 'react-native';
import { Product } from '../../Domain/entities/Product';
import { CartItem } from '../../Domain/entities/CartItem';
import { User } from '../../Domain/entities/User';
import {
  getCartByUserUseCase,
  addToCartUseCase,
  updateCartQuantityUseCase,
  deleteCartItemUseCase,
} from '../../di/DI';

export const useCart = (
  usuario: User,
  productosCatalogo: Product[],
  pestañaActual: string
) => {
  const [elementosCarritoBd, setElementosCarritoBd] = useState<CartItem[]>([]);
  const [productosCarritoChatbot, setProductosCarritoChatbot] = useState<Product[]>([]);
  const [accionesPendientesCarrito, setAccionesPendientesCarrito] = useState<{ [key: string]: boolean }>({});
  const [variantesAgotadas, setVariantesAgotadas] = useState<{ [key: string]: boolean }>({});

  const idBruto = parseInt(usuario?.id || '1', 10);
  const idUsuarioNumerico = (isNaN(idBruto) || idBruto <= 0 || idBruto > 2147483647) ? 1 : idBruto;

  // Cargar carrito activo desde C# API (CartDetailsController)
  const cargarCarritoDesdeBd = async () => {
    if (!idUsuarioNumerico) return;
    try {
      console.log('🛒 [useCart] Solicitando carrito a API C# para usuario ID:', idUsuarioNumerico);
      const elementos = await getCartByUserUseCase.execute(idUsuarioNumerico);
      console.log('🛒 [useCart] Respuesta de API C#:', elementos);

      const elementosActivos = (elementos || []).filter(item => {
        const dId = item.DetalleCarritoId ?? item.detalleCarritoId;
        const qty = item.Cantidad ?? item.cantidad ?? 0;
        const status = item.cartDetailStatusId;
        if (!dId || dId <= 0) return false;
        if (qty <= 0) return false;
        if (status !== undefined && status !== null && (status === 0 || status === false)) return false;
        return true;
      });

      // Consolidador / Deduplicador robusto para evitar colisiones
      const mapaItemsUnicos = new Map<number, CartItem>();
      elementosActivos.forEach(item => {
        const vId = item.varianteId || item.productoId || 0;
        if (vId <= 0) return;
        if (!mapaItemsUnicos.has(vId)) {
          mapaItemsUnicos.set(vId, item);
        } else {
          const existente = mapaItemsUnicos.get(vId)!;
          const exId = existente.DetalleCarritoId ?? existente.detalleCarritoId ?? 0;
          const curId = item.DetalleCarritoId ?? item.detalleCarritoId ?? 0;
          if (curId > exId) {
            mapaItemsUnicos.set(vId, item);
          }
        }
      });

      const itemsDeduplicados = Array.from(mapaItemsUnicos.values());
      console.log('🛒 [useCart] Elementos procesados para pantalla:', itemsDeduplicados);
      setElementosCarritoBd(itemsDeduplicados);

      const productosAdicionales: Product[] = [];
      itemsDeduplicados.forEach(item => {
        const vIdVal = item.varianteId || item.productoId || 0;
        if (vIdVal <= 0) return;
        const pId = String(vIdVal);
        productosAdicionales.push({
          id: pId,
          productVariableId: vIdVal,
          title: item.productoNombre || item.ProductoNombre || 'Producto',
          subtitle: item.varianteEspecificacion || item.productoDescripcion || '',
          numericPrice: item.precioUnitario ?? item.PrecioUnitario ?? 0,
          tag: '',
          brand: 'NIC STORE',
          category: 'cart',
          image: item.productoImagenUrl || item.ProductoImagenUrl || 'https://placehold.co/300x300/png?text=Producto',
        });
      });

      setProductosCarritoChatbot(productosAdicionales);
    } catch (error) {
      console.error('Error al cargar el carrito desde la API C#:', error);
      setElementosCarritoBd([]);
      setProductosCarritoChatbot([]);
    }
  };

  useEffect(() => {
    cargarCarritoDesdeBd();
  }, [idUsuarioNumerico, pestañaActual]);

  // Derivación reactiva de cantidades estrictamente por ID de variante
  const cantidadesCarrito = useMemo<{ [key: string]: number }>(() => {
    const mapa: { [key: string]: number } = {};
    elementosCarritoBd.forEach(item => {
      const qty = item.Cantidad ?? item.cantidad ?? 0;
      const status = item.cartDetailStatusId;
      if (item && qty > 0 && status !== 0 && status !== false) {
        const vIdKey = String(item.varianteId || item.productoId || 0);
        if (vIdKey && vIdKey !== '0') {
          mapa[vIdKey] = (mapa[vIdKey] || 0) + qty;
        }
      }
    });
    return mapa;
  }, [elementosCarritoBd]);

  // Helper estricto de coincidencia por variante para evitar colisión de IDs con DetalleCarritoId
  const buscarItemPorVariante = (idStr: string, itemPasado?: CartItem): CartItem | undefined => {
    if (itemPasado) return itemPasado;
    const targetVarId = parseInt(idStr, 10);
    if (isNaN(targetVarId) || targetVarId <= 0) return undefined;

    return elementosCarritoBd.find(item => {
      const curVarId = item.varianteId || item.productoId || 0;
      return curVarId === targetVarId || String(curVarId) === idStr;
    });
  };

  // Incremento optimista de unidades
  const agregarUnidad = async (id: string, itemPasado?: CartItem, cantidadAIncrementar: number = 1) => {
    if (accionesPendientesCarrito[id]) return;
    setAccionesPendientesCarrito(prev => ({ ...prev, [id]: true }));

    const idObjetivo = parseInt(id, 10);
    const itemExistente = buscarItemPorVariante(id, itemPasado);

    const idDetalle = itemExistente?.DetalleCarritoId ?? itemExistente?.detalleCarritoId ?? 0;
    const cantidadActual = itemExistente?.Cantidad ?? itemExistente?.cantidad ?? 0;
    const cantidadSiguiente = cantidadActual + cantidadAIncrementar;

    // Actualización optimista del estado local
    if (itemExistente) {
      setElementosCarritoBd(prev => prev.map(item => {
        const curVarId = item.varianteId || item.productoId || 0;
        if (curVarId === idObjetivo || String(curVarId) === id) {
          const precioUnitario = item.PrecioUnitario ?? item.precioUnitario ?? 0;
          return {
            ...item,
            Cantidad: cantidadSiguiente,
            cantidad: cantidadSiguiente,
            SubTotalFila: precioUnitario * cantidadSiguiente,
            subTotalFila: precioUnitario * cantidadSiguiente,
          };
        }
        return item;
      }));
    } else {
      const productoCoincidente = productosCatalogo.find(p => p.id === id) ||
        productosCarritoChatbot.find(p => p.id === id);
      const varId = productoCoincidente?.productVariableId || idObjetivo;
      const precioUnit = productoCoincidente?.numericPrice || 0;
      const itemTemporal: CartItem = {
        DetalleCarritoId: 9999000 + Math.floor(Math.random() * 1000),
        detalleCarritoId: 9999000 + Math.floor(Math.random() * 1000),
        varianteId: varId,
        productoId: varId,
        ProductoNombre: productoCoincidente?.title || 'Producto',
        productoNombre: productoCoincidente?.title || 'Producto',
        ProductoImagenUrl: productoCoincidente?.image,
        productoImagenUrl: productoCoincidente?.image,
        PrecioUnitario: precioUnit,
        precioUnitario: precioUnit,
        Cantidad: cantidadSiguiente,
        cantidad: cantidadSiguiente,
        SubTotalFila: precioUnit * cantidadSiguiente,
        subTotalFila: precioUnit * cantidadSiguiente,
        cartDetailStatusId: 1,
      };
      setElementosCarritoBd(prev => [...prev, itemTemporal]);
    }

    try {
      if (itemExistente && idDetalle > 0 && idDetalle < 9000000) {
        await updateCartQuantityUseCase.execute(idDetalle, cantidadSiguiente, idUsuarioNumerico);
      } else {
        const productoCoincidente = productosCatalogo.find(p => p.id === id) ||
          productosCarritoChatbot.find(p => p.id === id);
        const varId = productoCoincidente?.productVariableId || idObjetivo;
        const res = await addToCartUseCase.execute(idUsuarioNumerico, varId, cantidadSiguiente);
        if (typeof res === 'number' && res > 0) {
          setElementosCarritoBd(prev => prev.map(item => {
            const curVarId = item.varianteId || item.productoId || 0;
            if (curVarId === varId || String(curVarId) === String(varId) || String(curVarId) === id) {
              return { ...item, DetalleCarritoId: res, detalleCarritoId: res };
            }
            return item;
          }));
          await cargarCarritoDesdeBd();
        }
      }
    } catch (error: any) {
      if (error?.message && error.message.includes('no está activo')) {
        setElementosCarritoBd(prev => prev.filter(item => (item.DetalleCarritoId !== idDetalle && item.detalleCarritoId !== idDetalle)));
        try {
          const productoCoincidente = productosCatalogo.find(p => p.id === id) ||
            productosCarritoChatbot.find(p => p.id === id);
          const varId = productoCoincidente?.productVariableId || idObjetivo;
          const res = await addToCartUseCase.execute(idUsuarioNumerico, varId, cantidadSiguiente);
          if (typeof res === 'number' && res > 0) {
            setElementosCarritoBd(prev => prev.map(item => {
              const curVarId = item.varianteId || item.productoId || 0;
              if (curVarId === varId || String(curVarId) === String(varId) || String(curVarId) === id) {
                return { ...item, DetalleCarritoId: res, detalleCarritoId: res };
              }
              return item;
            }));
          }
        } catch (retryErr) {
          console.error('Error en auto-recurso:', retryErr);
        }
      } else {
        const productoCoincidente = productosCatalogo.find(p => p.id === id) || productosCarritoChatbot.find(p => p.id === id);
        const varId = productoCoincidente?.productVariableId || idObjetivo;
        setVariantesAgotadas(prev => ({
          ...prev,
          [String(id)]: true,
          [String(varId)]: true,
          [String(idObjetivo)]: true,
        }));
        const mensajeError = error?.message || 'Stock insuficiente o error al actualizar el carrito.';
        if (Platform.OS === 'web') {
          window.alert(`⚠️ Talla Agotada:\n${mensajeError}\n\nHaz clic en "Ver opciones" para elegir otra talla disponible.`);
        } else {
          Alert.alert('⚠️ Talla Agotada', `${mensajeError}\n\nHaz clic en "Ver opciones" para elegir otra talla disponible.`);
        }
      }
    } finally {
      setAccionesPendientesCarrito(prev => ({ ...prev, [id]: false }));
    }
  };

  const agregarProductoAlCarrito = async (producto: any, cantidadManual?: number) => {
    const rawId = producto?.productVariableId ?? producto?.ProductVariableID ?? producto?.ProductVariableId ?? producto?.ProductID ?? producto?.ProductId ?? producto?.id;
    const varIdNumerico = Number(rawId || 0);

    if (!varIdNumerico || isNaN(varIdNumerico) || varIdNumerico <= 0) {
      console.error('❌ ID de producto no válido recibido:', producto);
      throw new Error('El producto no contiene un ID de variante válido para registrarse en el carrito.');
    }

    const cantidadFinal = cantidadManual || producto?.quantity || producto?.Cantidad || 1;
    console.log(`🛒 [agregarProductoAlCarrito] Insertando en C# API con productVariableId: ${varIdNumerico}, cantidad: ${cantidadFinal}, userId: ${idUsuarioNumerico}`);
    await agregarUnidad(varIdNumerico.toString(), undefined, cantidadFinal);
  };

  // Decremento optimista de unidades
  const removerUnidad = async (id: string, itemPasado?: CartItem) => {
    if (accionesPendientesCarrito[id]) return;
    setAccionesPendientesCarrito(prev => ({ ...prev, [id]: true }));

    const idObjetivo = parseInt(id, 10);
    const itemExistente = buscarItemPorVariante(id, itemPasado);

    if (!itemExistente) {
      setAccionesPendientesCarrito(prev => ({ ...prev, [id]: false }));
      return;
    }

    const idDetalle = itemExistente.DetalleCarritoId ?? itemExistente.detalleCarritoId ?? 0;
    const cantidadActual = itemExistente.Cantidad ?? itemExistente.cantidad ?? 0;
    const cantidadSiguiente = cantidadActual - 1;

    if (idDetalle > 0 && cantidadActual > 1) {
      setElementosCarritoBd(prev => prev.map(item => {
        const curVarId = item.varianteId || item.productoId || 0;
        if (curVarId === idObjetivo || String(curVarId) === id) {
          const precioUnitario = item.PrecioUnitario ?? item.precioUnitario ?? 0;
          return {
            ...item,
            Cantidad: cantidadSiguiente,
            cantidad: cantidadSiguiente,
            SubTotalFila: precioUnitario * cantidadSiguiente,
            subTotalFila: precioUnitario * cantidadSiguiente,
          };
        }
        return item;
      }));

      try {
        await updateCartQuantityUseCase.execute(idDetalle, cantidadSiguiente, idUsuarioNumerico);
      } catch (error: any) {
        if (error?.message && error.message.includes('no está activo')) {
          setElementosCarritoBd(prev => prev.filter(item => (item.DetalleCarritoId !== idDetalle && item.detalleCarritoId !== idDetalle)));
        }
      } finally {
        setAccionesPendientesCarrito(prev => ({ ...prev, [id]: false }));
      }
    } else if (itemExistente) {
      setElementosCarritoBd(prev => prev.filter(item => {
        const curVarId = item.varianteId || item.productoId || 0;
        return curVarId !== idObjetivo && String(curVarId) !== id;
      }));

      try {
        if (idDetalle > 0) {
          await deleteCartItemUseCase.execute(idDetalle, idUsuarioNumerico);
        }
      } catch (error: any) {
        if (error?.message && error.message.includes('no está activo')) {
          setElementosCarritoBd(prev => prev.filter(item => (item.DetalleCarritoId !== idDetalle && item.detalleCarritoId !== idDetalle)));
        }
      } finally {
        setAccionesPendientesCarrito(prev => ({ ...prev, [id]: false }));
      }
    }
  };

  // Eliminación completa de un ítem del carrito
  const eliminarDelCarrito = async (id: string, itemPasado?: CartItem) => {
    if (accionesPendientesCarrito[id]) return;
    setAccionesPendientesCarrito(prev => ({ ...prev, [id]: true }));

    const idObjetivo = parseInt(id, 10);
    const itemExistente = buscarItemPorVariante(id, itemPasado);

    const idDetalle = itemExistente?.DetalleCarritoId ?? itemExistente?.detalleCarritoId ?? itemPasado?.DetalleCarritoId ?? itemPasado?.detalleCarritoId ?? idObjetivo;

    console.log(`🗑️ [eliminarDelCarrito] Ejecutando DELETE /api/CartDetails/${idDetalle}/${idUsuarioNumerico}`);

    // Purga optimista inmediata del estado local
    setElementosCarritoBd(prev => prev.filter(item => {
      const curVarId = item.varianteId || item.productoId || 0;
      return curVarId !== idObjetivo && String(curVarId) !== id;
    }));

    try {
      if (idDetalle > 0) {
        await deleteCartItemUseCase.execute(idDetalle, idUsuarioNumerico);
      }
    } catch (error: any) {
      console.error('Error al eliminar ítem del carrito en el backend:', error);
      await cargarCarritoDesdeBd();
    } finally {
      setAccionesPendientesCarrito(prev => ({ ...prev, [id]: false }));
    }
  };

  // Vaciar carrito por completo
  const vaciarCarrito = async () => {
    try {
      for (const item of elementosCarritoBd) {
        const dId = item.DetalleCarritoId ?? item.detalleCarritoId;
        if (dId) {
          await deleteCartItemUseCase.execute(dId, idUsuarioNumerico);
        }
      }
    } catch (error) {
      console.error('Error al vaciar el carrito:', error);
    } finally {
      await cargarCarritoDesdeBd();
    }
  };

  // Cálculos de totales exactos
  const totalElementosCarrito = elementosCarritoBd.reduce((acc, item) => {
    const qty = item.Cantidad ?? item.cantidad ?? 0;
    const status = item.cartDetailStatusId;
    if (item && qty > 0 && status !== 0 && status !== false) {
      return acc + qty;
    }
    return acc;
  }, 0);

  const mapaTodosProductos = new Map<string, Product>();
  [...productosCatalogo, ...productosCarritoChatbot].forEach(p => {
    if (p && p.id && !mapaTodosProductos.has(p.id)) {
      mapaTodosProductos.set(p.id, p);
    }
  });

  const todosProductosCarrito = Array.from(mapaTodosProductos.values());
  const subtotal = todosProductosCarrito.reduce(
    (acc, p) => acc + (p.numericPrice * (cantidadesCarrito[p.id] || 0)),
    0
  );
  const costoEnvio = subtotal > 0 ? 350 : 0;
  const totalPago = subtotal + costoEnvio;

  return {
    elementosCarritoBd,
    productosCarritoChatbot,
    accionesPendientesCarrito,
    variantesAgotadas,
    cantidadesCarrito,
    totalElementosCarrito,
    subtotal,
    costoEnvio,
    totalPago,
    agregarUnidad,
    removerUnidad,
    eliminarDelCarrito,
    vaciarCarrito,
    agregarProductoAlCarrito,
    cargarCarritoDesdeBd,
  };
};
