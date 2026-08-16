import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  Platform,
  Image,
  TouchableOpacity,
} from 'react-native';
import { Picker } from '@react-native-picker/picker';
import { CustomInput } from '../components/CustomInput';
import { CustomButton } from '../components/CustomButton';
import { ContenedorFormularioTeclado } from '../components/ContenedorFormularioTeclado';
import { Pais } from '../../Domain/entities/Pais';
import { Genero } from '../../Domain/entities/Genero';
import {
  getPaisesUseCase,
  getGenerosUseCase,
  registerUseCase,
} from '../../di/DI';

interface Props {
  onRegisterSuccess?: () => void;
  onBackToLogin?: () => void;
}

export const RegisterScreen = ({ onRegisterSuccess, onBackToLogin }: Props) => {
  const [name, setName] = useState('');
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');
  const [birthday, setBirthday] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [countryId, setCountryId] = useState<number>();
  const [genderId, setGenderId] = useState<number>();
  const [countries, setCountries] = useState<Pais[]>([]);
  const [genders, setGenders] = useState<Genero[]>([]);
  const [isLoading, setIsLoading] = useState(false);

  const [errorMessage, setErrorMessage] = useState('');
  const [successMessage, setSuccessMessage] = useState('');

  useEffect(() => {
    loadCatalogs();
  }, []);

  const loadCatalogs = async () => {
    try {
      const paises = await getPaisesUseCase.execute();
      const generos = await getGenerosUseCase.execute();

      console.log('Países cargados:', paises);
      console.log('Géneros cargados:', generos);

      setCountries(paises);
      setGenders(generos);
    } catch (e) {
      console.log(e);
    }
  };

  const validateEmail = (emailStr: string) => {
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    return emailRegex.test(emailStr.trim());
  };

  const handleRegister = async () => {
    setErrorMessage('');
    setSuccessMessage('');

    const trimmedName = name.trim();
    const trimmedUsernameValue = username.trim();
    const trimmedEmail = email.trim();
    const trimmedPhone = phone.trim();
    const trimmedBirthday = birthday.trim();

    if (!trimmedName) {
      setErrorMessage('👤 Por favor, ingresa tu nombre completo.');
      return;
    }

    if (!trimmedUsernameValue) {
      setErrorMessage('🪪 Por favor, ingresa un nombre de usuario.');
      return;
    }

    if (!trimmedEmail) {
      setErrorMessage('📧 Por favor, ingresa tu correo electrónico.');
      return;
    }

    if (!validateEmail(trimmedEmail)) {
      setErrorMessage('🛑 El correo electrónico no tiene un formato válido.');
      return;
    }

    if (!trimmedPhone) {
      setErrorMessage('📞 Por favor, ingresa tu número de teléfono.');
      return;
    }

    if (trimmedPhone.length < 8) {
      setErrorMessage('📞 El teléfono debe tener al menos 8 dígitos.');
      return;
    }

    if (!countryId) {
      setErrorMessage('🌎 Por favor, selecciona tu país.');
      return;
    }

    if (!genderId) {
      setErrorMessage('⚧️ Por favor, selecciona tu género.');
      return;
    }

    if (!trimmedBirthday) {
      setErrorMessage('🎂 Por favor, ingresa tu fecha de nacimiento.');
      return;
    }

    if (!password) {
      setErrorMessage('🔑 Por favor, ingresa una contraseña.');
      return;
    }

    if (password.length < 6) {
      setErrorMessage('🔒 La contraseña debe tener al menos 6 caracteres.');
      return;
    }

    if (password !== confirmPassword) {
      setErrorMessage('🛑 Las contraseñas no coinciden. Verifícalas.');
      return;
    }

    const [day, month, year] = trimmedBirthday.split("/");

    const birthdayISO = `${year}-${month}-${day}T00:00:00`;

    console.log(birthdayISO);

    setIsLoading(true);
    try {
      await registerUseCase.execute(
        trimmedName,
        trimmedUsernameValue,
        password,
        trimmedEmail,
        trimmedPhone,
        countryId,
        genderId,
        birthdayISO,
      );
      setSuccessMessage('🎉 ¡Cuenta creada con éxito! Redirigiendo...');

      setTimeout(() => {
        setIsLoading(false);
        if (onRegisterSuccess) onRegisterSuccess();
      }, 1500);
    } catch (error: any) {
      setErrorMessage(`🛑 ${error.message || 'Error al registrar usuario'}`);
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

        <Text style={styles.welcomeText}>Regístrate en</Text>
        <Text style={styles.brandTitle}>Nic Store</Text>
        <Text style={styles.subtitle}>Crea tu cuenta y accede al mejor catálogo de tecnología en el país</Text>

        <View style={styles.formContainer}>
          <Text style={styles.inputLabel}>Nombre Completo</Text>
          <CustomInput
            placeholder="Tu nombre completo"
            value={name}
            onChangeText={setName}
          />

          <Text style={styles.inputLabel}>Nombre de Usuario</Text>
          <CustomInput
            placeholder="Tu nombre de usuario"
            value={username}
            onChangeText={setUsername}
            autoCapitalize="none"
          />

          <Text style={styles.inputLabel}>Correo Electrónico</Text>
          <CustomInput
            placeholder="tucorreo@email.com"
            value={email}
            onChangeText={setEmail}
            keyboardType="email-address"
            autoCapitalize="none"
          />

          <Text style={styles.inputLabel}>Teléfono</Text>
          <CustomInput
            placeholder="Número de teléfono"
            value={phone}
            onChangeText={setPhone}
            keyboardType="phone-pad"
          />

          <Text style={styles.inputLabel}>País</Text>
          <View style={styles.pickerContainer}>
            <Picker
              selectedValue={countryId ?? ''}
              onValueChange={value => {
                setCountryId(Number(value));
              }}
              style={styles.picker}
              dropdownIconColor="#4F46E5"
            >
              <Picker.Item label="Selecciona un país" value="" />
              {countries.map(country => (
                <Picker.Item key={country.id} label={country.nombre} value={country.id} />
              ))}
            </Picker>
          </View>

          <Text style={styles.inputLabel}>Género</Text>
          <View style={styles.pickerContainer}>
            <Picker
              selectedValue={genderId ?? ''}
              onValueChange={value => {
                setGenderId(Number(value));
              }}
              style={styles.picker}
              dropdownIconColor="#4F46E5"
            >
              <Picker.Item label="Selecciona un género" value="" />
              {genders.map(gender => (
                <Picker.Item key={gender.id} label={gender.nombre} value={gender.id} />
              ))}
            </Picker>
          </View>

          <Text style={styles.inputLabel}>Fecha de Nacimiento</Text>
          <CustomInput
            placeholder="dd/mm/yyyy"
            value={birthday}
            onChangeText={setBirthday}
            keyboardType="numbers-and-punctuation"
          />

          <Text style={styles.inputLabel}>Contraseña</Text>
          <CustomInput
            placeholder="Mínimo 6 caracteres"
            value={password}
            onChangeText={setPassword}
            secureTextEntry
          />

          <Text style={styles.inputLabel}>Confirmar Contraseña</Text>
          <CustomInput
            placeholder="Repite tu contraseña"
            value={confirmPassword}
            onChangeText={setConfirmPassword}
            secureTextEntry
          />

          {errorMessage ? (
            <View style={styles.errorContainer}>
              <Text style={styles.errorText}>{errorMessage}</Text>
            </View>
          ) : null}
          
          {successMessage ? (
            <View style={styles.successContainer}>
              <Text style={styles.successText}>{successMessage}</Text>
            </View>
          ) : null}

          <View style={styles.buttonContainer}>
            <CustomButton title="Crear Cuenta" onPress={handleRegister} loading={isLoading} />
          </View>
        </View>

        <Text style={styles.termsText}>
          Al registrarte aceptas nuestros{' '}
          <Text style={styles.termsLink}>Términos de Servicio</Text> y{' '}
          <Text style={styles.termsLink}>Política de Privacidad</Text>.
        </Text>

        <TouchableOpacity onPress={onBackToLogin} style={styles.loginContainer} activeOpacity={0.7}>
          <Text style={styles.loginText}>
            ¿Ya tienes una cuenta? <Text style={styles.loginLink}>Inicia sesión</Text>
          </Text>
        </TouchableOpacity>

      </View>
    </ContenedorFormularioTeclado>
  );
};

const styles = StyleSheet.create({
  container: { 
    flex: 1, 
    backgroundColor: '#F8FAFC' 
  },
  scrollContainer: { 
    flexGrow: 1,
    paddingVertical: 45, 
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
    borderColor: '#F1F5F9',
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
    color: '#64748B',
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
    color: '#334155',
    marginBottom: 6, 
    marginTop: 14,
    textTransform: 'uppercase',
    letterSpacing: 0.5,
  },
  pickerContainer: {
    borderWidth: 1,
    borderColor: '#E2E8F0',
    borderRadius: 14,
    backgroundColor: '#F8FAFC',
    marginBottom: 2,
    overflow: 'hidden',
  },
  picker: {
    color: '#0F172A',
    minHeight: 48,
  },
  buttonContainer: { 
    marginTop: 24 
  },
  termsText: { 
    fontSize: 12, 
    color: '#64748B', 
    textAlign: 'center', 
    marginTop: 20, 
    lineHeight: 18,
    fontWeight: '500'
  },
  termsLink: { 
    color: '#4F46E5', 
    fontWeight: '600' 
  },
  loginContainer: { 
    marginTop: 28, 
    alignItems: 'center' 
  },
  loginText: { 
    fontSize: 13, 
    color: '#64748B',
    fontWeight: '500',
  },
  loginLink: { 
    fontWeight: '700', 
    color: '#4F46E5' 
  },
  errorContainer: {
    marginTop: 16,
    backgroundColor: '#FEF2F2',
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
  },
  successContainer: {
    marginTop: 16,
    backgroundColor: '#ECFDF5',
    borderWidth: 1,
    borderColor: '#D1FAE5',
    borderRadius: 12,
    padding: 12,
  },
  successText: { 
    color: '#10B981', 
    fontSize: 13, 
    fontWeight: '600', 
    textAlign: 'center',
    lineHeight: 18,
  }
});