import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  SafeAreaView,
  StatusBar,
  Platform,
} from 'react-native';
import { DashboardScreen } from './DashboardScreen';
import { InventoryScreen } from './InventoryScreen';

interface AdminDashboardScreenProps {
  onLogout: () => void;
}

type TabType = 'dashboard' | 'products';

export const AdminDashboardScreen = ({ onLogout }: AdminDashboardScreenProps) => {
  const [activeTab, setActiveTab] = useState<TabType>('dashboard');

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="dark-content" backgroundColor="#FFFFFF" />

      {/* Global Admin Header */}
      <View style={styles.header}>
        <View style={styles.headerTitleBox}>
          <View style={styles.badgeRow}>
            <View style={styles.adminBadge}>
              <Text style={styles.adminBadgeText}>ADMIN PANEL</Text>
            </View>
            <Text style={styles.versionText}>v1.2.0</Text>
          </View>
          <Text style={styles.titleText}>Nic Store Console</Text>
        </View>
        <TouchableOpacity style={styles.logoutBtn} onPress={onLogout} activeOpacity={0.7}>
          <Text style={styles.logoutBtnText}>Salir 🚪</Text>
        </TouchableOpacity>
      </View>

      {/* Main Content Area */}
      <View style={styles.contentArea}>
        {activeTab === 'dashboard' ? (
          <DashboardScreen onLogout={onLogout} />
        ) : (
          <InventoryScreen />
        )}
      </View>

      {/* Custom Bottom Tab Bar */}
      <View style={styles.tabBar}>
        {/* Dashboard Tab Button */}
        <TouchableOpacity
          style={styles.tabButton}
          activeOpacity={0.8}
          onPress={() => setActiveTab('dashboard')}
        >
          <View style={[
            styles.tabIconContainer,
            activeTab === 'dashboard' && styles.tabIconContainerActive
          ]}>
            <Text style={[styles.tabEmoji, activeTab === 'dashboard' && styles.tabEmojiActive]}>
              📊
            </Text>
            <Text style={[styles.tabLabel, activeTab === 'dashboard' && styles.tabLabelActive]}>
              Dashboard
            </Text>
          </View>
          {activeTab === 'dashboard' && <View style={styles.tabIndicator} />}
        </TouchableOpacity>

        {/* Products Catalog Tab Button */}
        <TouchableOpacity
          style={styles.tabButton}
          activeOpacity={0.8}
          onPress={() => setActiveTab('products')}
        >
          <View style={[
            styles.tabIconContainer,
            activeTab === 'products' && styles.tabIconContainerActive
          ]}>
            <Text style={[styles.tabEmoji, activeTab === 'products' && styles.tabEmojiActive]}>
              📦
            </Text>
            <Text style={[styles.tabLabel, activeTab === 'products' && styles.tabLabelActive]}>
              Productos
            </Text>
          </View>
          {activeTab === 'products' && <View style={styles.tabIndicator} />}
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F8FAFC',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingVertical: 14,
    backgroundColor: '#FFFFFF',
    borderBottomWidth: 1,
    borderColor: '#E2E8F0',
    shadowColor: '#0F172A',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.02,
    shadowRadius: 4,
    elevation: 1,
  },
  headerTitleBox: {
    flex: 1,
  },
  badgeRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 4,
  },
  adminBadge: {
    backgroundColor: '#EF4444',
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 4,
    alignSelf: 'flex-start',
  },
  adminBadgeText: {
    color: '#FFFFFF',
    fontSize: 9,
    fontWeight: '800',
    letterSpacing: 0.5,
  },
  versionText: {
    fontSize: 9,
    fontWeight: '600',
    color: '#94A3B8',
    marginLeft: 6,
  },
  titleText: {
    fontSize: 18,
    fontWeight: '900',
    color: '#0F172A',
  },
  logoutBtn: {
    paddingHorizontal: 12,
    paddingVertical: 7,
    backgroundColor: '#FEF2F2',
    borderWidth: 1,
    borderColor: '#FECACA',
    borderRadius: 8,
  },
  logoutBtnText: {
    color: '#EF4444',
    fontSize: 12,
    fontWeight: '700',
  },
  contentArea: {
    flex: 1,
  },
  tabBar: {
    flexDirection: 'row',
    height: Platform.OS === 'ios' ? 76 : 64,
    backgroundColor: '#FFFFFF',
    borderTopWidth: 1,
    borderColor: '#E2E8F0',
    justifyContent: 'space-around',
    alignItems: 'center',
    paddingBottom: Platform.OS === 'ios' ? 14 : 0,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: -3 },
    shadowOpacity: 0.03,
    shadowRadius: 10,
    elevation: 10,
  },
  tabButton: {
    flex: 1,
    height: '100%',
    alignItems: 'center',
    justifyContent: 'center',
    position: 'relative',
  },
  tabIconContainer: {
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 4,
    paddingHorizontal: 16,
    borderRadius: 12,
  },
  tabIconContainerActive: {
    backgroundColor: '#EEF2FF', // Indigo 50
  },
  tabEmoji: {
    fontSize: 18,
    opacity: 0.6,
    ...Platform.select({
      web: { marginBottom: 2 } as any,
    }),
  },
  tabEmojiActive: {
    opacity: 1,
  },
  tabLabel: {
    fontSize: 11,
    fontWeight: '600',
    color: '#64748B',
    marginTop: 2,
  },
  tabLabelActive: {
    color: '#4F46E5', // Indigo 600
    fontWeight: '700',
  },
  tabIndicator: {
    position: 'absolute',
    top: 0,
    width: 40,
    height: 3,
    backgroundColor: '#4F46E5',
    borderBottomLeftRadius: 3,
    borderBottomRightRadius: 3,
  },
});
