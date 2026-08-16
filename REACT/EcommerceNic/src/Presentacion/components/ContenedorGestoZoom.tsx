import React from 'react';
import { View, StyleSheet, Platform } from 'react-native';
import { useGestoZoom } from '../hooks/useGestoZoom';

interface Props {
  children: React.ReactNode;
}

export const ContenedorGestoZoom: React.FC<Props> = ({ children }) => {
  const { escalaZoom, responderPan, manejarRuedaWeb } = useGestoZoom();

  // Al alejar, expandimos el contenedor para que quepan efectivamente MÁS mensajes en el mismo espacio visible
  const porcentajeDimension = `${(100 / escalaZoom).toFixed(2)}%` as any;

  return (
    <View
      style={styles.contenedorPrincipal}
      {...responderPan.panHandlers}
      // @ts-ignore - Evento wheel específico para la plataforma Web
      onWheel={Platform.OS === 'web' ? manejarRuedaWeb : undefined}
    >
      <View
        style={[
          styles.contenedorEscalado,
          {
            width: porcentajeDimension,
            height: porcentajeDimension,
            transform: [{ scale: escalaZoom }],
          },
        ]}
      >
        {children}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  contenedorPrincipal: {
    flex: 1,
    overflow: 'hidden',
  },
  contenedorEscalado: {
    flex: 1,
    // @ts-ignore
    transformOrigin: 'top left',
  },
});
