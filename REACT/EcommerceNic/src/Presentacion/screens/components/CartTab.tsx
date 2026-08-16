import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  Image,
  Platform,
} from 'react-native';
import { formatCurrency } from '../constants';
import { Product } from '../../../Domain/entities/Product';
import { CartItem } from '../../../Domain/entities/CartItem';
import { CustomAlertModal } from '../../components/CustomAlertModal';
import { API_CONFIG } from '../../../Data/dataSources/apiConfig';

/**
 * Interfaz de TypeScript que coincide exactamente con el JSON del backend SQL Server / C# API
 */
export interface DetalleCarrito {
  DetalleCarritoId: number;
  ProductoNombre: string;
  ProductoImagenUrl?: string;
  PrecioUnitario: number;
  Cantidad: number;
  SubTotalFila?: number;
  [key: string]: any;
}

interface CartTabProps {
  cartItems?: CartItem[];
  products?: Product[];
  extraProducts?: Product[];
  cartQuantities?: { [key: string]: number };
  pendingCartActions?: { [key: string]: boolean };
  addUnit: (id: string, item?: CartItem) => void;
  removeUnit: (id: string, item?: CartItem) => void;
  deleteFromCart: (id: string, item?: CartItem) => void;
  setCurrentTab: (tab: 'home' | 'cart' | 'chatbot' | 'nosotros') => void;
  openPaymentModal: () => void;
  totalItemsInCart: number;
}

