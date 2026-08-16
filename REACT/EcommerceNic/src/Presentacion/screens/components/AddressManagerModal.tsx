import React, { useState } from 'react';
import {
  Modal,
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  TextInput,
  ScrollView,
  ActivityIndicator,
  Alert,
  Platform,
} from 'react-native';
import { UserAddress } from '../../../Domain/entities/UserAddress';
import { COLORES, ESTILOS_SOMBRA } from '../../theme/theme';

interface Props {
  visible: boolean;
  onClose: () => void;
  direcciones: UserAddress[];
  direccionSeleccionada: UserAddress | null;
  onSeleccionar: (direccion: UserAddress) => void;
  onAgregarDireccion: (descripcion: string, esPrincipal: boolean) => Promise<boolean>;
  onEliminarDireccion: (addressId?: number) => Promise<boolean>;
  cargando: boolean;
}

export const AddressManagerModal: React.FC<Props> = ({
  visible,
  onClose,
  direcciones,
  direccionSeleccionada,
  onSeleccionar,
  onAgregarDireccion,
  onEliminarDireccion,
  cargando,
}) => {
  const [mostrandoFormulario, setMostrandoFormulario] = useState(false);
  const [nuevaDescripcion, setNuevaDescripcion] = useState('');
  const [esPrincipal, setEsPrincipal] = useState(false);
  const [guardando, setGuardando] = useState(false);

  const handleGuardar = async () => {
    if (!nuevaDescripcion || nuevaDescripcion.trim().length < 5) {
      Alert.alert('Dirección Requerida', 'Por favor ingresa una dirección completa (mínimo 5 caracteres).');
      return;
    }

    setGuardando(true);
    const exito = await onAgregarDireccion(nuevaDescripcion, esPrincipal);
    setGuardando(false);

    if (exito) {
      setNuevaDescripcion('');
      setEsPrincipal(false);
      setMostrandoFormulario(false);
      Alert.alert('📍 Dirección Guardada', 'La dirección se ha agregado a tu libreta correctamente.');
    }
  };

  const handleEliminar = async (dir: UserAddress) => {
    if (!dir.userAddressId) return;
    const confirmMsg = `¿Estás seguro de eliminar la dirección:\n"${dir.userAddressDescription}"?`;

    if (Platform.OS === 'web') {
      const confirmado = window.confirm(confirmMsg);
      if (confirmado) {
        await onEliminarDireccion(dir.userAddressId);
      }
    } else {
      Alert.alert(
        'Eliminar Dirección',
        confirmMsg,
        [
          { text: 'Cancelar', style: 'cancel' },
          {
            text: 'Eliminar',
            style: 'destructive',
            onPress: () => onEliminarDireccion(dir.userAddressId),
          },
        ]
      );
    }
  };

  return (
    <Modal visible={visible} animationType="slide" transparent onRequestClose={onClose}>
      <View style={styles.overlay}>
        <View style={styles.modalSheet}>
          <View style={styles.header}>
            <View>
              <Text style={styles.title}>📍 Libreta de Direcciones</Text>
              <Text style={styles.subtitle}>Administra tus puntos de entrega para Nic Store</Text>
            </View>
            <TouchableOpacity style={styles.closeBtn} onPress={onClose}>
              <Text style={styles.closeBtnText}>✕</Text>
            </TouchableOpacity>
          </View>

          {cargando ? (
            <View style={styles.loadingBox}>
              <ActivityIndicator size="large" color={COLORES.primario} />
              <Text style={styles.loadingText}>Cargando direcciones...</Text>
            </View>
          ) : (
            <ScrollView style={styles.content} showsVerticalScrollIndicator={false}>
              {!mostrandoFormulario ? (
                <>
                  <TouchableOpacity
                    style={styles.addBtnHeader}
                    onPress={() => setMostrandoFormulario(true)}
                    activeOpacity={0.8}
                  >
                    <Text style={styles.addBtnText}>➕ Agregar Nueva Dirección de Entrega</Text>
                  </TouchableOpacity>

                  {direcciones.map((dir, idx) => {
                    const isSelected = direccionSeleccionada?.userAddressId === dir.userAddressId ||
                      (direccionSeleccionada?.userAddressDescription === dir.userAddressDescription);

                    return (
                      <TouchableOpacity
                        key={dir.userAddressId || idx}
                        style={[
                          styles.addressCard,
                          isSelected && styles.addressCardSelected,
                          ESTILOS_SOMBRA.tarjeta,
                        ]}
                        onPress={() => {
                          onSeleccionar(dir);
                          onClose();
                        }}
                        activeOpacity={0.85}
                      >
                        <View style={styles.cardRow}>
                          <View style={styles.radioIconContainer}>
                            <Text style={styles.radioIcon}>{isSelected ? '🔘' : '⚪'}</Text>
                          </View>
                          <View style={styles.cardDetails}>
                            <View style={styles.tagRow}>
                              {dir.userAddressIsPrincipal && (
                                <Text style={styles.principalBadge}>⭐ PRINCIPAL</Text>
                              )}
                              <Text style={styles.countryTag}>{dir.countryName || 'Nicaragua 🇳🇮'}</Text>
                            </View>
                            <Text style={styles.addressText}>{dir.userAddressDescription}</Text>
                          </View>

                          <TouchableOpacity
                            style={styles.deleteIconBtn}
                            onPress={() => handleEliminar(dir)}
                          >
                            <Text style={styles.deleteIconText}>🗑️</Text>
                          </TouchableOpacity>
                        </View>
                      </TouchableOpacity>
                    );
                  })}
                </>
              ) : (
                <View style={styles.formContainer}>
                  <Text style={styles.formTitle}>Nueva Dirección de Entrega</Text>
                  <Text style={styles.formLabel}>Descripción Completa / Referencia:</Text>
                  <TextInput
                    style={styles.textInput}
                    placeholder="Ej. Managua - De la Rotonda Centroamérica 2 cuadras al norte, Casa #42"
                    placeholderTextColor="#94A3B8"
                    value={nuevaDescripcion}
                    onChangeText={setNuevaDescripcion}
                    multiline
                    numberOfLines={3}
                  />

                  <TouchableOpacity
                    style={styles.checkboxRow}
                    onPress={() => setEsPrincipal(!esPrincipal)}
                    activeOpacity={0.7}
                  >
                    <Text style={styles.checkboxIcon}>{esPrincipal ? '☑️' : '⏹️'}</Text>
                    <Text style={styles.checkboxLabel}>Establecer como dirección principal de entrega</Text>
                  </TouchableOpacity>

                  <View style={styles.formBtnRow}>
                    <TouchableOpacity
                      style={styles.cancelBtn}
                      onPress={() => setMostrandoFormulario(false)}
                      disabled={guardando}
                    >
                      <Text style={styles.cancelBtnText}>Cancelar</Text>
                    </TouchableOpacity>

                    <TouchableOpacity
                      style={styles.saveBtn}
                      onPress={handleGuardar}
                      disabled={guardando}
                    >
                      {guardando ? (
                        <ActivityIndicator color="#FFFFFF" size="small" />
                      ) : (
                        <Text style={styles.saveBtnText}>💾 Guardar Dirección</Text>
                      )}
                    </TouchableOpacity>
                  </View>
                </View>
              )}
            </ScrollView>
          )}
        </View>
      </View>
    </Modal>
  );
};

