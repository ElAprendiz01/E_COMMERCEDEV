import React, { useState, useEffect, useRef, useMemo, useCallback } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  ScrollView,
  TextInput,
  TouchableOpacity,
  Image,
  Platform,
  Animated,
  ActivityIndicator,
  useWindowDimensions,
} from 'react-native';
import { formatCurrency } from '../constants';
import { Product } from '../../../Domain/entities/Product';
import { SubCategory } from '../../../Domain/entities/SubCategory';
import { useDebounce } from '../../hooks/useDebounce';
import { useProducts } from '../../hooks/useProducts';
import { useMarks } from '../../hooks/useMarks';
import { useSubCategories } from '../../hooks/useSubCategories';
import { ProductImage } from '../../components/ProductImage';
import { BrandCarousel } from './BrandCarousel';

interface CatalogTabProps {
  products?: Product[];
  cartQuantities: { [key: string]: number };
  variantesAgotadas?: { [key: string]: boolean };
  addUnit: (id: string) => void;
  removeUnit: (id: string) => void;
  setCurrentTab: (tab: 'home' | 'cart' | 'chatbot' | 'nosotros') => void;
  totalItemsInCart: number;
  onSelectProduct?: (productId: string | number) => void;
}

const SUBCATEGORY_ICONS: { [key: string]: string } = {
  masculino: '👕',
  femenino: '👗',
  niños: '👦',
  niñas: '👧',
  celulares: '📱',
  computadoras: '💻',
  componentes: '🖥️',
  hardware: '🖥️',
  calzado: '👟',
  consolas: '🎮',
};

const SUBCATEGORY_KEYWORDS: { [key: string]: string[] } = {
  celulares: ['celular', 'celulares', 'phone', 'smartphone', 'mobile', 'iphone', 'galaxy', 'xperia', 'redmi', 'infinix', 'pixel', 'pro max', 'ultra'],
  computadoras: ['computadora', 'computadoras', 'laptop', 'laptops', 'pc ', 'desktop', 'macbook', 'dell xps'],
  'componentes de laptop': ['disco duro', 'memoria ram', 'pantalla laptop', 'teclado laptop'],
  'hardware y periféricos': ['mouse', 'teclado gamer', 'audífono', 'headset', 'camara', 'webcam', 'monitor'],
  'consolas de videojuegos': ['consola', 'consolas', 'playstation', 'ps5', 'ps4', 'xbox', 'nintendo', 'switch'],
  'calzado deportivo': ['zapatillas', 'calzado', 'tenis', 'zapato', 'zapatos', 'air max', 'pegasus', 'revolution', 'flyease'],
  masculino: ['masculino', 'ropa hombre', 'camisa hombre', 'pantalon hombre'],
  femenino: ['femenino', 'ropa mujer', 'vestido', 'blusa'],
  niños: ['ropa niños', 'camisa niños'],
  niñas: ['ropa niñas', 'vestido niñas'],
};

const getSubCategoryIcon = (name: string): string => {
  const clean = (name || '').toLowerCase();
  for (const key in SUBCATEGORY_ICONS) {
    if (clean.includes(key)) {
      return SUBCATEGORY_ICONS[key];
    }
  }
  return '📦';
};

