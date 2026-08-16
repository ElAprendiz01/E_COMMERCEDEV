import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  Modal,
  SafeAreaView,
  Platform,
} from 'react-native';
import { COLORES, ESTILOS_SOMBRA } from '../theme/theme';

export type TipoAlerta = 'eliminacion' | 'exito' | 'advertencia' | 'informacion';

export interface PropsAlertaModal {
  visible: boolean;
  tipo: TipoAlerta;
  titulo: string;
  mensaje: string;
  textoConfirmar?: string;
  textoCancelar?: string;
  alConfirmar?: () => void;
  alCancelar?: () => void;
  alCerrar: () => void;
}

export const CustomAlertModal: React.FC<PropsAlertaModal> = ({
  visible,
  tipo,
  titulo,
  mensaje,
  textoConfirmar,
  textoCancelar = 'Cancelar',
  alConfirmar,
  alCancelar,
  alCerrar,
}) => {
  if (!visible) return null;

  // Configuración de colores e íconos por tipo de alerta
  const obtenerConfiguracionTipo = () => {
    switch (tipo) {
      case 'eliminacion':
        return {
          icono: '🗑️',
          fondoIcono: '#FEE2E2',
          colorIcono: '#EF4444',
          colorBotonConfirmar: '#EF4444',
          textoBotonPorDefecto: 'Sí, Eliminar',
        };
      case 'exito':
        return {
          icono: '🛒',
          fondoIcono: '#DBEAFE',
          colorIcono: '#3B82F6',
          colorBotonConfirmar: '#3B82F6',
          textoBotonPorDefecto: 'Aceptar',
        };
      case 'advertencia':
        return {
          icono: '⚠️',
          fondoIcono: '#FEF3C7',
          colorIcono: '#F59E0B',
          colorBotonConfirmar: '#F59E0B',
          textoBotonPorDefecto: 'Entendido',
        };
      case 'informacion':
      default:
        return {
          icono: 'ℹ️',
          fondoIcono: '#DBEAFE',
          colorIcono: '#3B82F6',
          colorBotonConfirmar: '#3B82F6',
          textoBotonPorDefecto: 'Aceptar',
        };
    }
  };

  const config = obtenerConfiguracionTipo();
  const textoBotonConfirmarFinal = textoConfirmar || config.textoBotonPorDefecto;
  const esModoConfirmacion = tipo === 'eliminacion' || !!alCancelar || !!textoCancelar;

  const handleConfirmar = () => {
    if (alConfirmar) {
      alConfirmar();
    }
    alCerrar();
  };

  const handleCancelar = () => {
    if (alCancelar) {
      alCancelar();
    }
    alCerrar();
  };

  return (
    <Modal
      transparent
      visible={visible}
      animationType="fade"
      onRequestClose={alCerrar}
    >
      <View style={styles.contenedorFondoOverlay}>
        <SafeAreaView style={styles.contenedorModalCentrado}>
          <View style={[styles.tarjetaModal, ESTILOS_SOMBRA.tarjeta]}>
            {/* Ícono Ilustrativo */}
            <View style={[styles.circuloIcono, { backgroundColor: config.fondoIcono }]}>
              <Text style={styles.textoIcono}>{config.icono}</Text>
            </View>

            {/* Título y Mensaje */}
            <Text style={styles.tituloModal}>{titulo}</Text>
            <Text style={styles.mensajeModal}>{mensaje}</Text>

            {/* Botones de Acción */}
            <View style={styles.filaBotones}>
              {esModoConfirmacion && (
                <TouchableOpacity
                  style={styles.botonCancelar}
                  onPress={handleCancelar}
                  activeOpacity={0.7}
                >
                  <Text style={styles.textoBotonCancelar}>{textoCancelar}</Text>
                </TouchableOpacity>
              )}

              <TouchableOpacity
                style={[
                  styles.botonConfirmar,
                  { backgroundColor: config.colorBotonConfirmar },
                  !esModoConfirmacion && { flex: 1 },
                ]}
                onPress={handleConfirmar}
                activeOpacity={0.8}
              >
                <Text style={styles.textoBotonConfirmar}>{textoBotonConfirmarFinal}</Text>
              </TouchableOpacity>
            </View>
          </View>
        </SafeAreaView>
      </View>
    </Modal>
  );
};

const styles = StyleSheet.create({
  contenedorFondoOverlay: {
    flex: 1,
    backgroundColor: 'rgba(15, 23, 42, 0.6)',
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 20,
  },
  contenedorModalCentrado: {
    width: '100%',
    maxWidth: 400,
    alignItems: 'center',
  },
  tarjetaModal: {
    width: '100%',
    backgroundColor: COLORES.blanco,
    borderRadius: 24,
    padding: 24,
    alignItems: 'center',
  },
  circuloIcono: {
    width: 64,
    height: 64,
    borderRadius: 32,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 16,
  },
  textoIcono: {
    fontSize: 32,
  },
  tituloModal: {
    fontSize: 20,
    fontWeight: 'bold',
    color: COLORES.textoPrincipal,
    textAlign: 'center',
    marginBottom: 8,
  },
  mensajeModal: {
    fontSize: 14,
    color: COLORES.textoSecundario,
    textAlign: 'center',
    lineHeight: 20,
    marginBottom: 24,
  },
  filaBotones: {
    flexDirection: 'row',
    width: '100%',
    gap: 12,
  },
  botonCancelar: {
    flex: 1,
    height: 48,
    borderRadius: 14,
    backgroundColor: '#F1F5F9',
    justifyContent: 'center',
    alignItems: 'center',
  },
  textoBotonCancelar: {
    fontSize: 15,
    fontWeight: '600',
    color: COLORES.textoSecundario,
  },
  botonConfirmar: {
    flex: 1,
    height: 48,
    borderRadius: 14,
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: COLORES.sombra,
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.15,
    shadowRadius: 4,
    elevation: 2,
  },
  textoBotonConfirmar: {
    fontSize: 15,
    fontWeight: 'bold',
    color: COLORES.blanco,
  },
});
