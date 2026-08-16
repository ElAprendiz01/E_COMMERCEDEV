import React, { useState, useEffect } from 'react';
import { SafeAreaView, StyleSheet, StatusBar, ActivityIndicator, View, Text } from 'react-native';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { LoginScreen } from './src/Presentacion/screens/loginScreen';
import { RegisterScreen } from './src/Presentacion/screens/RegisterScreen';
import { HomeScreen } from './src/Presentacion/screens/HomeScreen';
import { AdminDashboardScreen } from './src/Presentacion/screens/AdminDashboardScreen';
import { User } from './src/Domain/entities/User';
import { obtenerSesionGuardadaUseCase, cerrarSesionUseCase } from './src/di/DI';

type ScreenName = 'login' | 'register' | 'home' | 'admin';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: 1,
      refetchOnWindowFocus: false,
    },
  },
});

export default function App() {
  const [currentScreen, setCurrentScreen] = useState<ScreenName>('login');
  const [currentUser, setCurrentUser] = useState<User | null>(null);
  const [estaVerificandoSesion, setEstaVerificandoSesion] = useState<boolean>(true);

  // Verificar la existencia de una sesión previa guardada al cargar la aplicación (F5 / Ctrl+R)
  useEffect(() => {
    const verificarSesionExistente = async () => {
      try {
        const sesionGuardada = await obtenerSesionGuardadaUseCase.execute();
        if (sesionGuardada && sesionGuardada.usuario) {
          console.log("✅ Sesión restaurada para:", sesionGuardada.usuario.name);
          setCurrentUser(sesionGuardada.usuario);
          if (sesionGuardada.usuario.role === 'admin') {
            setCurrentScreen('admin');
          } else {
            setCurrentScreen('home');
          }
        }
      } catch (error) {
        console.error('Error al verificar la sesión guardada:', error);
      } finally {
        setEstaVerificandoSesion(false);
      }
    };

    verificarSesionExistente();
  }, []);

  const handleLoginSuccess = (user: User) => {
    setCurrentUser(user);
    if (user.role === 'admin') {
      setCurrentScreen('admin');
    } else {
      setCurrentScreen('home');
    }
  };

  const handleRegisterSuccess = () => {
    setCurrentScreen('login');
  };

  const handleLogout = async () => {
    try {
      await cerrarSesionUseCase.execute();
    } catch (error) {
      console.error('Error al cerrar sesión:', error);
    } finally {
      setCurrentUser(null);
      setCurrentScreen('login');
    }
  };

  if (estaVerificandoSesion) {
    return (
      <SafeAreaView style={styles.pantallaCarga}>
        <ActivityIndicator size="large" color="#2563EB" />
        <Text style={styles.textoCarga}>Cargando Nic Store...</Text>
      </SafeAreaView>
    );
  }

  return (
    <QueryClientProvider client={queryClient}>
      <SafeAreaView style={styles.container}>
        <StatusBar barStyle="dark-content" backgroundColor="#F8FAFC" />

        {currentScreen === 'login' && (
          <LoginScreen
            onLoginSuccess={handleLoginSuccess}
            onNavigateToRegister={() => setCurrentScreen('register')}
          />
        )}

        {currentScreen === 'register' && (
          <RegisterScreen
            onRegisterSuccess={handleRegisterSuccess}
            onBackToLogin={() => setCurrentScreen('login')}
          />
        )}

        {currentScreen === 'home' && currentUser && (
          <HomeScreen user={currentUser} onLogout={handleLogout} />
        )}

        {currentScreen === 'admin' && (
          <AdminDashboardScreen onLogout={handleLogout} />
        )}
      </SafeAreaView>
    </QueryClientProvider>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F8FAFC',
  },
  pantallaCarga: {
    flex: 1,
    backgroundColor: '#F8FAFC',
    justifyContent: 'center',
    alignItems: 'center',
  },
  textoCarga: {
    marginTop: 12,
    fontSize: 16,
    color: '#64748B',
    fontWeight: '500',
  },
});
