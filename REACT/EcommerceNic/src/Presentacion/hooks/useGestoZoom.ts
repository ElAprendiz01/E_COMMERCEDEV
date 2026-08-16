import { useRef, useState } from 'react';
import { PanResponder, PanResponderInstance } from 'react-native';

export const ZOOM_MINIMO = 0.75;
export const ZOOM_MAXIMO = 1.15;
export const ZOOM_POR_DEFECTO = 1.0;

export const useGestoZoom = () => {
  const [escalaZoom, setEscalaZoom] = useState<number>(ZOOM_POR_DEFECTO);
  const distanciaInicialRef = useRef<number | null>(null);
  const escalaBaseRef = useRef<number>(ZOOM_POR_DEFECTO);

  // Calcular la distancia euclidiana entre dos puntos de toque (dedos)
  const calcularDistanciaEntreDedos = (event: any): number => {
    const touches = event.nativeEvent?.touches || event.touches || [];
    if (touches.length < 2) return 0;

    const toque1 = touches[0];
    const toque2 = touches[1];
    const dx = toque1.pageX - toque2.pageX;
    const dy = toque1.pageY - toque2.pageY;
    return Math.sqrt(dx * dx + dy * dy);
  };

  // PanResponder para capturar el gesto multitáctil de pellizco (Pinch to Zoom)
  const responderPan: PanResponderInstance = useRef(
    PanResponder.create({
      onStartShouldSetPanResponder: (evt) => (evt.nativeEvent?.touches?.length || 0) === 2,
      onMoveShouldSetPanResponder: (evt) => (evt.nativeEvent?.touches?.length || 0) === 2,

      onPanResponderGrant: (evt) => {
        const touches = evt.nativeEvent?.touches || [];
        if (touches.length === 2) {
          const dist = calcularDistanciaEntreDedos(evt);
          distanciaInicialRef.current = dist > 0 ? dist : null;
          escalaBaseRef.current = escalaZoom;
        }
      },

      onPanResponderMove: (evt) => {
        const touches = evt.nativeEvent?.touches || [];
        if (touches.length === 2 && distanciaInicialRef.current && distanciaInicialRef.current > 0) {
          const distanciaActual = calcularDistanciaEntreDedos(evt);
          if (distanciaActual > 0) {
            const factorEscala = distanciaActual / distanciaInicialRef.current;
            const nuevaEscala = escalaBaseRef.current * factorEscala;

            // Restringir la escala entre el mínimo y máximo permitido
            const escalaClamped = Math.min(Math.max(nuevaEscala, ZOOM_MINIMO), ZOOM_MAXIMO);
            setEscalaZoom(escalaClamped);
          }
        }
      },

      onPanResponderRelease: () => {
        distanciaInicialRef.current = null;
        escalaBaseRef.current = escalaZoom;
      },

      onPanResponderTerminate: () => {
        distanciaInicialRef.current = null;
      },
    })
  ).current;

  // Manejador para el evento wheel en entorno Web (Ctrl + rueda o pellizco en Touchpad)
  const manejarRuedaWeb = (evento: any) => {
    if (evento.ctrlKey || evento.metaKey) {
      evento.preventDefault();
      const delta = evento.deltaY < 0 ? 0.05 : -0.05;
      setEscalaZoom((prev) => Math.min(Math.max(prev + delta, ZOOM_MINIMO), ZOOM_MAXIMO));
    }
  };

  const restablecerZoom = () => {
    setEscalaZoom(ZOOM_POR_DEFECTO);
    escalaBaseRef.current = ZOOM_POR_DEFECTO;
  };

  return {
    escalaZoom,
    responderPan,
    manejarRuedaWeb,
    restablecerZoom,
  };
};
