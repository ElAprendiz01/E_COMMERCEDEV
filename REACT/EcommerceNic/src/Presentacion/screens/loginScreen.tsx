import React, { useState } from 'react';

import {
  View,
  Text,
  StyleSheet,
  Platform,
  Image,
  TouchableOpacity,
} from 'react-native';
import { CustomInput } from '../components/CustomInput';
import { CustomButton } from '../components/CustomButton';
import { ContenedorFormularioTeclado } from '../components/ContenedorFormularioTeclado';
import { loginUseCase, guardarSesionUseCase } from '../../di/DI';
import { User } from '../../Domain/entities/User';

interface Props {
  onLoginSuccess: (user: User) => void;
  onNavigateToRegister: () => void;
}

export const LoginScreen = ({ onLoginSuccess, onNavigateToRegister }: Props) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');

  const validateEmail = (emailStr: string) => {
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    return emailRegex.test(emailStr.trim());
  };

  const handleLoginSubmit = async () => {
    setError('');

    const trimmedEmail = email.trim();
    const trimmedPassword = password.trim();

    if (!trimmedEmail) {
      setError('📧 Por favor, ingresa tu correo electrónico.');
      return;
    }

    if (!validateEmail(trimmedEmail)) {
      setError('格式 🛑 El correo electrónico no tiene un formato válido (ej. usuario@dominio.com).');
      return;
    }

    if (!trimmedPassword) {
      setError('🔑 Por favor, ingresa tu contraseña.');
      return;
    }

    if (trimmedPassword.length < 6) {
      setError('🔒 La contraseña debe tener al menos 6 caracteres.');
      return;
    }

    setIsLoading(true);
    try {
      const loggedUser = await loginUseCase.execute(trimmedEmail, trimmedPassword);
      const token = loggedUser.data?.token ?? '';
      const normalizedUser: User = {
        id: String(loggedUser.data?.userId ?? Date.now()),
        email: loggedUser.data?.userEmail ?? trimmedEmail,
        name: loggedUser.data?.userFullName ?? trimmedEmail,
        role: 'user',
      };
      
      // Persistir la sesión del usuario localmente
      await guardarSesionUseCase.execute(normalizedUser, token);

      console.log("✅ Login Exitoso para:", normalizedUser.name, "Rol:", normalizedUser.role);
      onLoginSuccess(normalizedUser);
    } catch (err: any) {
      setError(`🛑 ${err.message || 'Error al iniciar sesión. Verifica tus credenciales.'}`);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <ContenedorFormularioTeclado
      estiloContenedor={styles.container}
      estiloScroll={styles.scrollContainer}
    >
      <View style={styles.cardContainer}>
        
        <View style={styles.logoWrapper}>
          <View style={styles.logoBackground}>
            <Image
              source={require('../../../assets/logo.png')}
              style={styles.logoImage}
              resizeMode="contain"
            />
          </View>
        </View>

        <Text style={styles.welcomeText}>Bienvenido a</Text>
        <Text style={styles.brandTitle}>Nic Store</Text>
        <Text style={styles.subtitle}>La mejor tecnología al alcance de tus manos en Nicaragua</Text>

        <View style={styles.formContainer}>
          <Text style={styles.inputLabel}>Correo Electrónico</Text>
          <CustomInput
            placeholder="tucorreo@email.com"
            value={email}
            onChangeText={setEmail}
            keyboardType="email-address"
            autoCapitalize="none"
            autoComplete="email"
          />

          <Text style={styles.inputLabel}>Contraseña</Text>
          <CustomInput
            placeholder="Contraseña"
            value={password}
            onChangeText={setPassword}
            secureTextEntry
            autoComplete="current-password"
          />

          {error ? (
            <View style={styles.errorContainer}>
              <Text style={styles.errorText}>{error}</Text>
            </View>
          ) : null}

          <View style={styles.buttonContainer}>
            <CustomButton title="Iniciar Sesión" onPress={handleLoginSubmit} loading={isLoading} />
          </View>
        </View>

        <TouchableOpacity onPress={onNavigateToRegister} style={styles.registerContainer} activeOpacity={0.7}>
          <Text style={styles.registerText}>
            ¿No tienes cuenta todavía? <Text style={styles.registerLink}>Regístrate ahora</Text>
          </Text>
        </TouchableOpacity>

      </View>
    </ContenedorFormularioTeclado>
  );
};

