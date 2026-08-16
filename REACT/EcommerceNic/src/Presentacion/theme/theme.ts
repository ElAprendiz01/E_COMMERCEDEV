import { StyleSheet } from 'react-native';

export const COLORES = {
  primario: '#3B82F6',
  primarioOscuro: '#2563EB',
  primarioSuave: '#DBEAFE',
  fondo: '#F8FAFC',
  blanco: '#FFFFFF',
  textoPrincipal: '#0F172A',
  textoSecundario: '#64748B',
  borde: '#E2E8F0',
  exito: '#10B981',
  peligro: '#EF4444',
  sombra: '#000000',
};

export const ESTILOS_SOMBRA = StyleSheet.create({
  tarjeta: {
    shadowColor: COLORES.sombra,
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  navegacion: {
    shadowColor: COLORES.sombra,
    shadowOffset: { width: 0, height: -2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
});
