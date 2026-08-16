import { API_CONFIG, safeFetch } from './apiConfig';
import { Order, OrderDetail } from '../../Domain/entities/Order';

export class OrderRemoteDataSource {
  async getOrdersByUser(userId: number): Promise<Order[]> {
    try {
      const response = await safeFetch<{ codigo: number; msj: string; data: any[] }>(
        `${API_CONFIG.BASE_URL}/api/PaymentOrders/filtrar?userId=${userId}`
      );
      const rawData = response.data || [];
      return rawData.map(item => {
        const idCalculado = Number(item.orderId ?? item.paymentOrderId ?? item.ordenPagoId ?? item.id ?? 0);
        return {
          orderId: idCalculado,
          paymentOrderId: idCalculado,
          ordenPagoId: idCalculado,
          userId: Number(item.userId ?? item.usuarioId ?? userId),
          orderDate: item.orderDate ?? item.fechaOrden ?? item.createdDate ?? new Date().toISOString(),
          statusId: Number(item.statusId ?? item.estadoId ?? 1),
          statusName: item.statusName ?? item.estadoNombre ?? 'Procesando ⏳',
          paymentMethodName: item.paymentMethodName ?? item.metodoPagoNombre ?? 'Efectivo contra entrega',
          addressText: item.addressText ?? item.direccionTexto ?? 'Dirección de Entrega Principal',
          totalAmount: Number(item.totalAmount ?? item.totalOrden ?? item.total ?? 0),
          currencyISO: item.currencyISO ?? item.monedaISO ?? 'USD',
        };
      });
    } catch (error: any) {
      if (error?.message && (error.message.includes('404') || error.message.includes('No se encontraron'))) {
        return [];
      }
      console.log('Info al consultar ordenes del usuario:', error);
      return [];
    }
  }

  async getOrderDetails(orderId: number): Promise<OrderDetail[]> {
    try {
      // Intentar primero con la ruta de filtro por orden
      const response = await safeFetch<{ codigo: number; msj: string; data: any[] }>(
        `${API_CONFIG.BASE_URL}/api/PaymentOrderDetails/filtrar?orderId=${orderId}`
      );
      const rawData = response.data || [];
      return rawData.map(item => ({
        orderDetailId: Number(item.orderDetailId ?? item.paymentOrderDetailId ?? item.detalleOrdenPagoId ?? 0),
        paymentOrderDetailId: Number(item.orderDetailId ?? item.paymentOrderDetailId ?? item.detalleOrdenPagoId ?? 0),
        orderId: Number(item.orderId ?? item.paymentOrderId ?? item.ordenPagoId ?? orderId),
        paymentOrderId: Number(item.orderId ?? item.paymentOrderId ?? item.ordenPagoId ?? orderId),
        productVariableId: Number(item.productVariableId ?? item.varianteId ?? 0),
        productName: item.productName ?? item.productoNombre ?? 'Producto',
        productDescription: item.productDescription ?? item.productoDescripcion ?? '',
        categoryName: item.categoryName,
        subCategoryName: item.subCategoryName,
        markName: item.markName,
        providerName: item.providerName,
        productImageURL: item.productImageURL ?? item.productoImagenUrl,
        price: Number(item.price ?? item.precioUnitario ?? 0),
        quantity: Number(item.quantity ?? item.cantidad ?? 1),
        subTotal: Number(item.subtotal ?? item.subTotal ?? 0),
        tax: Number(item.tax ?? 0),
        total: Number(item.total ?? item.totalFila ?? 0),
        currencyISO: item.currencyISO ?? item.monedaISO ?? 'USD',
      }));
    } catch (error: any) {
      return [];
    }
  }

  async createOrder(
    userId: number,
    totalAmount: number,
    paymentMethodName: string,
    suggestedId?: number,
    addressText?: string,
    details?: OrderDetail[]
  ): Promise<Order | null> {
    const newId = suggestedId || Math.floor(Math.random() * 8999) + 1000;
    
    const subtotalCalculado = details && details.length > 0
      ? details.reduce((acc, d) => acc + (d.total || (d.price || 0) * (d.quantity || 1)), 0)
      : Math.max(0, totalAmount - 350);

    const shippingFee = totalAmount > subtotalCalculado ? totalAmount - subtotalCalculado : (totalAmount > 0 ? 350 : 0);

    const nuevaOrden: Order = {
      orderId: newId,
      paymentOrderId: newId,
      ordenPagoId: newId,
      userId,
      orderDate: new Date().toISOString(),
      statusId: 1,
      statusName: 'Procesando ⏳',
      paymentMethodName: paymentMethodName || 'Efectivo contra entrega',
      addressText: addressText || 'Managua - Dirección de Entrega Principal',
      subTotal: subtotalCalculado,
      shippingCost: shippingFee,
      totalAmount,
      currencyISO: 'NIO',
      details: details || [],
    };

    try {
      const payload = {
        orderUserId: userId,
        orderDeliveryAddress: 1,
        orderPaymentMethodId: 1,
        orderShipping: shippingFee,
        orderSubtotal: subtotalCalculado,
        orderTotal: totalAmount,
        orderCreatorId: userId,
        orderStatusId: 1,
        subTotal: totalAmount,
        totalAmount: totalAmount,
        orderDate: new Date().toISOString(),
      };

      console.log('📡 [POST /api/PaymentOrders/insertar] Registrando orden de pago:', payload);

      const response = await safeFetch<{ codigo: number; msj: string; templateId?: number }>(
        `${API_CONFIG.BASE_URL}/api/PaymentOrders/insertar`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(payload),
        }
      );

      if (response && response.templateId) {
        nuevaOrden.orderId = response.templateId;
        nuevaOrden.paymentOrderId = response.templateId;
        nuevaOrden.ordenPagoId = response.templateId;
      }
    } catch (error) {
      console.log('📦 Registro cliente activado para la nueva orden:', error);
    }

    return nuevaOrden;
  }
}