const matchesSubCategory = (product: Product, subCategoryName: string): boolean => {
  const rawP = product as any;
  const title = (product.title || rawP.name || '').toLowerCase();
  const subtitle = (product.subtitle || '').toLowerCase();
  const desc = (rawP.description || '').toLowerCase();
  const text = `${title} ${subtitle} ${product.brand || ''} ${product.category || ''} ${desc}`.toLowerCase();
  const subNameClean = (subCategoryName || '').toLowerCase().trim();

  // Exclusión estricta: Si el producto es Zapatilla / Calzado, jamás es una Computadora ni Consola
  const isShoes = title.includes('zapatilla') || title.includes('calzado') || title.includes('tenis') || title.includes('zapato') || title.includes('air max') || title.includes('pegasus');
  if (isShoes && (subNameClean.includes('computadora') || subNameClean.includes('laptop') || subNameClean.includes('consola') || subNameClean.includes('componente'))) {
    return false;
  }

  // Coincidencia directa de nombre
  if (text.includes(subNameClean)) return true;

  // Coincidencia por palabras clave
  for (const key in SUBCATEGORY_KEYWORDS) {
    if (subNameClean.includes(key) || key.includes(subNameClean)) {
      const keywords = SUBCATEGORY_KEYWORDS[key];
      if (keywords.some(kw => text.includes(kw))) {
        return true;
      }
    }
  }

  return false;
};

const SkeletonCard = () => {
  const shimmerAnim = useRef(new Animated.Value(0.3)).current;

  useEffect(() => {
    Animated.loop(
      Animated.sequence([
        Animated.timing(shimmerAnim, {
          toValue: 0.7,
          duration: 800,
          useNativeDriver: true,
        }),
        Animated.timing(shimmerAnim, {
          toValue: 0.3,
          duration: 800,
          useNativeDriver: true,
        }),
      ])
    ).start();
  }, [shimmerAnim]);

  return (
    <Animated.View style={[styles.card, { opacity: shimmerAnim }]}>
      <View style={[styles.imageWrapper, { backgroundColor: '#E2E8F0' }]} />
      <View style={styles.cardInfo}>
        <View style={{ height: 12, backgroundColor: '#E2E8F0', borderRadius: 4, width: '40%', marginBottom: 6 }} />
        <View style={{ height: 16, backgroundColor: '#E2E8F0', borderRadius: 4, width: '85%', marginBottom: 4 }} />
        <View style={{ height: 12, backgroundColor: '#E2E8F0', borderRadius: 4, width: '60%', marginBottom: 12 }} />
        <View style={{ height: 20, backgroundColor: '#E2E8F0', borderRadius: 6, width: '50%' }} />
      </View>
      <View style={{ height: 36, backgroundColor: '#E2E8F0', borderRadius: 10, marginTop: 12 }} />
    </Animated.View>
  );
};

