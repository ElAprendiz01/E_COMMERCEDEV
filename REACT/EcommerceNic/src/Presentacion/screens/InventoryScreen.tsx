import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TextInput,
  TouchableOpacity,
  Image,
  Modal,
  Alert,
  Platform,
  ActivityIndicator,
} from 'react-native';
import { ContenedorFormularioTeclado } from '../components/ContenedorFormularioTeclado';
import { Product } from '../../Domain/entities/Product';
import {
  getProductsUseCase,
  createProductUseCase,
  updateProductUseCase,
  deleteProductUseCase,
} from '../../di/DI';
import { formatCurrency, CATEGORIES } from './constants';

export const InventoryScreen = () => {
  const [products, setProducts] = useState<Product[]>([]);
  const [search, setSearch] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  // Form Modal States
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingProduct, setEditingProduct] = useState<Product | null>(null);
  const [title, setTitle] = useState('');
  const [subtitle, setSubtitle] = useState('');
  const [price, setPrice] = useState('');
  const [brand, setBrand] = useState('');
  const [category, setCategory] = useState('hardware');
  const [tag, setTag] = useState('Nuevo');
  const [image, setImage] = useState('');

  useEffect(() => {
    loadProducts();
  }, []);

  const loadProducts = async () => {
    setIsLoading(true);
    try {
      const result = await getProductsUseCase.execute();
      setProducts(result);
    } catch (error: any) {
      Alert.alert('Error', error.message || 'No se pudieron cargar los productos');
    } finally {
      setIsLoading(false);
    }
  };

  const handleOpenCreateModal = () => {
    setEditingProduct(null);
    setTitle('');
    setSubtitle('');
    setPrice('');
    setBrand('');
    setCategory('hardware');
    setTag('Nuevo');
    setImage('https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=800&auto=format&fit=crop'); // default cool gaming pc/gear image
    setIsModalOpen(true);
  };

  const handleOpenEditModal = (product: Product) => {
    setEditingProduct(product);
    setTitle(product.title);
    setSubtitle(product.subtitle);
    setPrice(product.numericPrice.toString());
    setBrand(product.brand);
    setCategory(product.category);
    setTag(product.tag);
    setImage(product.image);
    setIsModalOpen(true);
  };

  const handleSaveProduct = async () => {
    if (!title.trim() || !subtitle.trim() || !price.trim() || !brand.trim() || !image.trim()) {
      Alert.alert('Campos incompletos', 'Por favor, llena todos los campos obligatorios.');
      return;
    }

    const numericPrice = parseFloat(price);
    if (isNaN(numericPrice) || numericPrice <= 0) {
      Alert.alert('Precio inválido', 'El precio debe ser un número mayor a cero.');
      return;
    }

    setIsLoading(true);
    try {
      if (editingProduct) {
        // Update product
        await updateProductUseCase.execute(editingProduct.id, {
          title: title.trim(),
          subtitle: subtitle.trim(),
          numericPrice,
          brand: brand.trim(),
          category,
          tag,
          image: image.trim(),
        });
        Alert.alert('Éxito', 'Producto actualizado correctamente');
      } else {
        // Create product
        await createProductUseCase.execute({
          title: title.trim(),
          subtitle: subtitle.trim(),
          numericPrice,
          brand: brand.trim(),
          category,
          tag,
          image: image.trim(),
        });
        Alert.alert('Éxito', 'Producto agregado al catálogo');
      }
      setIsModalOpen(false);
      loadProducts();
    } catch (error: any) {
      Alert.alert('Error', error.message || 'No se pudo guardar el producto');
    } finally {
      setIsLoading(false);
    }
  };

  const handleDeleteProduct = (product: Product) => {
    const confirmDelete = async () => {
      setIsLoading(true);
      try {
        const success = await deleteProductUseCase.execute(product.id);
        if (success) {
          Alert.alert('Eliminado', 'El producto ha sido eliminado.');
          loadProducts();
        }
      } catch (error: any) {
        Alert.alert('Error', error.message || 'No se pudo eliminar el producto');
      } finally {
        setIsLoading(false);
      }
    };

    if (Platform.OS === 'web') {
      const confirmWeb = window.confirm(`¿Estás seguro de eliminar "${product.title}"?`);
      if (confirmWeb) {
        confirmDelete();
      }
      return;
    }

    Alert.alert(
      'Eliminar Producto',
      `¿Estás seguro que deseas eliminar "${product.title}"? Esta acción no se puede deshacer.`,
      [
        { text: 'Cancelar', style: 'cancel' },
        { text: 'Sí, Eliminar', style: 'destructive', onPress: confirmDelete },
      ]
    );
  };

  const filteredProducts = products.filter(p =>
    p.title.toLowerCase().includes(search.toLowerCase()) ||
    p.brand.toLowerCase().includes(search.toLowerCase())
  );

  // Fictional metrics
  const totalProducts = products.length;
  const totalValue = products.reduce((acc, p) => acc + p.numericPrice, 0);

  return (
    <View style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollPadding} showsVerticalScrollIndicator={false}>
        {/* Stats Row */}
        <View style={styles.statsContainer}>
          <View style={styles.statCard}>
            <Text style={styles.statEmoji}>📦</Text>
            <Text style={styles.statNumber}>{totalProducts}</Text>
            <Text style={styles.statLabel}>Productos</Text>
          </View>
          <View style={[styles.statCard, styles.statCardBlue]}>
            <Text style={styles.statEmoji}>💰</Text>
            <Text style={styles.statNumber}>{formatCurrency(totalValue / 10)}</Text>
            <Text style={styles.statLabel}>Valor Total (Sim.)</Text>
          </View>
          <View style={styles.statCard}>
            <Text style={styles.statEmoji}>🏷️</Text>
            <Text style={styles.statNumber}>{CATEGORIES.length - 1}</Text>
            <Text style={styles.statLabel}>Categorías</Text>
          </View>
        </View>

        {/* Action Controls */}
        <View style={styles.controlsRow}>
          <View style={styles.searchContainer}>
            <Text style={styles.searchIcon}>🔍</Text>
            <TextInput
              placeholder="Buscar por nombre o marca..."
              placeholderTextColor="#94A3B8"
              value={search}
              onChangeText={setSearch}
              style={styles.searchInput}
            />
          </View>
          <TouchableOpacity style={styles.addProductBtn} onPress={handleOpenCreateModal}>
            <Text style={styles.addProductBtnText}>+ Agregar</Text>
          </TouchableOpacity>
        </View>

        {/* Section title */}
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Inventario de Catálogo</Text>
          {isLoading && <ActivityIndicator color="#4F46E5" size="small" />}
        </View>

        {/* Inventory List */}
        <View style={styles.listContainer}>
          {filteredProducts.length === 0 ? (
            <View style={styles.emptyContainer}>
              <Text style={styles.emptyEmoji}>🔎</Text>
              <Text style={styles.emptyText}>No se encontraron productos</Text>
            </View>
          ) : (
            filteredProducts.map(product => (
              <View key={product.id} style={styles.productRow}>
                <Image source={{ uri: product.image }} style={styles.productImage} />
                <View style={styles.productDetails}>
                  <Text style={styles.productTitle}>{product.title}</Text>
                  <View style={styles.tagsRow}>
                    <Text style={styles.tagLabel}>{CATEGORIES.find(c => c.id === product.category)?.name || product.category}</Text>
                    <Text style={[styles.tagLabel, styles.tagBrand]}>{product.brand}</Text>
                  </View>
                  <Text style={styles.productPrice}>{formatCurrency(product.numericPrice)}</Text>
                </View>
                <View style={styles.actionsBox}>
                  <TouchableOpacity
                    style={[styles.actionBtn, styles.editBtn]}
                    onPress={() => handleOpenEditModal(product)}
                  >
                    <Text style={styles.actionBtnText}>✏️</Text>
                  </TouchableOpacity>
                  <TouchableOpacity
                    style={[styles.actionBtn, styles.deleteBtn]}
                    onPress={() => handleDeleteProduct(product)}
                  >
                    <Text style={styles.actionBtnText}>🗑️</Text>
                  </TouchableOpacity>
                </View>
              </View>
            ))
          )}
        </View>
      </ScrollView>

      {/* CREATE / EDIT MODAL */}
      <Modal visible={isModalOpen} animationType="slide" transparent={true} onRequestClose={() => setIsModalOpen(false)}>
        <View style={styles.modalOverlay}>
          <ContenedorFormularioTeclado
            estiloContenedor={{ width: '100%' }}
            estiloScroll={[styles.modalContent, { paddingBottom: 40 }]}
          >
            <Text style={styles.modalTitle}>
              {editingProduct ? '✏️ Editar Producto' : '📦 Nuevo Producto'}
            </Text>
            <Text style={styles.modalSubtitle}>Llena los datos para actualizar el catálogo local.</Text>

            {/* Form Input fields */}
            <Text style={styles.formLabel}>Título del Producto *</Text>
            <TextInput style={styles.formInput} placeholder="Ej: PlayStation 5 Pro" placeholderTextColor="#94A3B8" value={title} onChangeText={setTitle} />

            <Text style={styles.formLabel}>Subtítulo / Descripción Corta *</Text>
            <TextInput style={styles.formInput} placeholder="Ej: 2TB SSD · Edición Especial" placeholderTextColor="#94A3B8" value={subtitle} onChangeText={setSubtitle} />

            <View style={styles.formInputRow}>
              <View style={{ flex: 1, marginRight: 8 }}>
                <Text style={styles.formLabel}>Precio (C$) *</Text>
                <TextInput style={styles.formInput} placeholder="Ej: 21500" placeholderTextColor="#94A3B8" keyboardType="numeric" value={price} onChangeText={setPrice} />
              </View>
              <View style={{ flex: 1, marginLeft: 8 }}>
                <Text style={styles.formLabel}>Marca *</Text>
                <TextInput style={styles.formInput} placeholder="Ej: Sony" placeholderTextColor="#94A3B8" value={brand} onChangeText={setBrand} />
              </View>
            </View>

            <Text style={styles.formLabel}>Categoría *</Text>
            <View style={styles.categoriesDropdown}>
              {CATEGORIES.filter(c => c.id !== 'all').map(c => (
                <TouchableOpacity
                  key={c.id}
                  style={[styles.dropdownPill, category === c.id && styles.dropdownPillActive]}
                  onPress={() => setCategory(c.id)}
                >
                  <Text style={[styles.dropdownPillText, category === c.id && styles.dropdownPillTextActive]}>
                    {c.name}
                  </Text>
                </TouchableOpacity>
              ))}
            </View>

            <Text style={styles.formLabel}>Etiqueta *</Text>
            <View style={styles.categoriesDropdown}>
              {['Nuevo', '🔥 Top', 'Popular', 'Oferta'].map(t => (
                <TouchableOpacity
                  key={t}
                  style={[styles.dropdownPill, tag === t && styles.dropdownPillActive]}
                  onPress={() => setTag(t)}
                >
                  <Text style={[styles.dropdownPillText, tag === t && styles.dropdownPillTextActive]}>
                    {t}
                  </Text>
                </TouchableOpacity>
              ))}
            </View>

            <Text style={styles.formLabel}>URL de Imagen *</Text>
            <TextInput style={styles.formInput} placeholder="Ej: https://..." placeholderTextColor="#94A3B8" value={image} onChangeText={setImage} />

            {/* Action Buttons inside modal */}
            <View style={styles.modalActionsRow}>
              <TouchableOpacity style={[styles.modalBtn, styles.modalCancel]} onPress={() => setIsModalOpen(false)}>
                <Text style={styles.modalCancelText}>Cancelar</Text>
              </TouchableOpacity>
              <TouchableOpacity style={[styles.modalBtn, styles.modalSave]} onPress={handleSaveProduct}>
                <Text style={styles.modalSaveText}>Guardar</Text>
              </TouchableOpacity>
            </View>
          </ContenedorFormularioTeclado>
        </View>
      </Modal>
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#F8FAFC' },
  scrollPadding: { paddingHorizontal: 20, paddingTop: 10, paddingBottom: 40 },

  // Stats
  statsContainer: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 20 },
  statCard: {
    flex: 1,
    backgroundColor: '#FFFFFF',
    borderRadius: 16,
    padding: 12,
    borderWidth: 1,
    borderColor: '#E2E8F0',
    alignItems: 'center',
    marginHorizontal: 4,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.02,
    shadowRadius: 6,
    elevation: 1,
  },
  statCardBlue: { borderColor: '#E0E7FF', backgroundColor: '#EEF2FF' },
  statEmoji: { fontSize: 18, marginBottom: 2 },
  statNumber: { fontSize: 14, fontWeight: '800', color: '#0F172A' },
  statLabel: { fontSize: 10, color: '#64748B', marginTop: 2, fontWeight: '600' },

  // Controls Row
  controlsRow: { flexDirection: 'row', alignItems: 'center', marginBottom: 20 },
  searchContainer: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
    borderWidth: 1,
    borderColor: '#E2E8F0',
    borderRadius: 12,
    height: 44,
    paddingHorizontal: 12,
    marginRight: 10,
  },
  searchIcon: { fontSize: 14, marginRight: 8 },
  searchInput: {
    flex: 1,
    fontSize: 13,
    color: '#0F172A',
    ...Platform.select({
      web: { outlineStyle: 'none' } as any,
    }),
  },
  addProductBtn: {
    backgroundColor: '#4F46E5',
    height: 44,
    borderRadius: 12,
    paddingHorizontal: 16,
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#4F46E5',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.15,
    shadowRadius: 4,
    elevation: 2,
  },
  addProductBtnText: { color: '#FFFFFF', fontSize: 13, fontWeight: '700' },

  sectionHeader: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginBottom: 12 },
  sectionTitle: { fontSize: 13, fontWeight: '800', color: '#64748B', textTransform: 'uppercase', letterSpacing: 0.5 },

  // Inventory list
  listContainer: { backgroundColor: '#FFFFFF', borderRadius: 20, borderWidth: 1, borderColor: '#E2E8F0', overflow: 'hidden' },
  productRow: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 14,
    borderBottomWidth: 1,
    borderBottomColor: '#F1F5F9',
  },
  productImage: { width: 50, height: 50, borderRadius: 8, backgroundColor: '#F8FAFC' },
  productDetails: { flex: 1, marginLeft: 12 },
  productTitle: { fontSize: 14, fontWeight: '700', color: '#0F172A' },
  tagsRow: { flexDirection: 'row', marginTop: 4 },
  tagLabel: {
    fontSize: 9,
    color: '#4F46E5',
    backgroundColor: '#EEF2FF',
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 4,
    marginRight: 6,
    fontWeight: '700',
  },
  tagBrand: { color: '#475569', backgroundColor: '#F1F5F9' },
  productPrice: { fontSize: 13, fontWeight: '800', color: '#0F172A', marginTop: 4 },

  actionsBox: { flexDirection: 'row', alignItems: 'center' },
  actionBtn: { width: 34, height: 34, borderRadius: 8, justifyContent: 'center', alignItems: 'center', marginLeft: 8 },
  editBtn: { backgroundColor: '#EEF2FF' },
  deleteBtn: { backgroundColor: '#FEF2F2' },
  actionBtnText: { fontSize: 14 },

  emptyContainer: { padding: 40, alignItems: 'center' },
  emptyEmoji: { fontSize: 32, marginBottom: 8 },
  emptyText: { color: '#94A3B8', fontSize: 13, fontWeight: '600' },

  // Modal styling
  modalOverlay: { flex: 1, backgroundColor: 'rgba(15, 23, 42, 0.6)', justifyContent: 'flex-end' },
  modalContent: {
    backgroundColor: '#FFFFFF',
    borderTopLeftRadius: 24,
    borderTopRightRadius: 24,
    padding: 24,
    maxHeight: '90%',
  },
  modalTitle: { fontSize: 18, fontWeight: '900', color: '#0F172A', marginBottom: 4 },
  modalSubtitle: { fontSize: 13, color: '#64748B', fontWeight: '500', marginBottom: 20 },
  formLabel: { fontSize: 12, fontWeight: '700', color: '#334155', marginBottom: 6, marginTop: 12 },
  formInput: {
    backgroundColor: '#F8FAFC',
    borderWidth: 1.5,
    borderColor: '#E2E8F0',
    borderRadius: 12,
    height: 44,
    paddingHorizontal: 14,
    fontSize: 14,
    color: '#0F172A',
  },
  formInputRow: { flexDirection: 'row' },
  categoriesDropdown: { flexDirection: 'row', flexWrap: 'wrap', marginTop: 4 },
  dropdownPill: {
    backgroundColor: '#F1F5F9',
    borderRadius: 10,
    paddingHorizontal: 12,
    paddingVertical: 6,
    marginRight: 8,
    marginBottom: 8,
    borderWidth: 1,
    borderColor: '#E2E8F0',
  },
  dropdownPillActive: { backgroundColor: '#4F46E5', borderColor: '#4F46E5' },
  dropdownPillText: { fontSize: 11, color: '#64748B', fontWeight: '600' },
  dropdownPillTextActive: { color: '#FFFFFF' },

  modalActionsRow: { flexDirection: 'row', justifyContent: 'space-between', marginTop: 24 },
  modalBtn: { flex: 1, height: 46, borderRadius: 12, justifyContent: 'center', alignItems: 'center' },
  modalCancel: { backgroundColor: '#F1F5F9', marginRight: 8 },
  modalCancelText: { color: '#475569', fontSize: 14, fontWeight: '700' },
  modalSave: { backgroundColor: '#4F46E5', marginLeft: 8 },
  modalSaveText: { color: '#FFFFFF', fontSize: 14, fontWeight: '700' },
});
