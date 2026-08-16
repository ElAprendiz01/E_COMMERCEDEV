import React, { useState, useRef } from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  Animated,
  StyleSheet,
  ScrollView,
  Platform
} from 'react-native';
import Icon from '@react-native-vector-icons/ionicons';

interface Props {
  conversations: { id: string; title?: string }[];
  activeConversationId: string | null;
  onSelectConversation: (id: string) => void;
  onNewConversation?: () => void;
  children?: React.ReactNode;
}

export const SidebarHistorial = ({ 
  conversations, 
  activeConversationId, 
  onSelectConversation, 
  onNewConversation,
  children 
}: Props) => {
  const [isOpen, setIsOpen] = useState(false);
  
  // Animaciones
  const slideAnim = useRef(new Animated.Value(-300)).current; 
  const fadeAnim = useRef(new Animated.Value(0)).current;

  const toggleSidebar = () => {
    if (isOpen) {
      Animated.parallel([
        Animated.timing(slideAnim, {
          toValue: -300,
          duration: 300,
          useNativeDriver: true,
        }),
        Animated.timing(fadeAnim, {
          toValue: 0,
          duration: 300,
          useNativeDriver: true,
        })
      ]).start(() => setIsOpen(false));
    } else {
      setIsOpen(true);
      Animated.parallel([
        Animated.timing(slideAnim, {
          toValue: 0,
          duration: 300,
          useNativeDriver: true,
        }),
        Animated.timing(fadeAnim, {
          toValue: 1,
          duration: 300,
          useNativeDriver: true,
        })
      ]).start();
    }
  };

  const handleSelect = (id: string) => {
    onSelectConversation(id);
    toggleSidebar();
  };

  const handleNewChat = () => {
    if (onNewConversation) {
      onNewConversation();
    }
    toggleSidebar();
  };

  return (
    <View style={styles.container}>
      {/* Contenedor principal que muestra el ChatbotTab */}
      <View style={styles.mainContent}>
        {children}
        
        {/* Botón flotante de hamburguesa */}
        <TouchableOpacity style={styles.menuButton} onPress={toggleSidebar}>
          <Icon name="menu-outline" size={28} color="#1E293B" />
        </TouchableOpacity>
      </View>

      {/* Fondo oscuro semitransparente */}
      {isOpen && (
        <Animated.View style={[styles.overlay, { opacity: fadeAnim }]}>
          <TouchableOpacity style={{ flex: 1 }} onPress={toggleSidebar} activeOpacity={1} />
        </Animated.View>
      )}

      {/* Menú Lateral Desplegable */}
      <Animated.View style={[styles.sidebar, { transform: [{ translateX: slideAnim }] }]}>
        <View style={styles.sidebarHeader}>
          <Text style={styles.sidebarTitle}>Historial</Text>
          <TouchableOpacity onPress={toggleSidebar}>
            <Icon name="close-outline" size={26} color="#94A3B8" />
          </TouchableOpacity>
        </View>

        {/* Botón + Nueva Conversación en el Sidebar */}
        <TouchableOpacity style={styles.newChatButton} onPress={handleNewChat}>
          <Icon name="add-circle-outline" size={22} color="#FFFFFF" style={{ marginRight: 8 }} />
          <Text style={styles.newChatText}>Nueva conversación</Text>
        </TouchableOpacity>

        <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scrollContent}>
          {conversations.length === 0 ? (
            <Text style={styles.emptyText}>No hay historial aún.</Text>
          ) : (
            conversations.map((conv) => (
              <TouchableOpacity
                key={conv.id}
                style={[
                  styles.conversationItem,
                  activeConversationId === conv.id && styles.activeItem,
                ]}
                onPress={() => handleSelect(conv.id)}
              >
                <Icon 
                  name="chatbubble-outline" 
                  size={18} 
                  color={activeConversationId === conv.id ? '#FFFFFF' : '#64748B'} 
                  style={styles.chatIcon}
                />
                <Text
                  style={[
                    styles.conversationText,
                    activeConversationId === conv.id && styles.activeText,
                  ]}
                  numberOfLines={1}
                >
                  {conv.title ?? 'Nueva conversación'}
                </Text>
              </TouchableOpacity>
            ))
          )}
        </ScrollView>
      </Animated.View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F8FAFC',
  },
  mainContent: {
    flex: 1,
    position: 'relative',
  },
  menuButton: {
    position: 'absolute',
    top: Platform.OS === 'ios' ? 50 : 16,
    left: 16,
    zIndex: 10,
    backgroundColor: '#FFFFFF',
    borderRadius: 12,
    padding: 8,
    shadowColor: '#000',
    shadowOpacity: 0.1,
    shadowRadius: 4,
    shadowOffset: { width: 0, height: 2 },
    elevation: 4,
  },
  overlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(15, 23, 42, 0.6)',
    zIndex: 20,
  },
  sidebar: {
    position: 'absolute',
    top: 0,
    bottom: 0,
    left: 0,
    width: 280,
    backgroundColor: '#1E293B',
    zIndex: 30,
    shadowColor: '#000',
    shadowOffset: { width: 4, height: 0 },
    shadowOpacity: 0.3,
    shadowRadius: 6,
    elevation: 15,
  },
  sidebarHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingTop: Platform.OS === 'ios' ? 60 : 30,
    paddingBottom: 16,
    paddingHorizontal: 20,
    borderBottomWidth: 1,
    borderBottomColor: '#334155',
  },
  sidebarTitle: {
    color: '#F1F5F9',
    fontSize: 20,
    fontWeight: 'bold',
  },
  newChatButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#3B82F6',
    marginHorizontal: 16,
    marginTop: 16,
    marginBottom: 8,
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 10,
  },
  newChatText: {
    color: '#FFFFFF',
    fontSize: 15,
    fontWeight: '600',
  },
  scrollContent: {
    padding: 16,
    paddingBottom: 40,
  },
  conversationItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 14,
    paddingHorizontal: 12,
    marginBottom: 8,
    borderRadius: 10,
  },
  activeItem: {
    backgroundColor: '#334155',
  },
  chatIcon: {
    marginRight: 12,
  },
  conversationText: {
    color: '#CBD5E1',
    fontSize: 15,
    flex: 1,
  },
  activeText: {
    color: '#FFFFFF',
    fontWeight: '600',
  },
  emptyText: {
    color: '#64748B',
    textAlign: 'center',
    marginTop: 40,
  },
});