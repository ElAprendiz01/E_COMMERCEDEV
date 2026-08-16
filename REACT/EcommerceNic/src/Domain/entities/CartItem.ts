export interface CartItem {
  DetalleCarritoId: number;
  detalleCarritoId: number;
  carritoId?: number;
  usuarioClienteId?: number;
  varianteId?: number;
  productoId?: number;
  ProductoNombre: string;
  productoNombre: string;
  productoDescripcion?: string;
  varianteEspecificacion?: string;
  ProductoImagenUrl?: string;
  productoImagenUrl?: string;
  PrecioUnitario: number;
  precioUnitario: number;
  Cantidad: number;
  cantidad: number;
  descuentoFila?: number;
  SubTotalFila?: number;
  subTotalFila?: number;
  totalFila?: number;
  monedaISO?: string;
  monedaNombre?: string;
  cartDetailStatusId?: number | boolean;
}
