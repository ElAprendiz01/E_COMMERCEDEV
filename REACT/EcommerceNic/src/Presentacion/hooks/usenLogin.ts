import { useState } from 'react';
import { Alert } from 'react-native';

export const useLogin = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  // PUNTO 1: Recibe el arreglo de usuarios registrados y valida contra él
  const handleLogin = (onSuccess: () => void, registeredUsers: { email: string; password: string }[] = []) => {
    if (!email || !password) {
      Alert.alert('Campos vacíos', 'Por favor, completa todos los campos');
      return;
    }

    setIsLoading(true);

    setTimeout(() => {
      setIsLoading(false);

      const userFound = registeredUsers.find(
        (u) => u.email.toLowerCase() === email.toLowerCase() && u.password === password
      );

      if (userFound) {
        onSuccess();
      } else {
        Alert.alert(
          '❌ Credenciales inválidas',
          'El correo o la contraseña no son correctos. Verificá tus datos o creá una cuenta nueva.',
          [{ text: 'Intentar de nuevo', style: 'default' }]
        );
      }
    }, 1200);
  };

  return {
    email,
    password,
    isLoading,
    setEmail,
    setPassword,
    handleLogin,
  };
};
