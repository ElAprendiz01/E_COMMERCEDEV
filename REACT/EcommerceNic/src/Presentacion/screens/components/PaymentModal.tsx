import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  Modal,
  TouchableOpacity,
  TextInput,
  KeyboardAvoidingView,
  Platform,
  Alert,
  ScrollView,
} from 'react-native';
import { formatCurrency } from '../constants';
import { UserAddress } from '../../../Domain/entities/UserAddress';

interface PaymentModalProps {
  isVisible: boolean;
  onClose: () => void;
  totalPayment: number;
  onPaymentSuccess: (method: string, totalAmount?: number, deliveryAddress?: string) => void;
  direccionSeleccionada?: UserAddress | null;
  direcciones?: UserAddress[];
  onAbrirGestionDirecciones?: () => void;
}

export const PaymentModal = ({
  isVisible,
  onClose,
  totalPayment,
  onPaymentSuccess,
  direccionSeleccionada,
  direcciones = [],
  onAbrirGestionDirecciones,
}: PaymentModalProps) => {
  const [paymentStep, setPaymentStep] = useState<'select' | 'card' | 'transfer' | 'cash'>('select');
  
  // Card form local state
  const [cardNumber, setCardNumber] = useState('');
  const [cardExpiry, setCardExpiry] = useState('');
  const [cardCvv, setCardCvv] = useState('');
  
  // Cash form local state
  const [deliveryAddressText, setDeliveryAddressText] = useState('');

  const resetForm = () => {
    setPaymentStep('select');
    setCardNumber('');
    setCardExpiry('');
    setCardCvv('');
    setDeliveryAddressText('');
  };

  const handleClose = () => {
    resetForm();
    onClose();
  };

  const handleConfirm = (method: string) => {
    if (method === 'Tarjeta') {
      if (cardNumber.replace(/\s/g, '').length < 16) {
        Alert.alert('Número incompleto', 'Ingresá los 16 dígitos de tu tarjeta.');
        return;
      }
      if (!cardExpiry || cardExpiry.length < 5) {
        Alert.alert('Fecha requerida', 'Ingresá la fecha de vencimiento válida (MM/AA).');
        return;
      }
      if (cardCvv.length < 3) {
        Alert.alert('CVV inválido', 'El CVV debe tener 3 dígitos.');
        return;
      }
    }
    
    const direccionFinal = deliveryAddressText.trim() ||
      direccionSeleccionada?.userAddressDescription ||
      'Managua - Dirección de Entrega Principal';

    if (method === 'Efectivo' && !direccionFinal) {
      Alert.alert('Dirección requerida', 'Por favor ingresá o seleccioná una dirección de entrega.');
      return;
    }

    onPaymentSuccess(method, totalPayment, direccionFinal);
    resetForm();
  };

  // Helper formatting for credit card
  const formatCardNumber = (text: string) => {
    const cleaned = text.replace(/\D/g, '');
    const formatted = cleaned.match(/.{1,4}/g)?.join(' ') || cleaned;
    setCardNumber(formatted);
  };

  const formatExpiry = (text: string) => {
    const cleaned = text.replace(/\D/g, '');
    if (cleaned.length >= 2) {
      setCardExpiry(`${cleaned.slice(0, 2)}/${cleaned.slice(2, 4)}`);
    } else {
      setCardExpiry(cleaned);
    }
  };

  const tieneDireccionGuardada = Boolean(deliveryAddressText.trim() || direccionSeleccionada?.userAddressDescription);

  const direccionTextoFinal = deliveryAddressText.trim() ||
    direccionSeleccionada?.userAddressDescription ||
    '';

  return (
    <Modal
      animationType="slide"
      transparent={true}
      visible={isVisible}
      onRequestClose={handleClose}
    >
      <View style={styles.modalOverlay}>
        <KeyboardAvoidingView behavior={Platform.OS === 'ios' ? 'padding' : undefined} style={{ width: '100%' }}>
          <View style={styles.modalContent}>

            {/* PANTALLA: Selección de método */}
            {paymentStep === 'select' && (
              <>
                <View style={styles.modalHeader}>
                  <Text style={styles.modalTitle}>Confirmar y Pagar</Text>
                  <Text style={styles.modalSubtitle}>
                    Total a pagar: <Text style={styles.modalTotalAmount}>{formatCurrency(totalPayment)}</Text>
                  </Text>
                </View>

                {/* Bloque Interactivo de Dirección de Entrega */}
                <TouchableOpacity
                  style={{
                    backgroundColor: tieneDireccionGuardada ? '#F8FAFC' : '#FEF2F2',
                    borderRadius: 16,
                    padding: 14,
                    marginBottom: 16,
                    borderWidth: 1.5,
                    borderColor: tieneDireccionGuardada ? '#6366F1' : '#EF4444',
                  }}
                  onPress={onAbrirGestionDirecciones}
                  activeOpacity={0.8}
                >
                  <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 4 }}>
                    <Text style={{ fontSize: 11, fontWeight: '900', color: tieneDireccionGuardada ? '#4F46E5' : '#DC2626', textTransform: 'uppercase', letterSpacing: 0.5 }}>
                      📍 Dirección de Entrega
                    </Text>
                    <View style={{ backgroundColor: tieneDireccionGuardada ? '#EEF2FF' : '#FEE2E2', paddingHorizontal: 10, paddingVertical: 4, borderRadius: 8 }}>
                      <Text style={{ fontSize: 12, fontWeight: '800', color: tieneDireccionGuardada ? '#4F46E5' : '#EF4444' }}>
                        ⚙️ {tieneDireccionGuardada ? 'Cambiar / Gestionar' : '➕ Seleccionar / Agregar'}
                      </Text>
                    </View>
                  </View>
                  <Text style={{ fontSize: 13, fontWeight: '700', color: tieneDireccionGuardada ? '#0F172A' : '#EF4444' }}>
                    {tieneDireccionGuardada ? direccionTextoFinal : '⚠️ Toca aquí para seleccionar o agregar tu dirección de entrega'}
                  </Text>
                </TouchableOpacity>

                <TouchableOpacity style={styles.paymentOption} onPress={() => setPaymentStep('card')} activeOpacity={0.7}>
                  <View style={[styles.paymentIconBox, { backgroundColor: '#EEF2FF' }]}>
                    <Text style={styles.paymentIconEmoji}>💳</Text>
                  </View>
                  <View style={{ flex: 1 }}>
                    <Text style={styles.paymentMethodName}>Tarjeta de Crédito / Débito</Text>
                    <Text style={styles.paymentMethodDesc}>Paga seguro con Visa o Mastercard</Text>
                  </View>
                  <Text style={styles.arrowIcon}>→</Text>
                </TouchableOpacity>

                <TouchableOpacity style={styles.paymentOption} onPress={() => setPaymentStep('transfer')} activeOpacity={0.7}>
                  <View style={[styles.paymentIconBox, { backgroundColor: '#FEF3C7' }]}>
                    <Text style={styles.paymentIconEmoji}>🏦</Text>
                  </View>
                  <View style={{ flex: 1 }}>
                    <Text style={styles.paymentMethodName}>Transferencia Bancaria</Text>
                    <Text style={styles.paymentMethodDesc}>BAC, LAFISE, Banpro</Text>
                  </View>
                  <Text style={styles.arrowIcon}>→</Text>
                </TouchableOpacity>

                <TouchableOpacity style={styles.paymentOption} onPress={() => setPaymentStep('cash')} activeOpacity={0.7}>
                  <View style={[styles.paymentIconBox, { backgroundColor: '#D1FAE5' }]}>
                    <Text style={styles.paymentIconEmoji}>💵</Text>
                  </View>
                  <View style={{ flex: 1 }}>
                    <Text style={styles.paymentMethodName}>Efectivo Contra Entrega</Text>
                    <Text style={styles.paymentMethodDesc}>Paga al recibir tus productos</Text>
                  </View>
                  <Text style={styles.arrowIcon}>→</Text>
                </TouchableOpacity>

                <TouchableOpacity style={styles.modalCancelBtn} onPress={handleClose} activeOpacity={0.7}>
                  <Text style={styles.modalCancelText}>Cancelar Compra</Text>
                </TouchableOpacity>
              </>
            )}

            {/* PANTALLA: Tarjeta */}
            {paymentStep === 'card' && (
              <>
                <View style={styles.modalHeader}>
                  <TouchableOpacity onPress={() => setPaymentStep('select')} style={styles.backButtonSmall} activeOpacity={0.7}>
                    <Text style={styles.backButtonSmallText}>← Cambiar método</Text>
                  </TouchableOpacity>
                  <Text style={styles.modalTitle}>Pago con Tarjeta</Text>
                  <Text style={styles.modalSubtitle}>
                    Total: <Text style={styles.modalTotalAmount}>{formatCurrency(totalPayment)}</Text>
                  </Text>
                </View>

                {/* Tarjeta de Crédito Visual Premium */}
                <View style={styles.visualCard}>
                  <View style={styles.visualCardHeader}>
                    <View style={styles.visualCardChip} />
                    <Text style={styles.visualCardType}>VISA</Text>
                  </View>
                  <Text style={styles.visualCardNumber}>
                    {cardNumber || '•••• •••• •••• ••••'}
                  </Text>
                  <View style={styles.visualCardFooter}>
                    <View>
                      <Text style={styles.visualCardLabel}>TITULAR</Text>
                      <Text style={styles.visualCardValue}>CLIENTE NIC STORE</Text>
                    </View>
                    <View style={{ marginRight: 20 }}>
                      <Text style={styles.visualCardLabel}>VENCE</Text>
                      <Text style={styles.visualCardValue}>{cardExpiry || 'MM/AA'}</Text>
                    </View>
                    <View>
                      <Text style={styles.visualCardLabel}>CVV</Text>
                      <Text style={styles.visualCardValue}>{cardCvv ? '***' : '•••'}</Text>
                    </View>
                  </View>
                </View>

                <Text style={styles.payFormLabel}>Número de Tarjeta</Text>
                <TextInput
                  style={styles.payFormInput}
                  placeholder="1234 5678 9012 3456"
                  placeholderTextColor="#94A3B8"
                  value={cardNumber}
                  onChangeText={formatCardNumber}
                  keyboardType="numeric"
                  maxLength={19}
                />

                <View style={styles.payFormRow}>
                  <View style={{ flex: 1, marginRight: 8 }}>
                    <Text style={styles.payFormLabel}>Fecha (MM/AA)</Text>
                    <TextInput
                      style={styles.payFormInput}
                      placeholder="12/27"
                      placeholderTextColor="#94A3B8"
                      value={cardExpiry}
                      onChangeText={formatExpiry}
                      keyboardType="numeric"
                      maxLength={5}
                    />
                  </View>
                  <View style={{ flex: 1, marginLeft: 8 }}>
                    <Text style={styles.payFormLabel}>CVV</Text>
                    <TextInput
                      style={styles.payFormInput}
                      placeholder="123"
                      placeholderTextColor="#94A3B8"
                      value={cardCvv}
                      onChangeText={(t) => setCardCvv(t.replace(/\D/g, ''))}
                      keyboardType="numeric"
                      maxLength={3}
                      secureTextEntry
                    />
                  </View>
                </View>

                <TouchableOpacity style={styles.payButton} activeOpacity={0.8} onPress={() => handleConfirm('Tarjeta')}>
                  <Text style={styles.payButtonText}>Confirmar Pago • {formatCurrency(totalPayment)}</Text>
                </TouchableOpacity>
              </>
            )}

            {/* PANTALLA: Transferencia */}
            {paymentStep === 'transfer' && (
              <>
                <View style={styles.modalHeader}>
                  <TouchableOpacity onPress={() => setPaymentStep('select')} style={styles.backButtonSmall} activeOpacity={0.7}>
                    <Text style={styles.backButtonSmallText}>← Cambiar método</Text>
                  </TouchableOpacity>
                  <Text style={styles.modalTitle}>Transferencia Bancaria</Text>
                  <Text style={styles.modalSubtitle}>
                    Monto exacto a transferir: <Text style={styles.modalTotalAmount}>{formatCurrency(totalPayment)}</Text>
                  </Text>
                </View>

                <ScrollView style={{ maxHeight: 180, marginBottom: 12 }} showsVerticalScrollIndicator={false}>
                  <View style={styles.bankInfoCard}>
                    <Text style={styles.bankName}>🏦 BAC Credomatic</Text>
                    <Text style={styles.bankDetail}>Cuenta Corriente C$: <Text style={styles.bankNumber}>365-9012-345</Text></Text>
                    <Text style={styles.bankDetail}>A nombre de: <Text style={styles.bankNumber}>Nic Store S.A.</Text></Text>
                  </View>

                  <View style={styles.bankInfoCard}>
                    <Text style={styles.bankName}>🏦 LAFISE Bancentro</Text>
                    <Text style={styles.bankDetail}>Cuenta Corriente C$: <Text style={styles.bankNumber}>001-7894-4567</Text></Text>
                    <Text style={styles.bankDetail}>A nombre de: <Text style={styles.bankNumber}>Nic Store S.A.</Text></Text>
                  </View>
                </ScrollView>

                <View style={styles.transferNoteContainer}>
                  <Text style={styles.transferNote}>
                    📎 Envía tu comprobante vía WhatsApp al <Text style={{ fontWeight: '800', color: '#B45309' }}>+505 8888 8888</Text> indicando tu número de orden para procesar tu envío.
                  </Text>
                </View>

                <TouchableOpacity style={styles.payButton} activeOpacity={0.8} onPress={() => handleConfirm('Transferencia Bancaria')}>
                  <Text style={styles.payButtonText}>Confirmar Transferencia</Text>
                </TouchableOpacity>
              </>
            )}

            {/* PANTALLA: Efectivo */}
            {paymentStep === 'cash' && (
              <>
                <View style={styles.modalHeader}>
                  <TouchableOpacity onPress={() => setPaymentStep('select')} style={styles.backButtonSmall} activeOpacity={0.7}>
                    <Text style={styles.backButtonSmallText}>← Cambiar método</Text>
                  </TouchableOpacity>
                  <Text style={styles.modalTitle}>Pago Contra Entrega</Text>
                  <Text style={styles.modalSubtitle}>
                    Monto a pagar al recibir: <Text style={styles.modalTotalAmount}>{formatCurrency(totalPayment)}</Text>
                  </Text>
                </View>

                <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 4 }}>
                  <Text style={styles.payFormLabel}>Dirección de Entrega en Nicaragua</Text>
                  {onAbrirGestionDirecciones && (
                    <TouchableOpacity onPress={onAbrirGestionDirecciones}>
                      <Text style={{ fontSize: 12, fontWeight: '800', color: '#4F46E5' }}>⚙️ Cambiar / Libreta</Text>
                    </TouchableOpacity>
                  )}
                </View>

                <TextInput
                  style={[styles.payFormInput, styles.payFormInputMulti]}
                  placeholder="Ej: De donde fue el Cine González 2 cuadras abajo, 1 cuadra al sur. Managua, Nicaragua."
                  placeholderTextColor="#94A3B8"
                  value={deliveryAddressText || direccionSeleccionada?.userAddressDescription || ''}
                  onChangeText={setDeliveryAddressText}
                  multiline
                  numberOfLines={3}
                />

                <View style={styles.transferNoteContainer}>
                  <Text style={styles.transferNote}>
                    ¡Tu pedido llegará muy pronto! El repartidor de Nic Store te entregará en las próximas horas o minutos y te llamará a tu teléfono cuando esté cerca para notificarte.
                  </Text>
                </View>

                <TouchableOpacity style={styles.payButton} activeOpacity={0.8} onPress={() => handleConfirm('Efectivo')}>
                  <Text style={styles.payButtonText}>Confirmar Pedido Contra Entrega</Text>
                </TouchableOpacity>
              </>
            )}

          </View>
        </KeyboardAvoidingView>
      </View>
    </Modal>
  );
};

