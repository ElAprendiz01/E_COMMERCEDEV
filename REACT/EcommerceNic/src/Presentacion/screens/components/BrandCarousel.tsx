import React from 'react';
import {
  View,
  Text,
  ScrollView,
  TouchableOpacity,
  StyleSheet,
} from 'react-native';
import { Mark } from '../../../Domain/entities/Mark';
import { COLORES, ESTILOS_SOMBRA } from '../../theme/theme';

interface BrandCarouselProps {
  marcas: Mark[];
  marcaSeleccionadaId: number | null;
  onSeleccionarMarca: (id: number | null) => void;
}

const BRAND_ICONS: { [key: string]: string } = {
  nike: '👟',
  apple: '🍏',
  samsung: '📱',
  sony: '🎧',
  dell: '💻',
  adidas: '👟',
  puma: '👟',
  infinix: '📱',
};

export const BrandCarousel = ({
  marcas,
  marcaSeleccionadaId,
  onSeleccionarMarca,
}: BrandCarouselProps) => {
  const getBrandIcon = (name: string): string => {
    const clean = (name || '').toLowerCase();
    for (const key in BRAND_ICONS) {
      if (clean.includes(key)) {
        return BRAND_ICONS[key];
      }
    }
    return '🏷️';
  };

  return (
    <View style={styles.container}>
      <View style={styles.headerRow}>
        <Text style={styles.title}>🏷️ Marcas Destacadas</Text>
        {marcaSeleccionadaId !== null && (
          <TouchableOpacity onPress={() => onSeleccionarMarca(null)} activeOpacity={0.7}>
            <Text style={styles.resetText}>Limpiar Filtro ✕</Text>
          </TouchableOpacity>
        )}
      </View>

      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.scrollContent}
      >
        {/* Chip por defecto: TODAS */}
        <TouchableOpacity
          style={[
            styles.chip,
            marcaSeleccionadaId === null ? styles.chipActive : styles.chipInactive,
            marcaSeleccionadaId === null && ESTILOS_SOMBRA.tarjeta,
          ]}
          onPress={() => onSeleccionarMarca(null)}
          activeOpacity={0.8}
        >
          <Text style={styles.chipEmoji}>⭐</Text>
          <Text
            style={[
              styles.chipText,
              marcaSeleccionadaId === null ? styles.chipTextActive : styles.chipTextInactive,
            ]}
          >
            Todas
          </Text>
        </TouchableOpacity>

        {/* Chips de Marcas provenientes de SQL Server */}
        {marcas.map((marca) => {
          const isSelected = marcaSeleccionadaId === marca.markId;
          const icon = getBrandIcon(marca.markName);

          return (
            <TouchableOpacity
              key={marca.markId}
              style={[
                styles.chip,
                isSelected ? styles.chipActive : styles.chipInactive,
                isSelected && ESTILOS_SOMBRA.tarjeta,
              ]}
              onPress={() => onSeleccionarMarca(marca.markId)}
              activeOpacity={0.8}
            >
              <Text style={styles.chipEmoji}>{icon}</Text>
              <Text
                style={[
                  styles.chipText,
                  isSelected ? styles.chipTextActive : styles.chipTextInactive,
                ]}
              >
                {marca.markName}
              </Text>
            </TouchableOpacity>
          );
        })}
      </ScrollView>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginVertical: 10,
  },
  headerRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 16,
    marginBottom: 8,
  },
  title: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#0F172A',
    letterSpacing: -0.3,
  },
  resetText: {
    fontSize: 12,
    fontWeight: '600',
    color: COLORES.primario,
  },
  scrollContent: {
    paddingHorizontal: 16,
    paddingVertical: 4,
    gap: 8,
  },
  chip: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 14,
    paddingVertical: 8,
    borderRadius: 20,
    borderWidth: 1,
  },
  chipActive: {
    backgroundColor: COLORES.primario,
    borderColor: COLORES.primario,
  },
  chipInactive: {
    backgroundColor: '#F8FAFC',
    borderColor: '#E2E8F0',
  },
  chipEmoji: {
    fontSize: 14,
    marginRight: 6,
  },
  chipText: {
    fontSize: 13,
    fontWeight: '600',
  },
  chipTextActive: {
    color: '#FFFFFF',
  },
  chipTextInactive: {
    color: '#334155',
  },
});
