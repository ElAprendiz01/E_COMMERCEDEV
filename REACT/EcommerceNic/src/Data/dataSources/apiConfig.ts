import { Platform } from 'react-native';
import Constants from 'expo-constants';

/**
 * Obtiene la dirección IP del Host dinámicamente si la app corre en Expo CLI (Emulador o Celular Físico en Wi-Fi)
 */
const getDynamicHostIp = (): string => {
  try {
    const hostUri = Constants.expoConfig?.hostUri || (Constants as any).manifest2?.extra?.expoClient?.hostUri;
    if (hostUri) {
      return hostUri.split(':')[0];
    }
  } catch (e) {
    console.warn("No se pudo obtener hostUri dinámico de Expo Constants:", e);
  }
  return 'localhost';
};

const hostIp = getDynamicHostIp();

/**
 * Resuelve la URL base adecuada según la plataforma y el entorno
 */
const getBaseUrl = (port: number, customEnvUrl?: string): string => {
  // 1. Si existe una URL explícita configurada en .env, se prioriza
  if (customEnvUrl && !customEnvUrl.includes('localhost') && !customEnvUrl.includes('127.0.0.1')) {
    return customEnvUrl;
  }

  // 2. Si se ejecuta en Navegador Web
  if (Platform.OS === 'web') {
    return customEnvUrl || `http://localhost:${port}`;
  }

  // 3. Si se ejecuta en Móvil (Android/iOS en Emulador o Dispositivo Físico con Expo Go)
  if (hostIp && hostIp !== 'localhost') {
    return `http://${hostIp}:${port}`;
  }

  // Fallback para Android Emulator en caso de no detectar IP de Host
  return Platform.OS === 'android' ? `http://10.0.2.2:${port}` : `http://localhost:${port}`;
};

export const API_CONFIG = {
  BASE_URL: getBaseUrl(5092, process.env.EXPO_PUBLIC_API_URL),
  CHATBOT_URL: getBaseUrl(8000, process.env.EXPO_PUBLIC_CHATBOT_URL),
};

/**
 * Helper para realizar peticiones HTTP de forma segura evitando SyntaxError al parsear JSON no válido (ej. errores 500 HTML)
 * Incluye un AbortController con timeout de 15 segundos para resiliencia de red.
 */
export async function safeFetch<T>(url: string, options?: RequestInit): Promise<T> {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), 15000);

  let response: Response;
  try {
    response = await fetch(url, { ...options, signal: controller.signal });
  } catch (err: any) {
    if (err.name === 'AbortError') {
      throw new Error('La solicitud tardó demasiado. Verificá tu conexión e intentá de nuevo.');
    }
    throw new Error(`Error de red al conectar con el servidor: ${err.message || 'Sin conexión'}`);
  } finally {
    clearTimeout(timeoutId);
  }

  const contentType = response.headers.get('content-type');
  let data: any;

  if (contentType && contentType.includes('application/json')) {
    try {
      data = await response.json();
    } catch (e) {
      throw new Error('La respuesta del servidor no pudo ser procesada (JSON no válido).');
    }
  } else {
    const text = await response.text();
    if (!response.ok) {
      throw new Error(`Error del servidor (${response.status}): ${text || response.statusText}`);
    }
    data = text;
  }

  if (!response.ok) {
    const errorMessage = typeof data === 'object' && data?.msj ? data.msj : (typeof data === 'string' ? data : `Error HTTP ${response.status}`);
    throw new Error(errorMessage);
  }

  return data as T;
}