const styles = StyleSheet.create({
  modalOverlay: { flex: 1, backgroundColor: 'rgba(15, 23, 42, 0.65)', justifyContent: 'flex-end' },
  modalContent: { 
    backgroundColor: '#FFFFFF', 
    borderTopLeftRadius: 28, 
    borderTopRightRadius: 28, 
    padding: 24, 
    paddingBottom: Platform.OS === 'ios' ? 44 : 28, 
    shadowColor: '#000', 
    shadowOffset: { width: 0, height: -10 }, 
    shadowOpacity: 0.08, 
    shadowRadius: 24, 
    elevation: 24 
  },
  modalHeader: { marginBottom: 18 },
  modalTitle: { fontSize: 20, fontWeight: '900', color: '#0F172A', marginBottom: 2 },
  modalSubtitle: { fontSize: 13, color: '#64748B', fontWeight: '600' },
  modalTotalAmount: { color: '#4F46E5', fontWeight: '800', fontSize: 16 },
  
  paymentOption: { 
    flexDirection: 'row', 
    alignItems: 'center', 
    backgroundColor: '#F8FAFC', 
    borderWidth: 1.5, 
    borderColor: '#F1F5F9', 
    borderRadius: 20, 
    padding: 16, 
    marginBottom: 12 
  },
  paymentIconBox: { width: 44, height: 44, backgroundColor: '#FFFFFF', borderRadius: 14, justifyContent: 'center', alignItems: 'center', marginRight: 14, borderWidth: 1.5, borderColor: '#F1F5F9' },
  paymentIconEmoji: { fontSize: 20 },
  paymentMethodName: { fontSize: 14, fontWeight: '800', color: '#0F172A', marginBottom: 2 },
  paymentMethodDesc: { fontSize: 12, color: '#94A3B8', fontWeight: '600' },
  arrowIcon: { fontSize: 16, color: '#94A3B8', fontWeight: '700', marginLeft: 8 },
  
  modalCancelBtn: { marginTop: 12, height: 48, justifyContent: 'center', alignItems: 'center', borderRadius: 24, backgroundColor: '#FEF2F2' },
  modalCancelText: { color: '#EF4444', fontSize: 14, fontWeight: '800' },
  
  backButtonSmall: { marginBottom: 10, alignSelf: 'flex-start' },
  backButtonSmallText: { color: '#4F46E5', fontSize: 13, fontWeight: '800' },
  
  payFormLabel: { fontSize: 12, fontWeight: '800', color: '#334155', marginBottom: 6, marginTop: 12, textTransform: 'uppercase', letterSpacing: 0.5 },
  payFormInput: { 
    backgroundColor: '#F8FAFC', 
    borderWidth: 1.5, 
    borderColor: '#E2E8F0', 
    borderRadius: 14, 
    height: 48, 
    paddingHorizontal: 16, 
    fontSize: 15, 
    color: '#0F172A',
    fontWeight: '500',
    ...Platform.select({
      web: { outlineStyle: 'none' } as any,
    }),
  },
  payFormInputMulti: { height: 75, paddingTop: 12, textAlignVertical: 'top' },
  payFormRow: { flexDirection: 'row', marginTop: 4 },
  
  // Interactive Visual Card
  visualCard: {
    backgroundColor: '#0F172A', // Slate-900 high contrast dark card
    borderRadius: 20,
    padding: 20,
    height: 160,
    marginBottom: 20,
    justifyContent: 'space-between',
    ...Platform.select({
      ios: {
        shadowColor: '#4F46E5',
        shadowOffset: { width: 0, height: 6 },
        shadowOpacity: 0.15,
        shadowRadius: 12,
      },
      android: {
        elevation: 6,
      },
    }),
  },
  visualCardHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  visualCardChip: { width: 34, height: 26, backgroundColor: '#F59E0B', borderRadius: 6, opacity: 0.8 },
  visualCardType: { color: '#FFFFFF', fontSize: 18, fontWeight: '900', fontStyle: 'italic' },
  visualCardNumber: { color: '#FFFFFF', fontSize: 18, fontWeight: '700', letterSpacing: 2, marginVertical: 10, textAlign: 'center' },
  visualCardFooter: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  visualCardLabel: { color: '#64748B', fontSize: 7, fontWeight: '800', letterSpacing: 0.5, marginBottom: 2 },
  visualCardValue: { color: '#FFFFFF', fontSize: 11, fontWeight: '700' },

  bankInfoCard: { backgroundColor: '#F8FAFC', borderRadius: 16, padding: 14, marginBottom: 10, borderWidth: 1.5, borderColor: '#F1F5F9' },
  bankName: { fontSize: 13, fontWeight: '800', color: '#0F172A', marginBottom: 4 },
  bankDetail: { fontSize: 12, color: '#64748B', marginBottom: 1, fontWeight: '500' },
  bankNumber: { color: '#4F46E5', fontWeight: '800' },
  
  transferNoteContainer: {
    backgroundColor: '#FFFBEB',
    borderWidth: 1,
    borderColor: '#FEF3C7',
    borderRadius: 14,
    padding: 12,
    marginTop: 14,
    marginBottom: 6,
  },
  transferNote: { fontSize: 12, color: '#B45309', fontWeight: '600', lineHeight: 18 },
  payButton: { 
    backgroundColor: '#4F46E5', 
    height: 50, 
    borderRadius: 25, 
    justifyContent: 'center', 
    alignItems: 'center', 
    marginTop: 18,
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
  payButtonText: { color: '#FFFFFF', fontSize: 14, fontWeight: '800' },
});
