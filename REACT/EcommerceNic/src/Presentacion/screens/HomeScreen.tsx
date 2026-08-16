import React, { useState } from 'react';
import { SafeAreaView, StyleSheet, Platform, Alert, StatusBar } from 'react-native';
import { User } from '../../Domain/entities/User';
import { formatCurrency } from './constants';
import { CatalogTab } from './components/CatalogTab';
import { CartTab } from './components/CartTab';
import { ChatbotTab } from './components/ChatbotTab';
import { OrdersTab } from './components/OrdersTab';
import { NosotrosTab } from './components/NosotrosTab';
import { PaymentModal } from './components/PaymentModal';
import { ProductDetailModal } from './components/ProductDetailModal';
import { SidebarHistorial } from '../components/SidebarHistorial';
import { BottomTabBar, TabNombre } from '../components/BottomTabBar';
import { useCatalog } from '../hooks/useCatalog';
import { useCart } from '../hooks/useCart';
import { useChatbot } from '../hooks/useChatbot';
import { useOrders } from '../hooks/useOrders';
import { useUserAddresses } from '../hooks/useUserAddresses';
import { AddressManagerModal } from './components/AddressManagerModal';
import { COLORES } from '../theme/theme';

import { CustomAlertModal } from '../components/CustomAlertModal';

interface Props {
  onLogout: () => void;
  user: User;
}