export const CartTab = ({
  cartItems = [],
  products = [],
  extraProducts = [],
  cartQuantities = {},
  pendingCartActions = {},
  addUnit,
  removeUnit,
  deleteFromCart,
  setCurrentTab,
  openPaymentModal,
  totalItemsInCart,
}: CartTabProps) => {
  // Estado para controlar el modal de alerta elegante reutilizable
  const [alertaModal, setAlertaModal] = useState<{
    visible: boolean;
    itemKey?: string;
    item?: CartItem;
    nombreProducto?: string;
  }>({ visible: false });

  // Si cartItems contiene elementos de la API C#, usarlos directamente
  let effectiveCartItems: CartItem[] = [];

  if (cartItems && cartItems.length > 0) {
    const activeItems = cartItems.filter(item => {
      const qty = item.Cantidad ?? item.cantidad ?? 0;
      const status = item.cartDetailStatusId;
      return qty > 0 && status !== 0 && status !== false;
    });

    const uniqueMap = new Map<number, CartItem>();
    activeItems.forEach(item => {
      const vId = item.varianteId || item.productoId || (item.DetalleCarritoId ?? item.detalleCarritoId ?? 0);
      if (!uniqueMap.has(vId)) {
        uniqueMap.set(vId, item);
      } else {
        const existing = uniqueMap.get(vId)!;
        const exId = existing.DetalleCarritoId ?? existing.detalleCarritoId ?? 0;
        const curId = item.DetalleCarritoId ?? item.detalleCarritoId ?? 0;
        if (curId > exId) {
          uniqueMap.set(vId, item);
        }
      }
    });
    effectiveCartItems = Array.from(uniqueMap.values());
  } else {
    // Fallback: mapear desde productos + cartQuantities
    const cartProductsMap = new Map<string, Product>();
    [...products, ...extraProducts].forEach((p) => {
      if (p && p.id && !cartProductsMap.has(p.id)) {
        cartProductsMap.set(p.id, p);
      }
    });
    const cartProducts = Array.from(cartProductsMap.values());
    effectiveCartItems = cartProducts
      .filter(p => (cartQuantities[p.id] || 0) > 0)
      .map(p => {
        const qty = cartQuantities[p.id] || 0;
        const pId = parseInt(p.id, 10) || 0;
        return {
          DetalleCarritoId: pId,
          detalleCarritoId: pId,
          varianteId: pId,
          productoId: pId,
          ProductoNombre: p.title,
          productoNombre: p.title,
          ProductoImagenUrl: p.image,
          productoImagenUrl: p.image,
          PrecioUnitario: p.numericPrice,
          precioUnitario: p.numericPrice,
          Cantidad: qty,
          cantidad: qty,
          SubTotalFila: p.numericPrice * qty,
          subTotalFila: p.numericPrice * qty,
        };
      });
  }

  // Cálculo de Subtotal y Envío basado en los datos reales del backend (SubTotalFila o PrecioUnitario * Cantidad)
  const subtotal = effectiveCartItems.reduce((acc, item) => {
    const itemSubtotal = item.SubTotalFila ?? item.subTotalFila ?? ((item.PrecioUnitario ?? item.precioUnitario ?? 0) * (item.Cantidad ?? item.cantidad ?? 0));
    return acc + itemSubtotal;
  }, 0);

  const shippingCost = subtotal > 0 ? 350 : 0;
  const totalPayment = subtotal + shippingCost;
  const totalItemsCount = effectiveCartItems.reduce((acc, item) => acc + (item.Cantidad ?? item.cantidad ?? 0), 0) || totalItemsInCart;

  const handleIncrement = (item: CartItem) => {
    const detailId = item.DetalleCarritoId ?? item.detalleCarritoId;
    const itemKey = (item.varianteId || item.productoId || detailId).toString();
    addUnit(itemKey, item);
  };

  /**
   * Manejo del botón "-" con bifurcación:
   * - Si Cantidad > 1: Petición PUT al endpoint actualizar (removeUnit)
   * - Si Cantidad === 1: Muestra CustomAlertModal elegante de eliminación
   */
  const handleDecrement = (item: CartItem) => {
    const detailId = item.DetalleCarritoId ?? item.detalleCarritoId;
    const currentQuantity = item.Cantidad ?? item.cantidad ?? 0;
    const itemKey = (item.varianteId || item.productoId || detailId).toString();
    const name = item.ProductoNombre ?? item.productoNombre ?? 'Producto';

    if (currentQuantity > 1) {
      removeUnit(itemKey, item);
    } else if (currentQuantity === 1) {
      setAlertaModal({
        visible: true,
        itemKey,
        item,
        nombreProducto: name,
      });
    }
  };

  return (
    <View style={styles.tabContent}>
      <View style={styles.cartHeader}>
        <TouchableOpacity style={styles.backButton} onPress={() => setCurrentTab('chatbot')}>
          <Text style={styles.backButtonText}>←</Text>
        </TouchableOpacity>
        <Text style={styles.cartHeaderTitle}>Tu Carrito</Text>
        <View style={styles.itemsCountBadge}>
          <Text style={styles.itemsCountText}>{totalItemsCount} items</Text>
        </View>
      </View>

      <CustomAlertModal
        visible={alertaModal.visible}
        tipo="eliminacion"
        titulo="¿Eliminar producto del carrito?"
        mensaje={`El producto "${alertaModal.nombreProducto || ''}" será removido completamente de tu lista.`}
        textoConfirmar="Sí, Eliminar"
        textoCancelar="Cancelar"
        alConfirmar={() => {
          if (alertaModal.itemKey) {
            deleteFromCart(alertaModal.itemKey, alertaModal.item);
          }
        }}
        alCancelar={() => setAlertaModal({ visible: false })}
        alCerrar={() => setAlertaModal({ visible: false })}
      />

      {effectiveCartItems.length === 0 ? (
        <View style={styles.emptyCartContainer}>
          <View style={styles.emptyCartIconBackground}>
            <Text style={styles.emptyTextEmoji}>🛒</Text>
          </View>
          <Text style={styles.emptyTextTitle}>Tu carrito está vacío</Text>
          <Text style={styles.emptyTextSub}>¡Agrega productos del catálogo para habilitar el pago!</Text>
          <TouchableOpacity style={styles.returnButton} onPress={() => setCurrentTab('chatbot')}>
            <Text style={styles.returnButtonText}>Volver al Chatbot</Text>
          </TouchableOpacity>
        </View>
      ) : (
        <>
          <FlatList<CartItem>
            data={effectiveCartItems}
            keyExtractor={(item, index) => `${item.DetalleCarritoId ?? item.detalleCarritoId ?? item.varianteId ?? index}-${index}`}
            renderItem={({ item }) => {
              const detailId = item.DetalleCarritoId ?? item.detalleCarritoId;
              const name = item.ProductoNombre ?? item.productoNombre ?? 'Producto';
              const rawImg = item.ProductoImagenUrl ?? item.productoImagenUrl ?? (item as any).image;
              const imageUri = rawImg && typeof rawImg === 'string' && !rawImg.startsWith('http')
                ? `${API_CONFIG.BASE_URL}${rawImg.startsWith('/') ? '' : '/'}${rawImg}`
                : (rawImg || 'https://placehold.co/300x300/png?text=Producto');
              const unitPrice = item.PrecioUnitario ?? item.precioUnitario ?? 0;
              const quantity = item.Cantidad ?? item.cantidad ?? 0;
              const subtotalFila = item.SubTotalFila ?? item.subTotalFila ?? (unitPrice * quantity);
              const itemKey = (item.varianteId || item.productoId || detailId).toString();
              const isPending = !!pendingCartActions[itemKey] || !!pendingCartActions[String(detailId)];

              return (
                <View style={styles.cartItemCard}>
                  <Image 
                    source={{ uri: imageUri }} 
                    style={styles.cartItemImage} 
                  />
                  <View style={styles.cartItemDetails}>
                    <View style={styles.cartItemRowHeader}>
                      <Text style={styles.cartItemBrand}>NIC STORE</Text>
                      <TouchableOpacity 
                        style={[styles.trashBtn, isPending && { opacity: 0.5 }]} 
                        onPress={() => {
                          setAlertaModal({
                            visible: true,
                            itemKey,
                            item,
                            nombreProducto: name,
                          });
                        }} 
                        disabled={isPending}
                        hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
                      >
                        <Text style={styles.deleteTrashIcon}>🗑️</Text>
                      </TouchableOpacity>
                    </View>
                    
                    <Text style={styles.cartItemTitle} numberOfLines={1}>
                      {name}
                    </Text>
                    
                    <Text style={styles.cartItemSubtitle} numberOfLines={1}>
                      {item.varianteEspecificacion || item.productoDescripcion || `Subtotal: ${formatCurrency(subtotalFila)}`}
                    </Text>
                    
                    <View style={styles.cartItemRowFooter}>
                      <Text style={styles.cartItemPrice}>
                        {formatCurrency(unitPrice)}
                      </Text>
                      
                      <View style={styles.cartQtyRow}>
                        <TouchableOpacity 
                          style={[styles.inlineQtyBtn, isPending && { opacity: 0.5 }]} 
                          onPress={() => handleDecrement(item)}
                          disabled={isPending}
                        >
                          <Text style={styles.inlineQtyText}>-</Text>
                        </TouchableOpacity>
                        
                        <Text style={styles.inlineQtyNumber}>{quantity}</Text>
                        
                        <TouchableOpacity 
                          style={[styles.inlineQtyBtnPlus, isPending && { opacity: 0.5 }]} 
                          onPress={() => handleIncrement(item)}
                          disabled={isPending}
                        >
                          <Text style={styles.inlineQtyTextPlus}>+</Text>
                        </TouchableOpacity>
                      </View>
                    </View>
                  </View>
                </View>
              );
            }}
            showsVerticalScrollIndicator={false}
            style={styles.cartItemsList}
          />

          {/* Premium Resumen de Pago */}
          <View style={styles.checkoutFooterCard}>
            <View style={styles.checkoutSummaryRow}>
              <Text style={styles.summaryLabel}>Subtotal</Text>
              <Text style={styles.summaryValue}>{formatCurrency(subtotal)}</Text>
            </View>
            <View style={styles.checkoutSummaryRow}>
              <Text style={styles.summaryLabel}>Envío a Managua</Text>
              <Text style={styles.summaryValue}>{formatCurrency(shippingCost)}</Text>
            </View>
            <View style={styles.dividerLine} />
            <View style={styles.checkoutSummaryRow}>
              <Text style={styles.totalLabel}>Total</Text>
              <Text style={styles.totalValue}>{formatCurrency(totalPayment)}</Text>
            </View>
            <TouchableOpacity style={styles.payButton} activeOpacity={0.8} onPress={openPaymentModal}>
              <Text style={styles.payButtonText}>Proceder al Pago →</Text>
            </TouchableOpacity>
          </View>
        </>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  tabContent: { flex: 1, paddingBottom: 0 },
  cartHeader: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: 20, paddingTop: 12, marginBottom: 8 },
  backButton: { width: 38, height: 38, backgroundColor: '#FFFFFF', borderRadius: 12, justifyContent: 'center', alignItems: 'center', borderWidth: 1.5, borderColor: '#F1F5F9' },
  backButtonText: { fontSize: 18, fontWeight: '700', color: '#0F172A' },
  cartHeaderTitle: { flex: 1, textAlign: 'center', fontSize: 18, fontWeight: '900', color: '#0F172A', marginLeft: 16, marginRight: 16 },
  itemsCountBadge: { backgroundColor: '#EEF2FF', paddingHorizontal: 12, paddingVertical: 6, borderRadius: 10 },
  itemsCountText: { color: '#4F46E5', fontSize: 12, fontWeight: '800' },
  cartItemsList: { paddingHorizontal: 20, flex: 1, marginBottom: 4 },
  cartItemCard: { 
    flexDirection: 'row', 
    backgroundColor: '#FFFFFF', 
    borderRadius: 20, 
    padding: 12, 
    marginBottom: 12, 
    borderWidth: 1, 
    borderColor: '#F1F5F9',
    ...Platform.select({
      ios: {
        shadowColor: '#0F172A',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.02,
        shadowRadius: 10,
      },
      android: {
        elevation: 1,
      },
      default: {
        shadowColor: '#0F172A',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.02,
        shadowRadius: 10,
      }
    }),
  },
  cartItemImage: { width: 75, height: 75, borderRadius: 14, backgroundColor: '#F8FAFC' },
  cartItemDetails: { flex: 1, marginLeft: 14, justifyContent: 'space-between' },
  cartItemRowHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  cartItemBrand: { backgroundColor: '#F1F5F9', color: '#64748B', fontSize: 9, fontWeight: '800', paddingHorizontal: 6, paddingVertical: 2, borderRadius: 5, letterSpacing: 0.5 },
  trashBtn: {
    width: 26,
    height: 26,
    borderRadius: 6,
    backgroundColor: '#FEF2F2',
    justifyContent: 'center',
    alignItems: 'center',
  },
  deleteTrashIcon: { fontSize: 12 },
  cartItemTitle: { fontSize: 14, fontWeight: '800', color: '#0F172A', marginTop: 4 },
  cartItemSubtitle: { fontSize: 11, color: '#64748B', marginTop: 1 },
  cartItemRowFooter: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginTop: 6 },
  cartItemPrice: { fontSize: 14, fontWeight: '900', color: '#4F46E5' },
  cartQtyRow: { 
    flexDirection: 'row', 
    alignItems: 'center', 
    backgroundColor: '#EEF2FF', 
    borderRadius: 12, 
    padding: 3 
  },
  inlineQtyBtn: { 
    width: 22, 
    height: 22, 
    backgroundColor: '#FFFFFF', 
    borderRadius: 8, 
    justifyContent: 'center', 
    alignItems: 'center' 
  },
  inlineQtyBtnPlus: { 
    width: 22, 
    height: 22, 
    backgroundColor: '#4F46E5', 
    borderRadius: 8, 
    justifyContent: 'center', 
    alignItems: 'center' 
  },
  inlineQtyText: { fontSize: 12, color: '#4F46E5', fontWeight: '800' },
  inlineQtyTextPlus: { fontSize: 12, color: '#FFFFFF', fontWeight: '800' },
  inlineQtyNumber: { fontSize: 12, fontWeight: '800', color: '#4F46E5', paddingHorizontal: 8 },
  
  checkoutFooterCard: { 
    backgroundColor: 'rgba(255, 255, 255, 0.95)', 
    borderTopLeftRadius: 24, 
    borderTopRightRadius: 24, 
    paddingHorizontal: 20,
    paddingVertical: 14,
    borderTopWidth: 1.5, 
    borderColor: '#EEF2FF', 
    ...Platform.select({
      ios: {
        shadowColor: '#4F46E5',
        shadowOffset: { width: 0, height: -6 },
        shadowOpacity: 0.04,
        shadowRadius: 16,
      },
      android: {
        elevation: 6,
      },
      default: {
        shadowColor: '#4F46E5',
        shadowOffset: { width: 0, height: -6 },
        shadowOpacity: 0.04,
        shadowRadius: 16,
      }
    }),
  },
  checkoutSummaryRow: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 6 },
  summaryLabel: { fontSize: 13, color: '#64748B', fontWeight: '600' },
  summaryValue: { fontSize: 14, fontWeight: '800', color: '#0F172A' },
  dividerLine: { height: 1.5, backgroundColor: '#EEF2FF', marginVertical: 6 },
  totalLabel: { fontSize: 15, fontWeight: '900', color: '#0F172A' },
  totalValue: { fontSize: 20, fontWeight: '900', color: '#4F46E5' },
  payButton: { 
    backgroundColor: '#4F46E5', 
    height: 46, 
    borderRadius: 20, 
    justifyContent: 'center', 
    alignItems: 'center', 
    marginTop: 10,
    ...Platform.select({
      ios: {
        shadowColor: '#4F46E5',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.2,
        shadowRadius: 8,
      },
      android: {
        elevation: 4,
      },
    }),
  },
  payButtonText: { color: '#FFFFFF', fontSize: 15, fontWeight: '800' },
  emptyCartContainer: { flex: 1, justifyContent: 'center', alignItems: 'center', paddingHorizontal: 40, marginTop: 40 },
  emptyCartIconBackground: {
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: '#EEF2FF',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 20,
  },
  emptyTextEmoji: { fontSize: 36 },
  emptyTextTitle: { fontSize: 18, fontWeight: '800', color: '#0F172A' },
  emptyTextSub: { fontSize: 13, color: '#64748B', textAlign: 'center', marginTop: 6, marginBottom: 24, lineHeight: 18 },
  returnButton: { backgroundColor: '#EEF2FF', paddingHorizontal: 24, height: 40, borderRadius: 20, justifyContent: 'center' },
  returnButtonText: { color: '#4F46E5', fontSize: 13, fontWeight: '800' },
});