const styles = StyleSheet.create({
  overlay: { flex: 1, backgroundColor: 'rgba(15, 23, 42, 0.6)', justifyContent: 'flex-end' },
  modalSheet: { backgroundColor: '#FFFFFF', borderTopLeftRadius: 28, borderTopRightRadius: 28, maxHeight: '85%', paddingBottom: 20 },
  header: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', padding: 20, borderBottomWidth: 1, borderBottomColor: '#F1F5F9' },
  title: { fontSize: 20, fontWeight: '900', color: '#0F172A' },
  subtitle: { fontSize: 13, color: '#64748B', marginTop: 2 },
  closeBtn: { width: 36, height: 36, borderRadius: 18, backgroundColor: '#F1F5F9', justifyContent: 'center', alignItems: 'center' },
  closeBtnText: { fontSize: 16, fontWeight: '800', color: '#64748B' },
  loadingBox: { padding: 40, alignItems: 'center' },
  loadingText: { marginTop: 12, color: '#64748B', fontSize: 14 },
  content: { padding: 20 },
  addBtnHeader: { backgroundColor: '#EEF2FF', paddingVertical: 14, paddingHorizontal: 16, borderRadius: 14, marginBottom: 16, borderStyle: 'dashed', borderWidth: 1, borderColor: '#6366F1' },
  addBtnText: { color: '#4F46E5', fontWeight: '800', fontSize: 14, textAlign: 'center' },
  addressCard: { backgroundColor: '#FFFFFF', borderRadius: 16, padding: 16, marginBottom: 14, borderWidth: 1.5, borderColor: '#F1F5F9' },
  addressCardSelected: { borderColor: '#4F46E5', backgroundColor: '#F8FAFC' },
  cardRow: { flexDirection: 'row', alignItems: 'center' },
  radioIconContainer: { marginRight: 12 },
  radioIcon: { fontSize: 18 },
  cardDetails: { flex: 1 },
  tagRow: { flexDirection: 'row', alignItems: 'center', marginBottom: 4 },
  principalBadge: { backgroundColor: '#FEF3C7', color: '#D97706', fontSize: 10, fontWeight: '800', paddingHorizontal: 6, paddingVertical: 2, borderRadius: 6, marginRight: 6 },
  countryTag: { fontSize: 11, color: '#64748B', fontWeight: '700' },
  addressText: { fontSize: 14, fontWeight: '700', color: '#0F172A', lineHeight: 20 },
  deleteIconBtn: { padding: 8, marginLeft: 8 },
  deleteIconText: { fontSize: 16 },
  formContainer: { backgroundColor: '#F8FAFC', padding: 16, borderRadius: 18, borderWidth: 1, borderColor: '#E2E8F0' },
  formTitle: { fontSize: 16, fontWeight: '900', color: '#0F172A', marginBottom: 12 },
  formLabel: { fontSize: 13, fontWeight: '700', color: '#475569', marginBottom: 6 },
  textInput: { backgroundColor: '#FFFFFF', borderWidth: 1, borderColor: '#CBD5E1', borderRadius: 12, padding: 12, fontSize: 14, color: '#0F172A', textAlignVertical: 'top', minHeight: 80, marginBottom: 14 },
  checkboxRow: { flexDirection: 'row', alignItems: 'center', marginBottom: 18 },
  checkboxIcon: { fontSize: 18, marginRight: 8 },
  checkboxLabel: { fontSize: 13, color: '#334155', fontWeight: '600' },
  formBtnRow: { flexDirection: 'row', justifyContent: 'space-between', gap: 12 },
  cancelBtn: { flex: 1, paddingVertical: 14, borderRadius: 12, backgroundColor: '#E2E8F0', alignItems: 'center' },
  cancelBtnText: { color: '#475569', fontWeight: '800' },
  saveBtn: { flex: 1, paddingVertical: 14, borderRadius: 12, backgroundColor: '#4F46E5', alignItems: 'center' },
  saveBtnText: { color: '#FFFFFF', fontWeight: '800' },
});
