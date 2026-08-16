import React from 'react';
import {
  KeyboardAvoidingView,
  ScrollView,
  TouchableWithoutFeedback,
  Keyboard,
  Platform,
  StyleSheet,
  StyleProp,
  ViewStyle,
  View,
} from 'react-native';

/**
 * Propiedades para el componente ContenedorFormularioTeclado.
 */
interface PropiedadesContenedorTeclado {
  /** Componentes hijos que se renderizarán dentro del contenedor con scroll */
  children: React.ReactNode;
  /** Estilo personalizado para el contenedor principal de KeyboardAvoidingView */
  estiloContenedor?: StyleProp<ViewStyle>;
  /** Estilo personalizado para el contenido interno del ScrollView */
  estiloScroll?: StyleProp<ViewStyle>;
  /** Compensación vertical opcional para ajustar la distancia del teclado (ej. si hay un header nativo) */
  desplazamientoVertical?: number;
  /** Permite cerrar el teclado al tocar cualquier espacio libre fuera de un campo de texto */
  cerrarTecladoAlTocarFuera?: boolean;
  /** Determina si se muestra la barra indicadora de desplazamiento vertical */
  mostrarIndicadorScroll?: boolean;
}

/**
 * Componente modular reusable para envolver formularios y pantallas con inputs.
 * Evita que el teclado virtual oculte campos de texto, botones o elementos de la interfaz.
 */
export const ContenedorFormularioTeclado: React.FC<PropiedadesContenedorTeclado> = ({
  children,
  estiloContenedor,
  estiloScroll,
  desplazamientoVertical = 0,
  cerrarTecladoAlTocarFuera = true,
  mostrarIndicadorScroll = false,
}) => {
  // En iOS se recomienda usar 'padding' y en Android 'height' o desplazamiento adaptativo
  const comportamientoTeclado = Platform.OS === 'ios' ? 'padding' : 'height';

  const contenido = (
    <KeyboardAvoidingView
      behavior={comportamientoTeclado}
      style={[estilosBase.contenedorPrincipal, estiloContenedor]}
      keyboardVerticalOffset={desplazamientoVertical}
    >
      <ScrollView
        contentContainerStyle={[estilosBase.contenedorScroll, estiloScroll]}
        keyboardShouldPersistTaps="handled"
        showsVerticalScrollIndicator={mostrarIndicadorScroll}
        bounces={false}
      >
        {children}
      </ScrollView>
    </KeyboardAvoidingView>
  );

  // En entorno Web, TouchableWithoutFeedback intercepta los clics en la emergente de contraseñas guardadas de Chrome/Edge
  // y ejecuta Keyboard.dismiss(), desenfocando el input y expulsando el cursor. Se restringe únicamente a móvil (iOS/Android).
  if (cerrarTecladoAlTocarFuera && Platform.OS !== 'web') {
    return (
      <TouchableWithoutFeedback onPress={Keyboard.dismiss} accessible={false}>
        <View style={estilosBase.contenedorPrincipal}>
          {contenido}
        </View>
      </TouchableWithoutFeedback>
    );
  }

  return contenido;
};

const estilosBase = StyleSheet.create({
  contenedorPrincipal: {
    flex: 1,
    width: '100%',
  },
  contenedorScroll: {
    flexGrow: 1,
  },
});