export const HomeScreen = ({ onLogout, user }: Props) => {
  const [currentTab, setCurrentTab] = useState<TabNombre>('home');
  const [isPaymentModalVisible, setPaymentModalVisible] = useState<boolean>(false);
  const [isAddressModalVisible, setAddressModalVisible] = useState<boolean>(false);
  const [selectedProductId, setSelectedProductId] = useState<number | string | null>(null);
  const [isDetailModalVisible, setDetailModalVisible] = useState<boolean>(false);
  const [alertaAgregarProducto, setAlertaAgregarProducto] = useState<{
    visible: boolean;
    producto?: any;
  }>({ visible: false });

  const [alertaResultado, setAlertaResultado] = useState<{
    visible: boolean;
    tipo: 'exito' | 'advertencia';
    titulo: string;
    mensaje: string;
  }>({
    visible: false,
    tipo: 'exito',
    titulo: '',
    mensaje: '',
  });

  // Custom Hooks Especializados
  const { productos } = useCatalog();
  const cart = useCart(user, productos, currentTab);
  const chatbot = useChatbot(user, cart.agregarProductoAlCarrito);
  const orders = useOrders(user, currentTab, productos);
  const userAddresses = useUserAddresses(user);

  // Manejo de Confirmación de Pago con Registro e Inserción Real en la BD/API
  const handlePaymentSuccess = async (method: string, totalAmountFromModal?: number, addressFromModal?: string) => {
    // 1. Capturar la suma exacta mostrada en el checkout (ej. C$ 3,830)
    const montoTotalPagado = (totalAmountFromModal && totalAmountFromModal > 0)
      ? totalAmountFromModal
      : (cart.totalPago > 0 ? cart.totalPago : 0);

    const direccionFinal = addressFromModal || 'Managua - Dirección de Entrega Principal';

    // 2. Capturar los ítems exactos comprados del carrito con resolución inteligente de fotos
    const itemsComprados = (cart.elementosCarritoBd || []).map(item => {
      const pId = item.varianteId || item.productoId || 0;
      const qty = cart.cantidadesCarrito[pId] || item.cantidad || 1;
      const price = item.precioUnitario || 0;

      const prodEncontrado = productos.find(p => String(p.id) === String(item.productoId) || String(p.productVariableId) === String(pId));
      const rawItem = item as any;
      const img = item.productoImagenUrl || item.ProductoImagenUrl || rawItem.imagenUrl || rawItem.imagen || rawItem.image || prodEncontrado?.image;

      return {
        paymentOrderDetailId: Math.floor(Math.random() * 10000),
        productVariableId: pId,
        productName: item.productoNombre || item.ProductoNombre || prodEncontrado?.title || 'Producto',
        productDescription: item.varianteEspecificacion || item.productoDescripcion || '',
        productImageURL: img,
        productoImagenUrl: img,
        price: price,
        quantity: qty,
        total: price * qty,
        currencyISO: 'NIO',
      };
    });

    setPaymentModalVisible(false);

    // 3. Registrar la compra con dirección, fecha/hora e ítems detallados
    await orders.registrarOrdenDePago(montoTotalPagado, method, direccionFinal, itemsComprados);

    // 4. Vaciar el carrito DESPUÉS de haber guardado la orden
    await cart.vaciarCarrito();

    Alert.alert(
      '¡Pedido Procesado con Éxito!',
      `Monto: ${formatCurrency(montoTotalPagado)}\nMétodo: ${method}\n\n¡Tu pedido va en camino! El repartidor de Nic Store te entregará en las próximas horas o minutos y te llamará a tu teléfono cuando esté cerca.`,
      [{ text: 'Ver Mis Pedidos', onPress: () => setCurrentTab('pedidos') }]
    );
  };

  // Manejo de Cierre de Sesión Multiplataforma
  const handleLogout = () => {
    const ejecutarSalida = () => {
      onLogout();
    };

    if (Platform.OS === 'web') {
      const confirmarWeb = window.confirm('¿Estás seguro que querés salir?');
      if (confirmarWeb) {
        ejecutarSalida();
      }
      return;
    }

    Alert.alert(
      'Cerrar Sesión',
      '¿Estás seguro que querés salir, bro?',
      [
        { text: 'Cancelar', style: 'cancel' },
        { text: 'Sí, Salir', style: 'destructive', onPress: ejecutarSalida },
      ]
    );
  };

  return (
    <SafeAreaView style={styles.container}>
      {/* Modal Elegante 1: Preguntar Confirmación de Adición */}
      <CustomAlertModal
        visible={alertaAgregarProducto.visible}
        tipo="exito"
        titulo="¿Agregar producto al carrito?"
        mensaje={`¿Deseas agregar "${alertaAgregarProducto.producto?.name ?? alertaAgregarProducto.producto?.title ?? 'este producto'}" a tu carrito de compras?`}
        textoConfirmar="Sí, Agregar"
        textoCancelar="Cancelar"
        alConfirmar={async () => {
          const prodTarget = alertaAgregarProducto.producto;
          setAlertaAgregarProducto({ visible: false });
          if (prodTarget) {
            try {
              await cart.agregarProductoAlCarrito(prodTarget);
              console.log("✅ Producto agregado con éxito a la API C#");
              setAlertaResultado({
                visible: true,
                tipo: 'exito',
                titulo: '🛒 ¡Producto Agregado!',
                mensaje: `"${prodTarget.name ?? prodTarget.title ?? 'El producto'}" fue añadido correctamente a tu carrito de compras.`,
              });
            } catch (err: any) {
              console.error("❌ Error al agregar producto:", err);
              setAlertaResultado({
                visible: true,
                tipo: 'advertencia',
                titulo: '⚠️ Error al Agregar',
                mensaje: err.message || 'No se pudo registrar el producto en el carrito.',
              });
            }
          }
        }}
        alCancelar={() => setAlertaAgregarProducto({ visible: false })}
        alCerrar={() => setAlertaAgregarProducto({ visible: false })}
      />

      {/* Modal Elegante 2: Notificar Resultado de la Operación */}
      <CustomAlertModal
        visible={alertaResultado.visible}
        tipo={alertaResultado.tipo}
        titulo={alertaResultado.titulo}
        mensaje={alertaResultado.mensaje}
        textoConfirmar={alertaResultado.tipo === 'exito' ? 'Ver Carrito' : 'Entendido'}
        alConfirmar={() => {
          setAlertaResultado({ ...alertaResultado, visible: false });
          if (alertaResultado.tipo === 'exito') {
            setDetailModalVisible(false);
            setSelectedProductId(null);
            setCurrentTab('cart');
          }
        }}
        alCerrar={() => setAlertaResultado({ ...alertaResultado, visible: false })}
      />

      {/* Vistas según la Pestaña Seleccionada */}
      {currentTab === 'home' && (
        <CatalogTab
          products={productos}
          cartQuantities={cart.cantidadesCarrito}
          variantesAgotadas={cart.variantesAgotadas}
          addUnit={cart.agregarUnidad}
          removeUnit={cart.removerUnidad}
          setCurrentTab={setCurrentTab}
          totalItemsInCart={cart.totalElementosCarrito}
          onSelectProduct={(productId) => {
            setSelectedProductId(productId);
            setDetailModalVisible(true);
          }}
        />
      )}

      {currentTab === 'cart' && (
        <CartTab
          cartItems={cart.elementosCarritoBd}
          products={productos}
          extraProducts={cart.productosCarritoChatbot}
          cartQuantities={cart.cantidadesCarrito}
          pendingCartActions={cart.accionesPendientesCarrito}
          addUnit={cart.agregarUnidad}
          removeUnit={cart.removerUnidad}
          deleteFromCart={cart.eliminarDelCarrito}
          setCurrentTab={setCurrentTab}
          openPaymentModal={() => setPaymentModalVisible(true)}
          totalItemsInCart={cart.totalElementosCarrito}
        />
      )}

      {currentTab === 'chatbot' && (
        <SidebarHistorial
          conversations={chatbot.conversaciones}
          activeConversationId={chatbot.idConversacionActiva}
          onSelectConversation={chatbot.seleccionarConversacion}
          onNewConversation={chatbot.crearNuevaConversacion}
        >
          <ChatbotTab
            messages={chatbot.mensajes}
            conversations={chatbot.conversaciones}
            activeConversationId={chatbot.idConversacionActiva}
            onSelectConversation={chatbot.seleccionarConversacion}
            onNewConversation={chatbot.crearNuevaConversacion}
            sendMessage={chatbot.enviarMensaje}
            isTyping={chatbot.estaEscribiendo}
            products={productos}
            onAddProductToCart={(producto) => {
              setAlertaAgregarProducto({
                visible: true,
                producto,
              });
            }}
            onSelectProduct={(productId) => {
              setSelectedProductId(productId);
              setDetailModalVisible(true);
            }}
          />
        </SidebarHistorial>
      )}

      {currentTab === 'pedidos' && (
        <OrdersTab
          ordenes={orders.ordenes}
          cargandoOrdenes={orders.cargandoOrdenes}
          ordenSeleccionada={orders.ordenSeleccionada}
          detallesOrdenSeleccionada={orders.detallesOrdenSeleccionada}
          cargandoDetalles={orders.cargandoDetalles}
          cargarDetallesOrden={orders.cargarDetallesOrden}
          cerrarModalDetalle={orders.cerrarModalDetalle}
          refetch={orders.refetch}
          setCurrentTab={setCurrentTab}
        />
      )}

      {currentTab === 'nosotros' && (
        <NosotrosTab handleLogout={handleLogout} />
      )}

      {/* Modal de Pago */}
      <PaymentModal
        isVisible={isPaymentModalVisible}
        onClose={() => setPaymentModalVisible(false)}
        totalPayment={cart.totalPago}
        onPaymentSuccess={handlePaymentSuccess}
        direccionSeleccionada={userAddresses.direccionSeleccionada}
        direcciones={userAddresses.direcciones}
        onAbrirGestionDirecciones={() => setAddressModalVisible(true)}
      />

      {/* Modal de Gestión de Libreta de Direcciones */}
      <AddressManagerModal
        visible={isAddressModalVisible}
        onClose={() => setAddressModalVisible(false)}
        direcciones={userAddresses.direcciones}
        direccionSeleccionada={userAddresses.direccionSeleccionada}
        onSeleccionar={userAddresses.seleccionarDireccionActiva}
        onAgregarDireccion={userAddresses.agregarNuevaDireccion}
        onEliminarDireccion={userAddresses.eliminarDireccion}
        cargando={userAddresses.cargandoDirecciones || userAddresses.procesandoAccion}
      />

      {/* Modal de Detalle de Producto por ID */}
      <ProductDetailModal
        visible={isDetailModalVisible}
        productId={selectedProductId}
        cantidadesCarrito={cart.cantidadesCarrito}
        onClose={() => {
          setDetailModalVisible(false);
          setSelectedProductId(null);
        }}
        onGoToCart={() => {
          setDetailModalVisible(false);
          setSelectedProductId(null);
          setCurrentTab('cart');
        }}
        onAddToCart={async (prods) => {
          const listaItems = Array.isArray(prods) ? prods : [prods];
          try {
            for (const item of listaItems) {
              await cart.agregarProductoAlCarrito(item);
            }
            console.log("✅ Productos agregados con éxito a la API C#");
            setAlertaResultado({
              visible: true,
              tipo: 'exito',
              titulo: '🛒 ¡Productos Agregados!',
              mensaje: listaItems.length === 1
                ? `"${listaItems[0].name ?? listaItems[0].title ?? 'El producto'}" fue añadido correctamente a tu carrito de compras.`
                : `Se añadieron ${listaItems.length} opciones distintas (${listaItems.reduce((acc, i) => acc + (i.quantity || 1), 0)} ítems en total) a tu carrito de compras.`,
            });
          } catch (err: any) {
            console.error("❌ Error al agregar productos:", err);
            setAlertaResultado({
              visible: true,
              tipo: 'advertencia',
              titulo: '⚠️ Error al Agregar',
              mensaje: err.message || 'No se pudieron registrar los productos en el carrito.',
            });
          }
        }}
      />

      {/* Componente Modular de Navegación Inferior */}
      <BottomTabBar
        pestañaActual={currentTab}
        alSeleccionarPestaña={setCurrentTab}
        totalElementosCarrito={cart.totalElementosCarrito}
      />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORES.fondo,
    paddingBottom: 60,
    paddingTop: Platform.OS === 'android' ? (StatusBar.currentHeight || 24) : 0,
  },
});