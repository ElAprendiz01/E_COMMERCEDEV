import { useState, useEffect, useCallback } from 'react';
import { Order, OrderDetail } from '../../Domain/entities/Order';
import { User } from '../../Domain/entities/User';
import { Product } from '../../Domain/entities/Product';
import { OrderRemoteDataSource } from '../../Data/dataSources/OrderRemoteDataSource';

const orderDataSource = new OrderRemoteDataSource();
const STORAGE_KEY_ORDERS = 'NIC_STORE_LOCAL_ORDERS_V1';

export const useOrders = (usuario: User, pestañaActual: string, productosCatalogo: Product[] = []) => {
  const [ordenes, setOrdenes] = useState<Order[]>([]);
  const [ordenesLocales, setOrdenesLocales] = useState<Order[]>([]);
  const [cargandoOrdenes, setCargandoOrdenes] = useState<boolean>(false);
  const [ordenSeleccionada, setOrdenSeleccionada] = useState<Order | null>(null);
  const [detallesOrdenSeleccionada, setDetallesOrdenSeleccionada] = useState<OrderDetail[]>([]);
  const [cargandoDetalles, setCargandoDetalles] = useState<boolean>(false);

  const idBruto = parseInt(usuario?.id || '1', 10);
  const idUsuarioNumerico = (isNaN(idBruto) || idBruto <= 0 || idBruto > 2147483647) ? 1 : idBruto;

  const enriquecerImagenDetalle = (det: OrderDetail): OrderDetail => {
    if (det.productImageURL || det.productoImagenUrl) return det;
    const prodEncontrado = productosCatalogo.find(p => {
      const matchVarId = p.productVariableId && det.productVariableId && String(p.productVariableId) === String(det.productVariableId);
      if (matchVarId) return true;
      const nombreP = p.title?.toLowerCase().trim() || '';
      const nombreD = det.productName?.toLowerCase().trim() || '';
      if (!nombreP || !nombreD) return false;
      return nombreP.includes(nombreD) || nombreD.includes(nombreP);
    });

    if (prodEncontrado?.image) {
      return {
        ...det,
        productImageURL: prodEncontrado.image,
        productoImagenUrl: prodEncontrado.image,
      };
    }
    return det;
  };

  // Cargar ordenes locales almacenadas en el navegador al iniciar la aplicación
  useEffect(() => {
    try {
      if (typeof window !== 'undefined' && window.localStorage) {
        const saved = window.localStorage.getItem(STORAGE_KEY_ORDERS);
        if (saved) {
          const parsed: Order[] = JSON.parse(saved);
          if (Array.isArray(parsed) && parsed.length > 0) {
            setOrdenesLocales(parsed);
            setOrdenes(prev => {
              const idsExistentes = new Set(prev.map(o => o.paymentOrderId || o.ordenPagoId));
              const filtrados = parsed.filter(p => !idsExistentes.has(p.paymentOrderId || p.ordenPagoId));
              return [...filtrados, ...prev];
            });
          }
        }
      }
    } catch (e) {
      console.log('Error al cargar compras locales guardadas:', e);
    }
  }, []);

  const cargarOrdenes = useCallback(async () => {
    if (!idUsuarioNumerico) return;
    setCargandoOrdenes(true);
    try {
      console.log('📦 ============================================');
      console.log('📦 [useOrders] CONSULTANDO COMPRAS DE API C# PARA USUARIO ID:', idUsuarioNumerico);
      const result = await orderDataSource.getOrdersByUser(idUsuarioNumerico);
      console.log('📦 [useOrders] Órdenes devueltas por API C# (Total:', result.length, '):');
      result.forEach((ord, i) => {
        console.log(`   #${i + 1} -> Pedido ID: ${ord.orderId ?? ord.paymentOrderId}, Fecha: ${ord.orderDate}, Total: C$ ${ord.totalAmount}, Estado: ${ord.statusName}`);
      });
      console.log('📦 ============================================');

      if (result && result.length > 0) {
        const resultSorted = [...result].sort((a, b) => {
          const idA = a.orderId || a.paymentOrderId || a.ordenPagoId || 0;
          const idB = b.orderId || b.paymentOrderId || b.ordenPagoId || 0;
          return idB - idA;
        });
        setOrdenes(resultSorted);
      } else {
        setOrdenes(prev => {
          const idsExistentes = new Set(result.map(o => o.orderId || o.paymentOrderId || o.ordenPagoId));
          const localesPrevias = prev.filter(o => !idsExistentes.has(o.orderId || o.paymentOrderId || o.ordenPagoId));
          const combinadas = [...localesPrevias, ...result];
          return combinadas.sort((a, b) => {
            const idA = a.orderId || a.paymentOrderId || a.ordenPagoId || 0;
            const idB = b.orderId || b.paymentOrderId || b.ordenPagoId || 0;
            return idB - idA;
          });
        });
      }
    } catch (error) {
      console.log('❌ Error al cargar ordenes del usuario:', error);
    } finally {
      setCargandoOrdenes(false);
    }
  }, [idUsuarioNumerico]);

  // Carga perezosa (Lazy Loading): consultar detalles solo al hacer clic en una orden específica
  const cargarDetallesOrden = async (orden: Order) => {
    setOrdenSeleccionada(orden);
    const orderId = orden.orderId || orden.paymentOrderId || orden.ordenPagoId;
    console.log(`📦 [useOrders] Cargar detalles para Pedido #${orderId}`);

    if (orden.details && orden.details.length > 0) {
      const enriquecidosMemoria = orden.details.map(enriquecerImagenDetalle);
      console.log(`📦 [useOrders] Detalles presentes en memoria (${enriquecidosMemoria.length} artículos):`, enriquecidosMemoria);
      setDetallesOrdenSeleccionada(enriquecidosMemoria);
      return;
    }
    if (!orderId) {
      setDetallesOrdenSeleccionada([]);
      return;
    }

    setCargandoDetalles(true);
    try {
      const detalles = await orderDataSource.getOrderDetails(orderId);
      const enriquecidos = detalles.map(enriquecerImagenDetalle);
      console.log(`📦 [useOrders] Detalles obtenidos de API C# para Pedido #${orderId} (Total: ${enriquecidos.length} artículos):`, enriquecidos);
      setDetallesOrdenSeleccionada(enriquecidos);
    } catch (error) {
      console.log('❌ Error al cargar detalles perezosos de la orden:', error);
      setDetallesOrdenSeleccionada([]);
    } finally {
      setCargandoDetalles(false);
    }
  };

  const registrarOrdenDePago = async (
    totalAmount: number,
    paymentMethodName: string,
    addressText?: string,
    items?: OrderDetail[]
  ) => {
    // Calcular el consecutivo correlativo secuencial (ej: #103, #104, #105...)
    const idsValidos = ordenes
      .map(o => o.paymentOrderId || o.ordenPagoId || 0)
      .filter(id => id > 0 && id < 1000);
    const idSiguiente = idsValidos.length > 0 ? Math.max(...idsValidos) + 1 : (ordenes.length + 101);

    const nuevaOrden = await orderDataSource.createOrder(
      idUsuarioNumerico,
      totalAmount,
      paymentMethodName,
      idSiguiente,
      addressText,
      items
    );

    if (nuevaOrden) {
      setOrdenesLocales(prev => {
        const actualizadas = [nuevaOrden, ...prev];
        try {
          if (typeof window !== 'undefined' && window.localStorage) {
            window.localStorage.setItem(STORAGE_KEY_ORDERS, JSON.stringify(actualizadas));
          }
        } catch (e) {
          console.log('Error al guardar compras en localStorage:', e);
        }
        return actualizadas;
      });
      setOrdenes(prev => [nuevaOrden, ...prev]);
    }
  };

  const cerrarModalDetalle = () => {
    setOrdenSeleccionada(null);
    setDetallesOrdenSeleccionada([]);
  };

  useEffect(() => {
    if (pestañaActual === 'pedidos') {
      cargarOrdenes();
    }
  }, [pestañaActual, cargarOrdenes]);

  return {
    ordenes,
    cargandoOrdenes,
    ordenSeleccionada,
    detallesOrdenSeleccionada,
    cargandoDetalles,
    cargarDetallesOrden,
    cerrarModalDetalle,
    registrarOrdenDePago,
    refetch: cargarOrdenes,
  };
};