// Componente de Tarjeta de Producto Memoizado a Nivel Superior (Sin parpadeos)
const ProductCardItem = React.memo(({
  product,
  currentQuantity,
  isOutTracked,
  addUnit,
  removeUnit,
  onSelectProduct,
  cardStyle,
  imageWrapperStyle,
}: {
  product: Product;
  currentQuantity: number;
  isOutTracked?: boolean;
  addUnit: (id: string) => void;
  removeUnit: (id: string) => void;
  onSelectProduct?: (productId: string | number) => void;
  cardStyle?: any;
  imageWrapperStyle?: any;
}) => {
  const targetId = product.productId ?? (product as any).productID ?? (product as any).ProductID ?? product.id ?? product.productVariableId;
  const rawStock = product.stockAvailable ?? 0;
  const availableStock = Math.max(0, rawStock - currentQuantity);
  const isStockOut = !!isOutTracked || (availableStock <= 0 && currentQuantity === 0);

  return (
    <View style={[styles.card, cardStyle]}>
      <TouchableOpacity 
        activeOpacity={0.8} 
        onPress={() => targetId && onSelectProduct?.(targetId)}
      >
        <View style={[styles.imageWrapper, imageWrapperStyle]}>
          <ProductImage url={product.image} style={styles.productImage} resizeMode="contain" />
          <View style={styles.tagsContainer}>
            {isStockOut ? (
              <Text style={styles.outOfStockTag}>🔴 AGOTADO</Text>
            ) : product.tag ? (
              <Text style={styles.topTag}>{product.tag}</Text>
            ) : null}
            <Text style={styles.brandTag}>{product.brand.toUpperCase()}</Text>
          </View>
        </View>
        <View style={styles.cardInfo}>
          <Text style={styles.productBrand} numberOfLines={1}>{product.brand.toUpperCase()}</Text>
          <Text style={styles.productTitle} numberOfLines={1}>{product.title}</Text>
          <Text style={styles.productSubtitle} numberOfLines={1}>{product.subtitle}</Text>
        </View>
      </TouchableOpacity>

      <View style={styles.priceRow}>
        <View>
          <Text style={styles.priceLabel}>PRECIO</Text>
          <Text style={styles.productPrice}>{formatCurrency(product.numericPrice)}</Text>
        </View>
        
        {currentQuantity > 0 ? (
          <View style={styles.quantityContainerMini}>
            <TouchableOpacity style={styles.miniQtyBtn} onPress={() => removeUnit(product.id)}>
              <Text style={styles.miniQtyBtnText}>-</Text>
            </TouchableOpacity>
            <Text style={styles.miniQtyText}>{currentQuantity}</Text>
            <TouchableOpacity style={styles.miniQtyBtn} onPress={() => addUnit(product.id)}>
              <Text style={styles.miniQtyBtnText}>+</Text>
            </TouchableOpacity>
          </View>
        ) : isStockOut ? (
          <TouchableOpacity 
            style={styles.seeOptionsCardButton} 
            activeOpacity={0.8} 
            onPress={() => targetId && onSelectProduct?.(targetId)}
          >
            <Text style={styles.seeOptionsCardButtonText}>🔍 Ver opciones</Text>
          </TouchableOpacity>
        ) : (
          <TouchableOpacity 
            style={styles.addToCartCardButton} 
            activeOpacity={0.8} 
            onPress={() => addUnit(product.id)}
          >
            <Text style={styles.addToCartCardButtonText}>🛒 Agregar</Text>
          </TouchableOpacity>
        )}
      </View>
    </View>
  );
});

// Componente de Cabecera Memoizado a Nivel Superior (Con Subcategorías de SQL Server)
const CatalogHeader = React.memo(({
  search,
  setSearch,
  subCategorias,
  subCategoriaSeleccionadaId,
  onSeleccionarSubCategoria,
  totalItemsInCart,
  setCurrentTab,
  marcas,
  marcaSeleccionadaId,
  seleccionarMarca,
  onLimpiarTodo,
}: {
  search: string;
  setSearch: (text: string) => void;
  subCategorias: SubCategory[];
  subCategoriaSeleccionadaId: number | null;
  onSeleccionarSubCategoria: (id: number | null) => void;
  totalItemsInCart: number;
  setCurrentTab: (tab: any) => void;
  marcas: any[];
  marcaSeleccionadaId: number | null;
  seleccionarMarca: (id: number | null) => void;
  onLimpiarTodo: () => void;
}) => {
  return (
    <View style={styles.headerWrapper}>
      <View style={styles.header}>
        <View style={styles.profileSection}>
          <Image source={require('../../../../assets/logo.png')} style={styles.logoImage} resizeMode="contain" />
          <View style={styles.textContainer}>
            <Text style={styles.storeName}>Nic Store</Text>
            <Text style={styles.onlineStatus}>● En línea</Text>
          </View>
        </View>
        <View style={styles.headerIcons}>
          <TouchableOpacity style={styles.iconButton}>
            <Text style={styles.emojiIcon}>🔔</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.iconButton} onPress={() => setCurrentTab('cart')}>
            <Text style={styles.emojiIcon}>🛒</Text>
            {totalItemsInCart > 0 && (
              <View style={styles.cartBadge}>
                <Text style={styles.cartBadgeText}>{totalItemsInCart}</Text>
              </View>
            )}
          </TouchableOpacity>
        </View>
      </View>

      {/* Buscador Inmutable */}
      <View style={styles.searchContainer}>
        <Text style={styles.searchIcon}>🔍</Text>
        <TextInput
          placeholder="Buscar productos..."
          placeholderTextColor="#94A3B8"
          value={search}
          onChangeText={setSearch}
          style={styles.searchInput}
        />
      </View>

      {/* Carrusel Horizontal de Subcategorías Reales de SQL Server */}
      <View style={styles.categoriesContainer}>
        <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={{ paddingLeft: 20, paddingRight: 20 }}>
          <TouchableOpacity
            onPress={() => onSeleccionarSubCategoria(null)}
            style={[styles.categoryPill, subCategoriaSeleccionadaId === null && styles.categoryPillActive]}
            activeOpacity={0.8}
          >
            <Text style={[styles.categoryText, subCategoriaSeleccionadaId === null && styles.categoryTextActive]}>
              ⚡ Todo
            </Text>
          </TouchableOpacity>

          {subCategorias.map((sub) => {
            const isSelected = subCategoriaSeleccionadaId === sub.subCategoryId;
            const icon = getSubCategoryIcon(sub.subCategoryName);

            return (
              <TouchableOpacity
                key={sub.subCategoryId}
                onPress={() => onSeleccionarSubCategoria(sub.subCategoryId)}
                style={[styles.categoryPill, isSelected && styles.categoryPillActive]}
                activeOpacity={0.8}
              >
                <Text style={[styles.categoryText, isSelected && styles.categoryTextActive]}>
                  {icon} {sub.subCategoryName}
                </Text>
              </TouchableOpacity>
            );
          })}
        </ScrollView>
      </View>

      {/* Carrusel Horizontal de Marcas Populares */}
      <BrandCarousel
        marcas={marcas}
        marcaSeleccionadaId={marcaSeleccionadaId}
        onSeleccionarMarca={seleccionarMarca}
      />

      <View style={styles.sectionHeader}>
        <Text style={styles.sectionTitle}>Catálogo de Productos</Text>
        <TouchableOpacity onPress={onLimpiarTodo}>
          <Text style={styles.seeAllLink}>Ver todo</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
});

