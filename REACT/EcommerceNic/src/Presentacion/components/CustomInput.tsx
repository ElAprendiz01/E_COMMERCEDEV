import React, { useState, useRef } from 'react';
import { View, TextInput, StyleSheet, TextInputProps, TouchableOpacity, Image, Platform } from 'react-native';

interface Props extends TextInputProps {
  placeholder: string;
  value: string;
  onChangeText: (text: string) => void;
  secureTextEntry?: boolean;
  isPassword?: boolean;
}

export const CustomInput = ({
  placeholder,
  value,
  onChangeText,
  secureTextEntry = false,
  isPassword,
  onFocus,
  onBlur,
  ...rest
}: Props) => {
  const [isSecure, setIsSecure] = useState(secureTextEntry);
  const inputRef = useRef<TextInput>(null);

  const esCampoPassword = isPassword !== undefined ? isPassword : Boolean(secureTextEntry);

  return (
    <View style={styles.inputContainer}>
      {/* 1. ICONO IZQUIERDO ESTABLE (Sin mutación ni evaluaciones de string) */}
      <Image 
        source={
          esCampoPassword 
            ? require('../../../assets/Candado.png') 
            : require('../../../assets/loginGmail.png')
        } 
        style={styles.iconImageLeft} 
        resizeMode="contain" 
      />

      {/* 2. CAMPO DE TEXTO CON REFERENCIA PERSISTENTE */}
      <TextInput
        ref={inputRef}
        placeholder={placeholder}
        value={value}
        onChangeText={onChangeText}
        secureTextEntry={isSecure}
        placeholderTextColor="#94A3B8"
        onFocus={onFocus}
        onBlur={onBlur}
        style={styles.input}
        {...rest}
      />

      {/* 3. ICONO DERECHO: Ver/ocultar contraseña */}
      {esCampoPassword && (
        <TouchableOpacity
          onPress={() => setIsSecure(!isSecure)}
          activeOpacity={0.7}
          style={styles.rightIconWrapper}
        >
          <Image 
            source={
              isSecure 
                ? require('../../../assets/invisible.png') 
                : require('../../../assets/visible.png')
            }
            style={styles.iconImageRight}
            resizeMode="contain"
          />
        </TouchableOpacity>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  inputContainer: {
    width: '100%',
    height: 54,
    borderRadius: 14,          
    borderWidth: 1.5,
    borderColor: '#CBD5E1', // Slate-300 permanente y estable sin mutaciones de estado
    backgroundColor: '#FFFFFF',
    flexDirection: 'row',       
    alignItems: 'center',
    paddingHorizontal: 16,
    marginBottom: 4,
    ...Platform.select({
      ios: {
        shadowColor: '#0F172A',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.02,
        shadowRadius: 4,
      },
      android: {
        elevation: 1,
      },
      default: {},
    }),
  },
  iconImageLeft: {
    width: 20,
    height: 20,
    marginRight: 12,
    tintColor: '#64748B',
  } as any,
  input: {
    flex: 1,
    fontSize: 15,
    color: '#0F172A',
    fontWeight: '500',
    height: '100%',
    ...Platform.select({
      web: {
        outlineStyle: 'none',
      } as any,
      default: {},
    }),
  },
  rightIconWrapper: {
    padding: 4,
  },
  iconImageRight: {
    width: 22,
    height: 22,
    marginLeft: 6,
    tintColor: '#64748B',
  } as any,
});