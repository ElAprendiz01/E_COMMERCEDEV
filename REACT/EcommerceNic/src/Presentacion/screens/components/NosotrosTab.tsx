import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Image,
} from 'react-native';

interface NosotrosTabProps {
  handleLogout: () => void;
}

export const NosotrosTab = ({ handleLogout }: NosotrosTabProps) => {
  return (
    <View style={styles.tabContent}>
      <View style={styles.cartHeader}>
        <Text style={styles.cartHeaderTitle}>Sobre Nosotros</Text>
      </View>
      <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.aboutScrollPadding}>
        <View style={styles.aboutHeroCard}>
          <Image source={require('../../../../assets/logo.png')} style={styles.aboutHeroImage} resizeMode="contain" />
          <Text style={styles.aboutHeroTitle}>Nic Store</Text>
          <Text style={styles.aboutHeroText}>
            Si lo deseas, Tomalo!
          </Text>
        </View>

        <View style={styles.infoSection}>
          <Text style={styles.infoSectionTitle}>Información de Contacto</Text>
          <View style={styles.infoRow}>
            <View style={styles.infoIconWrapper}>
              <Text style={styles.infoIcon}>📍</Text>
            </View>
            <View style={styles.infoTextWrapper}>
              <Text style={styles.infoLabel}>Ubicación</Text>
              <Text style={styles.infoValue}>Metrocentro, Managua, Nicaragua</Text>
            </View>
          </View>
          <View style={styles.infoRow}>
            <View style={styles.infoIconWrapper}>
              <Text style={styles.infoIcon}>📱</Text>
            </View>
            <View style={styles.infoTextWrapper}>
              <Text style={styles.infoLabel}>WhatsApp</Text>
              <Text style={styles.infoValue}>+505 8888 8888</Text>
            </View>
          </View>
          <View style={styles.infoRow}>
            <View style={styles.infoIconWrapper}>
              <Text style={styles.infoIcon}>📧</Text>
            </View>
            <View style={styles.infoTextWrapper}>
              <Text style={styles.infoLabel}>Correo Electrónico</Text>
              <Text style={styles.infoValue}>soporte@nicstore.com</Text>
            </View>
          </View>
        </View>

        <TouchableOpacity style={styles.logoutButton} onPress={handleLogout} activeOpacity={0.8}>
          <Text style={styles.logoutButtonText}>Cerrar Sesión</Text>
          <Text style={styles.logoutIcon}>🚪</Text>
        </TouchableOpacity>

        <Text style={styles.versionText}>Versión 1.0.0</Text>
      </ScrollView>
    </View>
  );
};

const styles = StyleSheet.create({
  tabContent: { flex: 1, paddingBottom: 68 },
  cartHeader: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: 20, paddingTop: 16, marginBottom: 12 },
  cartHeaderTitle: { flex: 1, textAlign: 'center', fontSize: 18, fontWeight: '800', color: '#0F172A' },
  aboutScrollPadding: { padding: 20, paddingBottom: 40 },
  aboutHeroCard: { backgroundColor: '#FFFFFF', borderRadius: 24, padding: 24, alignItems: 'center', marginBottom: 20, borderWidth: 1, borderColor: '#F1F5F9' },
  aboutHeroImage: { width: 90, height: 90, borderRadius: 20, marginBottom: 16 },
  aboutHeroTitle: { fontSize: 22, fontWeight: '900', color: '#0F172A', marginBottom: 8 },
  aboutHeroText: { fontSize: 14, color: '#64748B', textAlign: 'center', lineHeight: 22 },
  infoSection: { backgroundColor: '#FFFFFF', borderRadius: 24, padding: 20, marginBottom: 24, borderWidth: 1, borderColor: '#F1F5F9' },
  infoSectionTitle: { fontSize: 16, fontWeight: '800', color: '#0F172A', marginBottom: 16 },
  infoRow: { flexDirection: 'row', alignItems: 'center', marginBottom: 16 },
  infoIconWrapper: { width: 40, height: 40, backgroundColor: '#EFF6FF', borderRadius: 12, justifyContent: 'center', alignItems: 'center', marginRight: 14 },
  infoIcon: { fontSize: 18 },
  infoTextWrapper: { flex: 1 },
  infoLabel: { fontSize: 12, color: '#94A3B8', fontWeight: '600', marginBottom: 2 },
  infoValue: { fontSize: 14, fontWeight: '700', color: '#1E293B' },
  logoutButton: { backgroundColor: '#FEF2F2', borderColor: '#FECACA', borderWidth: 1, height: 52, borderRadius: 16, flexDirection: 'row', justifyContent: 'center', alignItems: 'center', marginBottom: 20 },
  logoutButtonText: { color: '#EF4444', fontSize: 15, fontWeight: '800', marginRight: 8 },
  logoutIcon: { fontSize: 16 },
  versionText: { textAlign: 'center', color: '#94A3B8', fontSize: 12, fontWeight: '600' },
});