export const CatalogTab = ({
  products: initialProducts,
  cartQuantities,
  variantesAgotadas,
  addUnit,
  removeUnit,
  setCurrentTab,
  totalItemsInCart,
  onSelectProduct,
}: CatalogTabProps) => {
  const [search, setSearch] = useState('');
  const debouncedSearch = useDebounce(search, 400);

  const { marcas, marcaSeleccionadaId, seleccionarMarca } = useMarks();
  const { subCategorias, subCategoriaSeleccionadaId, seleccionarSubCategoria } = useSubCategories();

  // Consultar API pasando solo la búsqueda por texto del usuario para no limitar la consulta
  const {
    data,
    fetchNextPage,
    hasNextPage,
    isFetchingNextPage,
    isLoading,
    isError,
    error,
    refetch,
  } = useProducts(debouncedSearch);

  const displayProductsRaw: Product[] = data?.pages
    ? data.pages.flatMap(page => page.mappedProducts || [])
    : (initialProducts || []);

  const displayProducts = useMemo(() => {
    // Agrupar filas de variantes por modelo de producto (productId)
    const productGroups = new Map<number, Product[]>();

    displayProductsRaw.forEach(p => {
      if (!p) return;
      const baseId = p.productId || Number(p.id);
      if (!productGroups.has(baseId)) {
        productGroups.set(baseId, []);
      }
      productGroups.get(baseId)!.push(p);
    });

    const chosenProducts: Product[] = [];

    productGroups.forEach((rows) => {
      // Tomar la variante por defecto (rows[0]) respetando su stock real devuelto por SQL Server
      const selected = rows[0];

      chosenProducts.push({
        ...selected,
      });
    });

    let filtered = chosenProducts;

    // Filtrar por Marca seleccionada
    if (marcaSeleccionadaId !== null) {
      const marcaObj = marcas.find(m => m.markId === marcaSeleccionadaId);
      if (marcaObj) {
        const nombreMarca = marcaObj.markName.toLowerCase();
        filtered = filtered.filter(p => {
          const rawP = p as any;
          const title = (p.title || rawP.name || '').toLowerCase();
          const subtitle = (p.subtitle || '').toLowerCase();
          const desc = (rawP.description || '').toLowerCase();
          return title.includes(nombreMarca) || subtitle.includes(nombreMarca) || desc.includes(nombreMarca);
        });
      }
    }

    // Filtrar por Subcategoría seleccionada con sistema inteligente de palabras clave
    if (subCategoriaSeleccionadaId !== null) {
      const subObj = subCategorias.find(s => s.subCategoryId === subCategoriaSeleccionadaId);
      if (subObj) {
        filtered = filtered.filter(p => matchesSubCategory(p, subObj.subCategoryName));
      }
    }

    return filtered;
  }, [displayProductsRaw, marcaSeleccionadaId, marcas, subCategoriaSeleccionadaId, subCategorias]);

  const handleEndReached = () => {
    if (hasNextPage && !isFetchingNextPage) {
      fetchNextPage();
    }
  };

  const handleLimpiarTodo = () => {
    setSearch('');
    seleccionarSubCategoria(null);
    seleccionarMarca(null);
  };

  const subObjActivo = useMemo(() => {
    return subCategorias.find(s => s.subCategoryId === subCategoriaSeleccionadaId);
  }, [subCategorias, subCategoriaSeleccionadaId]);

  const { width: windowWidth } = useWindowDimensions();

  const numColumns = useMemo(() => {
    if (windowWidth >= 1100) return 4;
    if (windowWidth >= 680) return 3;
    return 2;
  }, [windowWidth]);

  const dynamicCardStyle = useMemo(() => {
    if (windowWidth >= 1100) {
      return { width: '23.5%', marginBottom: 18 };
    }
    if (windowWidth >= 680) {
      return { width: '31.5%', marginBottom: 18 };
    }
    return { width: '48%', marginBottom: 16 };
  }, [windowWidth]);

  const dynamicImageWrapperStyle = useMemo(() => {
    if (windowWidth >= 1100) {
      return { height: 170 };
    }
    if (windowWidth >= 680) {
      return { height: 155 };
    }
    return { height: 135 };
  }, [windowWidth]);

  const renderFooter = () => {
    if (isFetchingNextPage) {
      return (
        <View style={styles.footerLoading}>
          <ActivityIndicator size="small" color="#4F46E5" />
          <Text style={styles.footerLoadingText}>Cargando más productos...</Text>
        </View>
      );
    }
    if (!hasNextPage && displayProducts.length > 0) {
      return (
        <View style={styles.footerEnd}>
          <Text style={styles.footerEndText}>📦 Has visto todos los productos disponibles</Text>
        </View>
      );
    }
    return null;
  };

  const renderItem = useCallback(
    ({ item: product }: { item: Product }) => (
      <ProductCardItem
        product={product}
        currentQuantity={cartQuantities[product.id] || 0}
        isOutTracked={!!(variantesAgotadas && (variantesAgotadas[product.id] || variantesAgotadas[String(product.productVariableId)] || variantesAgotadas[String(product.productId)]))}
        addUnit={addUnit}
        removeUnit={removeUnit}
        onSelectProduct={onSelectProduct}
        cardStyle={dynamicCardStyle}
        imageWrapperStyle={dynamicImageWrapperStyle}
      />
    ),
    [cartQuantities, variantesAgotadas, addUnit, removeUnit, onSelectProduct, dynamicCardStyle, dynamicImageWrapperStyle]
  );

  const headerComponent = useMemo(() => (
    <CatalogHeader
      search={search}
      setSearch={setSearch}
      subCategorias={subCategorias}
      subCategoriaSeleccionadaId={subCategoriaSeleccionadaId}
      onSeleccionarSubCategoria={seleccionarSubCategoria}
      totalItemsInCart={totalItemsInCart}
      setCurrentTab={setCurrentTab}
      marcas={marcas}
      marcaSeleccionadaId={marcaSeleccionadaId}
      seleccionarMarca={seleccionarMarca}
      onLimpiarTodo={handleLimpiarTodo}
    />
  ), [
    search,
    subCategorias,
    subCategoriaSeleccionadaId,
    totalItemsInCart,
    setCurrentTab,
    marcas,
    marcaSeleccionadaId,
    seleccionarMarca,
    seleccionarSubCategoria,
  ]);

  return (
    <View style={styles.tabContent}>
      {isLoading ? (
        <View style={{ flex: 1 }}>
          {headerComponent}
          <View style={styles.grid}>
            <SkeletonCard />
            <SkeletonCard />
            <SkeletonCard />
            <SkeletonCard />
          </View>
        </View>
      ) : isError ? (
        <View style={{ flex: 1 }}>
          {headerComponent}
          <View style={styles.emptyContainer}>
            <Text style={{ fontSize: 40, marginBottom: 12 }}>📡</Text>
            <Text style={{ fontSize: 16, fontWeight: '700', color: '#0F172A' }}>Error al cargar productos</Text>
            <Text style={{ fontSize: 13, color: '#64748B', marginTop: 4, textAlign: 'center', paddingHorizontal: 20 }}>
              {(error as any)?.message || 'No se pudo conectar con el servidor.'}
            </Text>
            <TouchableOpacity style={styles.retryButton} onPress={() => refetch()}>
              <Text style={styles.retryButtonText}>Reintentar</Text>
            </TouchableOpacity>
          </View>
        </View>
      ) : (
        <FlatList
          key={`grid-cols-${numColumns}`}
          data={displayProducts}
          keyExtractor={(item) => String(item.id)}
          numColumns={numColumns}
          columnWrapperStyle={[
            styles.row,
            {
              justifyContent: numColumns > 2 ? 'flex-start' : 'space-between',
              gap: numColumns > 2 ? 14 : 0,
            },
          ]}
          renderItem={renderItem}
          ListHeaderComponent={headerComponent}
          ListFooterComponent={renderFooter}
          ListEmptyComponent={
            <View style={styles.emptyContainer}>
              <Text style={{ fontSize: 40, marginBottom: 12 }}>
                {subCategoriaSeleccionadaId !== null ? '📱' : '🔍'}
              </Text>
              <Text style={{ fontSize: 16, fontWeight: '700', color: '#0F172A', textAlign: 'center' }}>
                {subCategoriaSeleccionadaId !== null && subObjActivo
                  ? `Sin resultados para "${subObjActivo.subCategoryName}"`
                  : 'No hay productos que coincidan'}
              </Text>
              <Text style={{ fontSize: 13, color: '#64748B', marginTop: 4, textAlign: 'center', paddingHorizontal: 20 }}>
                {subCategoriaSeleccionadaId !== null
                  ? 'Intenta seleccionar otra subcategoría o ver la lista completa de productos.'
                  : 'Prueba seleccionando otra subcategoría, marca o limpiando los filtros.'}
              </Text>
              <TouchableOpacity
                style={styles.retryButton}
                onPress={handleLimpiarTodo}
              >
                <Text style={styles.retryButtonText}>✨ Ver todos los productos</Text>
              </TouchableOpacity>
            </View>
          }
          onEndReached={handleEndReached}
          onEndReachedThreshold={0.3}
          initialNumToRender={8}
          maxToRenderPerBatch={8}
          windowSize={7}
          updateCellsBatchingPeriod={50}
          removeClippedSubviews={Platform.OS !== 'web'}
          contentContainerStyle={styles.scrollPadding}
        />
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  tabContent: { flex: 1, paddingBottom: 68 },
  scrollPadding: { paddingBottom: 20 },
  headerWrapper: { backgroundColor: '#FFFFFF', paddingBottom: 4 },
  row: { justifyContent: 'space-between', paddingHorizontal: 16 },
  header: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingHorizontal: 20, paddingTop: 10, marginBottom: 16 },
  profileSection: { flexDirection: 'row', alignItems: 'center' },
  logoImage: { width: 42, height: 42, borderRadius: 12 },
  textContainer: { marginLeft: 12 },
  storeName: { fontSize: 17, fontWeight: '900', color: '#0F172A' },
  onlineStatus: { fontSize: 11, color: '#10B981', fontWeight: '700', marginTop: 1 },
  headerIcons: { flexDirection: 'row', position: 'relative' },
  iconButton: { width: 42, height: 42, backgroundColor: '#F1F5F9', borderRadius: 21, justifyContent: 'center', alignItems: 'center', marginLeft: 10 },
  emojiIcon: { fontSize: 18 },
  cartBadge: { position: 'absolute', top: -3, right: -3, backgroundColor: '#4F46E5', width: 20, height: 20, borderRadius: 10, justifyContent: 'center', alignItems: 'center', borderWidth: 2, borderColor: '#FFFFFF' },
  cartBadgeText: { color: '#FFFFFF', fontSize: 9, fontWeight: '800' },
  searchContainer: { 
    flexDirection: 'row', 
    alignItems: 'center', 
    backgroundColor: '#FFFFFF',
    marginHorizontal: 20, 
    height: 48, 
    borderRadius: 16,
    paddingHorizontal: 16, 
    marginBottom: 20, 
    borderWidth: 1.5, 
    borderColor: '#F1F5F9',
    ...Platform.select({
      ios: {
        shadowColor: '#0F172A',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.02,
        shadowRadius: 10,
      },
      android: {
        elevation: 1,
      },
    }),
  },
  searchIcon: { fontSize: 15, marginRight: 10 },
  searchInput: { 
    flex: 1, 
    fontSize: 14, 
    color: '#0F172A',
    fontWeight: '500',
    backgroundColor: 'transparent',
    ...Platform.select({
      web: {
        outlineStyle: 'none',
      } as any,
    }),
  },  
  categoriesContainer: { marginBottom: 20 },
  categoryPill: { paddingHorizontal: 18, height: 38, backgroundColor: '#F1F5F9', borderRadius: 12, justifyContent: 'center', alignItems: 'center', marginRight: 10, flexDirection: 'row' },
  categoryPillActive: { backgroundColor: '#4F46E5' },
  categoryText: { fontSize: 13, color: '#64748B', fontWeight: '700' },
  categoryTextActive: { color: '#FFFFFF' },
  sectionHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingHorizontal: 20, marginBottom: 16 },
  sectionTitle: { fontSize: 18, fontWeight: '900', color: '#0F172A' },
  seeAllLink: { fontSize: 13, color: '#4F46E5', fontWeight: '700' },
  grid: { flexDirection: 'row', flexWrap: 'wrap', paddingHorizontal: 16, justifyContent: 'space-between' },
  card: { 
    width: '48%', 
    backgroundColor: '#FFFFFF', 
    borderRadius: 20, 
    padding: 10, 
    marginBottom: 16, 
    borderWidth: 1, 
    borderColor: '#F1F5F9',
    ...Platform.select({
      ios: {
        shadowColor: '#0F172A',
        shadowOffset: { width: 0, height: 6 },
        shadowOpacity: 0.03,
        shadowRadius: 12,
      },
      android: {
        elevation: 2,
      },
      default: {
        shadowColor: '#0F172A',
        shadowOffset: { width: 0, height: 6 },
        shadowOpacity: 0.03,
        shadowRadius: 12,
      }
    }),
  },
  imageWrapper: { width: '100%', height: 135, backgroundColor: '#F8FAFC', borderRadius: 14, overflow: 'hidden', position: 'relative', padding: 4 },
  productImage: { width: '100%', height: '100%' },
  tagsContainer: { position: 'absolute', top: 6, left: 6, right: 6, flexDirection: 'row', justifyContent: 'space-between' },
  topTag: { backgroundColor: '#EF4444', color: '#FFFFFF', fontSize: 9, fontWeight: '800', paddingHorizontal: 6, paddingVertical: 2, borderRadius: 6, textTransform: 'uppercase' },
  brandTag: { backgroundColor: 'rgba(15, 23, 42, 0.75)', color: '#FFFFFF', fontSize: 8, fontWeight: '800', paddingHorizontal: 6, paddingVertical: 2, borderRadius: 6, marginLeft: 'auto' },
  cardInfo: { marginTop: 10, paddingHorizontal: 2, flexGrow: 1 },
  productBrand: { fontSize: 9, fontWeight: '800', color: '#64748B', letterSpacing: 0.5, marginBottom: 2 },
  productTitle: { fontSize: 14, fontWeight: '800', color: '#0F172A' },
  productSubtitle: { fontSize: 11, color: '#64748B', marginTop: 1, height: 16 },
  
  priceRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginTop: 12,
    paddingHorizontal: 2,
    borderTopWidth: 1,
    borderColor: '#F1F5F9',
    paddingTop: 10,
  },
  priceLabel: {
    fontSize: 8,
    fontWeight: '800',
    color: '#94A3B8',
    letterSpacing: 0.5,
  },
  productPrice: { fontSize: 14, fontWeight: '900', color: '#4F46E5' },
  
  addToCartCardButton: {
    backgroundColor: '#EEF2FF',
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: 12,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  addToCartCardButtonText: {
    color: '#4F46E5',
    fontSize: 12,
    fontWeight: '800',
  },
  seeOptionsCardButton: {
    backgroundColor: '#FEF2F2',
    borderColor: '#FCA5A5',
    borderWidth: 1,
    paddingHorizontal: 8,
    paddingVertical: 6,
    borderRadius: 12,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  seeOptionsCardButtonText: {
    color: '#DC2626',
    fontSize: 11,
    fontWeight: '800',
  },
  outOfStockTag: {
    backgroundColor: '#EF4444',
    color: '#FFFFFF',
    fontSize: 8,
    fontWeight: '900',
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 6,
    textTransform: 'uppercase',
  },
  quantityContainerMini: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#EEF2FF',
    borderRadius: 16,
    height: 32,
    paddingHorizontal: 4,
  },
  miniQtyBtn: {
    width: 24,
    height: 24,
    borderRadius: 12,
    backgroundColor: '#FFFFFF',
    justifyContent: 'center',
    alignItems: 'center',
  },
  miniQtyBtnText: {
    color: '#4F46E5',
    fontSize: 13,
    fontWeight: '900',
  },
  miniQtyText: {
    fontSize: 12,
    fontWeight: '800',
    color: '#4F46E5',
    paddingHorizontal: 8,
  },
  emptyContainer: {
    width: '100%',
    paddingVertical: 50,
    alignItems: 'center',
    justifyContent: 'center',
  },
  retryButton: {
    marginTop: 14,
    backgroundColor: '#4F46E5',
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 12,
  },
  retryButtonText: {
    color: '#FFFFFF',
    fontWeight: '700',
    fontSize: 13,
  },
  footerLoading: {
    paddingVertical: 16,
    alignItems: 'center',
    justifyContent: 'center',
    flexDirection: 'row',
  },
  footerLoadingText: {
    marginLeft: 8,
    fontSize: 12,
    color: '#64748B',
    fontWeight: '600',
  },
  footerEnd: {
    paddingVertical: 20,
    alignItems: 'center',
  },
  footerEndText: {
    fontSize: 12,
    color: '#94A3B8',
    fontWeight: '600',
  },
});
