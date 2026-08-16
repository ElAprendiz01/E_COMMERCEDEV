import { API_CONFIG, safeFetch } from './apiConfig';
import { CartItem } from '../../Domain/entities/CartItem';

export class CartRemoteDataSource {
  async getCartByUser(userId: number): Promise<CartItem[]> {
    try {
      const response = await safeFetch<{ codigo: number; msj: string; data: any[] }>(
        `${API_CONFIG.BASE_URL}/api/CartDetails/obtener_carrito_cliente/${userId}`
      );
      const rawData = response.data || [];
      return rawData.map(item => {
        const id = Number(item.detalleCarritoId ?? item.DetalleCarritoId ?? 0);
        const name = String(item.productoNombre ?? item.ProductoNombre ?? '');
        const img = item.productoImagenUrl ?? item.ProductoImagenUrl;
        const price = Number(item.precioUnitario ?? item.PrecioUnitario ?? 0);
        const qty = Number(item.cantidad ?? item.Cantidad ?? 0);
        const subtotal = Number(item.subTotalFila ?? item.SubTotalFila ?? 0);

        return {
          DetalleCarritoId: id,
          detalleCarritoId: id,
          carritoId: Number(item.carritoId ?? item.CarritoId ?? 0),
          usuarioClienteId: Number(item.usuarioClienteId ?? item.UsuarioClienteId ?? 0),
          varianteId: Number(item.varianteId ?? item.VarianteId ?? 0),
          productoId: Number(item.productoId ?? item.ProductoId ?? 0),
          ProductoNombre: name,
          productoNombre: name,
          productoDescripcion: item.productoDescripcion ?? item.ProductoDescripcion,
          varianteEspecificacion: item.varianteEspecificacion ?? item.VarianteEspecificacion,
          ProductoImagenUrl: img,
          productoImagenUrl: img,
          PrecioUnitario: price,
          precioUnitario: price,
          Cantidad: qty,
          cantidad: qty,
          descuentoFila: Number(item.descuentoFila ?? item.DescuentoFila ?? 0),
          SubTotalFila: subtotal,
          subTotalFila: subtotal,
          totalFila: Number(item.totalFila ?? item.TotalFila ?? 0),
          monedaISO: item.monedaISO ?? item.MonedaISO,
          monedaNombre: item.monedaNombre ?? item.MonedaNombre,
          cartDetailStatusId: item.cartDetailStatusId ?? item.CartDetailStatusId ?? item.estadoActivo ?? item.EstadoActivo ?? item.statusId ?? item.StatusId,
        };
      });
    } catch (error: any) {
      if (error?.message && (error.message.includes('404') || error.message.includes('No se encontró'))) {
        return [];
      }
      console.log('Error al obtener carrito del cliente:', error);
      return [];
    }
  }

  async addToCart(userId: number, productVariableId: number, quantity: number = 1): Promise<number | boolean> {
    try {
      const body = {
        userId,
        productVariableId,
        quantity,
        discount: 0,
        creatorId: userId,
        statusId: true,
      };

      const response = await safeFetch<{ codigo: number; msj: string; templateId?: number }>(
        `${API_CONFIG.BASE_URL}/api/CartDetails/insertar`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(body),
        }
      );
      if (response.codigo !== 200 && response.codigo !== 201) {
        throw new Error(response.msj || 'Error al insertar en el carrito');
      }
      return response.templateId ?? true;
    } catch (error) {
      console.log('Error al agregar al carrito via C# API:', error);
      throw error;
    }
  }

  async updateCartQuantity(cartDetailId: number, newQuantity: number, modificatorId: number): Promise<boolean> {
    if (!cartDetailId || cartDetailId <= 0) {
      console.log(`❌ [API UPDATE CANCELADO] ID de detalle de carrito inválido: ${cartDetailId}`);
      throw new Error(`ID de detalle de carrito inválido: ${cartDetailId}`);
    }

    try {
      const body = {
        cartDetailId,
        newQuantity,
        modificatorId,
      };
      console.log('📡 [API PUT /api/CartDetails/actualizar]', body);

      const response = await safeFetch<{ codigo: number; msj: string }>(
        `${API_CONFIG.BASE_URL}/api/CartDetails/actualizar`,
        {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(body),
        }
      );

      console.log('📥 [API PUT RESPONSE]', response);

      if (response.codigo !== 200 || (response.msj && (response.msj.includes('no está activo') || response.msj.includes('no existe')))) {
        throw new Error(response.msj || 'El producto ya no está activo en el carrito.');
      }

      return true;
    } catch (error) {
      console.log('Error al actualizar cantidad via C# API:', error);
      throw error;
    }
  }

  async deleteCartItem(cartDetailId: number, modificatorId: number): Promise<boolean> {
    if (!cartDetailId || cartDetailId <= 0) {
      console.log(`❌ [API DELETE CANCELADO] ID de detalle de carrito inválido: ${cartDetailId}`);
      throw new Error(`ID de detalle de carrito inválido: ${cartDetailId}`);
    }

    try {
      console.log(`📡 [API DELETE /api/CartDetails/${cartDetailId}/${modificatorId}]`);
      const response = await safeFetch<{ codigo: number; msj: string }>(
        `${API_CONFIG.BASE_URL}/api/CartDetails/${cartDetailId}/${modificatorId}`,
        {
          method: 'DELETE',
        }
      );

      console.log('📥 [API DELETE RESPONSE]', response);

      if (response.codigo !== 200 || (response.msj && (response.msj.includes('no está activo') || response.msj.includes('no existe')))) {
        throw new Error(response.msj || 'El producto ya no está activo en el carrito.');
      }

      return true;
    } catch (error) {
      console.log('Error al eliminar del carrito via C# API:', error);
      throw error;
    }
  }
}

export const cartRemoteDataSource = new CartRemoteDataSource();