const styles = StyleSheet.create({
  container: { 
    flex: 1, 
    backgroundColor: '#F8FAFC' // Slate-50 main premium background
  },
  scrollContainer: { 
    flexGrow: 1,
    paddingVertical: 50, 
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 20,
  },
  cardContainer: { 
    backgroundColor: '#FFFFFF',
    borderRadius: 24,
    paddingHorizontal: 28,
    paddingVertical: 32,
    width: '100%',
    maxWidth: 420,
    alignSelf: 'center',
    borderWidth: 1,
    borderColor: '#F1F5F9', // subtle border
    ...Platform.select({
      ios: {
        shadowColor: '#0F172A',
        shadowOffset: { width: 0, height: 8 },
        shadowOpacity: 0.05,
        shadowRadius: 24,
      },
      android: {
        elevation: 4,
      },
      default: {
        shadowColor: '#0F172A',
        shadowOffset: { width: 0, height: 8 },
        shadowOpacity: 0.05,
        shadowRadius: 24,
      }
    }),
  },
  logoWrapper: {
    alignItems: 'center',
    marginBottom: 20,
  },
  logoBackground: {
    width: 96,
    height: 96,
    borderRadius: 28,
    backgroundColor: '#0F172A',
    borderWidth: 2.5,
    borderColor: '#6366F1',
    justifyContent: 'center',
    alignItems: 'center',
    ...Platform.select({
      ios: {
        shadowColor: '#6366F1',
        shadowOffset: { width: 0, height: 8 },
        shadowOpacity: 0.35,
        shadowRadius: 16,
      },
      android: {
        elevation: 6,
      },
      default: {
        shadowColor: '#6366F1',
        shadowOffset: { width: 0, height: 8 },
        shadowOpacity: 0.35,
        shadowRadius: 16,
      },
    }),
  },
  logoImage: { 
    width: 80, 
    height: 80, 
    borderRadius: 20 
  },
  welcomeText: { 
    fontSize: 12, 
    fontWeight: '800', 
    color: '#6366F1',
    textAlign: 'center',
    textTransform: 'uppercase',
    letterSpacing: 2,
  },
  brandTitle: { 
    fontSize: 34, 
    fontWeight: '900', 
    color: '#0F172A',
    textAlign: 'center', 
    marginBottom: 8,
    marginTop: 2,
    letterSpacing: 0.5,
  },
  subtitle: { 
    fontSize: 13, 
    color: '#64748B', // Slate-500
    textAlign: 'center', 
    marginBottom: 28, 
    lineHeight: 18,
    paddingHorizontal: 10 
  },
  formContainer: {
    width: '100%',
  },
  inputLabel: { 
    fontSize: 13, 
    fontWeight: '700', 
    color: '#334155', // Slate-700
    marginBottom: 6, 
    marginTop: 14,
    textTransform: 'uppercase',
    letterSpacing: 0.5,
  },
  buttonContainer: { 
    marginTop: 24 
  },
  registerContainer: { 
    marginTop: 28, 
    alignItems: 'center' 
  },
  registerText: { 
    fontSize: 13, 
    color: '#64748B',
    fontWeight: '500',
  },
  registerLink: { 
    fontWeight: '700', 
    color: '#4F46E5' // Indigo-600 premium brand link
  },
  errorContainer: {
    marginTop: 16,
    backgroundColor: '#FEF2F2', // soft light red
    borderWidth: 1,
    borderColor: '#FEE2E2',
    borderRadius: 12,
    padding: 12,
  },
  errorText: { 
    color: '#EF4444', 
    fontSize: 13, 
    fontWeight: '600', 
    textAlign: 'center', 
    lineHeight: 18,
  }
});