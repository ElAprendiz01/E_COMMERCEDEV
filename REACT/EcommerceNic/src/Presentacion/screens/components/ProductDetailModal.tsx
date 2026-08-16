import React, { useState, useEffect, useMemo } from 'react';
import {
  Modal,
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
  Platform,
  SafeAreaView,
  Alert,
  StatusBar,
} from 'react-native';
import { ProductImage } from '../../components/ProductImage';
import { useProductDetail } from '../../hooks/useProductDetail';
import { formatCurrency } from '../constants';

interface ProductDetailModalProps {
  visible: boolean;
  productId: number | string | null;
  onClose: () => void;
  onAddToCart?: (products: any | any[]) => Promise<void> | void;
  onGoToCart?: () => void;
  cantidadesCarrito?: { [key: string]: number };
}

const formatPriceWithISO = (price: number, iso?: string) => {
  const cleanIso = (iso || '').trim().toUpperCase();
  if (cleanIso === 'USD') {
    return `$${price.toFixed(2)}`;
  }
  return formatCurrency(price);
};

export const ProductDetailModal: React.FC<ProductDetailModalProps> = ({
  visible,
  productId,
  onClose,
  onAddToCart,
  onGoToCart,
  cantidadesCarrito,
}) => {
  const { productDetail, allVariants, selectVariant, isLoading, error, refetch } = useProductDetail(visible ? productId : null);
  const [variantQuantities, setVariantQuantities] = useState<{ [key: string]: number }>({});

  useEffect(() => {
    if (visible) {
      setVariantQuantities({});
    }
  }, [visible, productId]);

  const currentVarId = String(productDetail?.productVariableID || productDetail?.productID || '0');
  const quantity = variantQuantities[currentVarId] || 1;

  const varIdKey = productDetail?.productVariableID ? String(productDetail.productVariableID) : null;
  const cartQty = (cantidadesCarrito && varIdKey && cantidadesCarrito[varIdKey]) || 0;

  const rawDbStock = Math.max(0, productDetail?.stockAvilable ?? 0);
  const availableStock = Math.max(0, rawDbStock - cartQty);

  const handleIncrement = () => {
    if (!currentVarId || currentVarId === '0') return;
    setVariantQuantities((prev) => {
      const curQty = prev[currentVarId] || 1;
      if (curQty >= availableStock) {
        const msg = cartQty > 0
          ? `Ya tienes ${cartQty} en tu Carrito. Solo quedan ${availableStock} disponibles adicionales (máximo ${rawDbStock} en inventario).`
          : `Solo hay ${availableStock} ${availableStock === 1 ? 'unidad disponible' : 'unidades disponibles'} en inventario.`;
        if (Platform.OS === 'web') {
          window.alert(`⚠️ Límite de Stock Alcanzado:\n${msg}`);
        } else {
          Alert.alert('⚠️ Límite de Stock', msg);
        }
        return prev;
      }
      return { ...prev, [currentVarId]: curQty + 1 };
    });
  };

  const handleDecrement = () => {
    if (!currentVarId || currentVarId === '0') return;
    setVariantQuantities((prev) => {
      const curQty = prev[currentVarId] || 1;
      const nextQty = curQty > 1 ? curQty - 1 : 1;
      return { ...prev, [currentVarId]: nextQty };
    });
  };

  const totalDraftedItems = useMemo(() => {
    return Object.values(variantQuantities).reduce((acc, qty) => acc + (qty > 0 ? qty : 0), 0);
  }, [variantQuantities]);

  const totalDraftedVariantsCount = useMemo(() => {
    return Object.entries(variantQuantities).filter(([_, qty]) => qty > 0).length;
  }, [variantQuantities]);

  const handleAddToCart = async () => {
    const entries = Object.entries(variantQuantities).filter(([_, qty]) => qty > 0);

    if (entries.length === 0) {
      if (!productDetail || availableStock <= 0) return;
      entries.push([currentVarId, quantity]);
    }

    const itemsToAdd: any[] = [];

    for (const [varIdStr, qtyToAdd] of entries) {
      const matchingVariant = allVariants.find(
        v => String(v.productVariableID || v.productID) === varIdStr
      ) || productDetail;

      if (!matchingVariant) continue;

      const vCartQty = (cantidadesCarrito && cantidadesCarrito[varIdStr]) || 0;
      const vRawStock = Math.max(0, matchingVariant.stockAvilable ?? 0);
      const vAvailStock = Math.max(0, vRawStock - vCartQty);

      if (vAvailStock <= 0 || qtyToAdd > vAvailStock) {
        const msg = `Para ${matchingVariant.productVariableName || matchingVariant.productName}: Solo quedan ${vAvailStock} disponibles.`;
        if (Platform.OS === 'web') {
          window.alert(`⚠️ Stock Insuficiente:\n${msg}`);
        } else {
          Alert.alert('⚠️ Stock Insuficiente', msg);
        }
        continue;
      }

      itemsToAdd.push({
        id: String(matchingVariant.productVariableID || matchingVariant.productID),
        productVariableId: matchingVariant.productVariableID || matchingVariant.productID,
        title: matchingVariant.productName,
        name: matchingVariant.productName,
        subtitle: matchingVariant.productVariableName,
        numericPrice: matchingVariant.productVariablePrice,
        price: matchingVariant.productVariablePrice,
        image: matchingVariant.productImageURL,
        ProductoImagenUrl: matchingVariant.productImageURL,
        quantity: qtyToAdd,
      });
    }

    if (itemsToAdd.length > 0) {
      await onAddToCart?.(itemsToAdd);
      setVariantQuantities({});
    }
  };

  return (
    <Modal
      visible={visible}
      animationType="slide"
      transparent={false}
      onRequestClose={onClose}
    >
      <SafeAreaView style={styles.safeArea}>
        {/* Header Superior */}
        <View style={styles.header}>
          <TouchableOpacity style={styles.closeButton} onPress={onClose} activeOpacity={0.7}>
            <Text style={styles.closeButtonText}>← Volver</Text>
          </TouchableOpacity>
          <Text style={styles.headerTitle} numberOfLines={1}>Detalle del Producto</Text>
          <View style={{ width: 60 }} />
        </View>

        {isLoading ? (
          <View style={styles.centerContainer}>
            <ActivityIndicator size="large" color="#4F46E5" />
            <Text style={styles.loadingText}>Cargando información del producto...</Text>
          </View>
        ) : error ? (
          <View style={styles.centerContainer}>
            <Text style={styles.errorIcon}>📡</Text>
            <Text style={styles.errorTitle}>Error al consultar la API</Text>
            <Text style={styles.errorText}>{error}</Text>
            <TouchableOpacity style={styles.retryButton} onPress={refetch}>
              <Text style={styles.retryButtonText}>Reintentar</Text>
            </TouchableOpacity>
          </View>
        ) : productDetail ? (
          <View style={styles.container}>
            <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scrollContent}>
              {/* Contenedor de Imagen del Producto */}
              <View style={styles.imageCard}>
                <ProductImage
                  url={productDetail.productImageURL}
                  style={styles.heroImage}
                  containerStyle={styles.heroImageContainer}
                  resizeMode="contain"
                />
              </View>

              {/* Insignias / Segmentación (Marca, Categoría, Subcategoría, Segmento) */}
              <View style={styles.badgesRow}>
                {!!productDetail.markName && (
                  <View style={[styles.badge, styles.brandBadge]}>
                    <Text style={styles.brandBadgeText}>🏷️ {productDetail.markName.toUpperCase()}</Text>
                  </View>
                )}
                {!!productDetail.categoryName && (
                  <View style={[styles.badge, styles.categoryBadge]}>
                    <Text style={styles.badgeText}>📂 {productDetail.categoryName}</Text>
                  </View>
                )}
                {!!productDetail.subcategoryName && (
                  <View style={[styles.badge, styles.subCategoryBadge]}>
                    <Text style={styles.badgeText}>⚡ {productDetail.subcategoryName}</Text>
                  </View>
                )}
                {!!productDetail.segmentName && (
                  <View style={[styles.badge, styles.segmentBadge]}>
                    <Text style={styles.badgeText}>🎯 {productDetail.segmentName}</Text>
                  </View>
                )}
              </View>

              {/* Información Principal del Producto */}
              <View style={styles.detailsCard}>
                <Text style={styles.productTitle}>{productDetail.productName}</Text>

                {!!productDetail.productVariableName && (
                  <Text style={styles.productSubtitle}>{productDetail.productVariableName}</Text>
                )}

                {/* Precio y Moneda */}
                <View style={styles.priceContainer}>
                  <Text style={styles.priceLabel}>PRECIO</Text>
                  <Text style={styles.priceValue}>
                    {formatPriceWithISO(productDetail.productVariablePrice, productDetail.currencyISO)}
                  </Text>
                </View>

                {/* Selector Interactivo de Variantes (Tallas, Colores, Opciones) */}
                {allVariants && allVariants.length >= 1 && (
                  <View style={styles.variantsSection}>
                    <View style={styles.variantsSectionHeader}>
                      <Text style={styles.variantsSectionTitle}>⚙️ OPCIÓN </Text>
                      <Text style={styles.variantsSectionCount}>{allVariants.length} {allVariants.length === 1 ? 'Opción disponible' : 'Opciones disponibles'}</Text>
                    </View>
                    <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.variantsScroll}>
                      {allVariants.map((v, idx) => {
                        const vIdKey = String(v.productVariableID || v.productID || '0');
                        const isSelected = (v.productVariableID === productDetail?.productVariableID) ||
                          (v.productVariableName === productDetail?.productVariableName);
                        const vDraftQty = variantQuantities[vIdKey] || 0;
                        const vStock = Math.max(0, v.stockAvilable ?? 0);
                        const isOut = vStock <= 0;

                        return (
                          <TouchableOpacity
                            key={`variant-${v.productVariableID || idx}-${idx}`}
                            style={[
                              styles.variantPill,
                              isSelected && styles.variantPillActive,
                            ]}
                            onPress={() => selectVariant(v)}
                            activeOpacity={0.8}
                          >
                            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginBottom: 4 }}>
                              <Text style={[styles.variantPillText, isSelected && styles.variantPillTextActive]}>
                                {isSelected ? '🔘 ' : '⚪ '}{v.productVariableName || `Opción #${idx + 1}`}
                              </Text>
                              
                              {isOut ? (
                                <Text style={styles.variantOutBadge}>🔴 Agotado</Text>
                              ) : vDraftQty === 0 ? (
                                <TouchableOpacity 
                                  style={styles.pillAddButton}
                                  onPress={(e) => {
                                    (e as any)?.stopPropagation?.();
                                    selectVariant(v);
                                    setVariantQuantities(prev => ({ ...prev, [vIdKey]: 1 }));
                                  }}
                                >
                                  <Text style={styles.pillAddButtonText}>🛒 Agregar</Text>
                                </TouchableOpacity>
                              ) : (
                                <View style={styles.pillQtyContainer}>
                                  <TouchableOpacity 
                                    style={styles.pillQtyBtn}
                                    onPress={(e) => {
                                      (e as any)?.stopPropagation?.();
                                      setVariantQuantities(prev => {
                                        const current = prev[vIdKey] || 1;
                                        const next = current - 1;
                                        if (next <= 0) {
                                          const copy = { ...prev };
                                          delete copy[vIdKey];
                                          return copy;
                                        }
                                        return { ...prev, [vIdKey]: next };
                                      });
                                    }}
                                  >
                                    <Text style={styles.pillQtyBtnText}>-</Text>
                                  </TouchableOpacity>
                                  <Text style={styles.pillQtyText}>{vDraftQty}</Text>
                                  <TouchableOpacity 
                                    style={styles.pillQtyBtn}
                                    onPress={(e) => {
                                      (e as any)?.stopPropagation?.();
                                      setVariantQuantities(prev => {
                                        const current = prev[vIdKey] || 1;
                                        if (current >= vStock) return prev;
                                        return { ...prev, [vIdKey]: current + 1 };
                                      });
                                    }}
                                  >
                                    <Text style={styles.pillQtyBtnText}>+</Text>
                                  </TouchableOpacity>
                                </View>
                              )}
                            </View>

                            <View style={{ flexDirection: 'row', alignItems: 'center', marginTop: 2 }}>
                              <Text style={[styles.variantPillPrice, isSelected && styles.variantPillPriceActive]}>
                                {formatPriceWithISO(v.productVariablePrice, v.currencyISO)}
                              </Text>
                              {!isOut && vStock <= 5 && (
                                <Text style={styles.variantLowBadge}>🔥 ¡Pocas!</Text>
                              )}
                            </View>
                          </TouchableOpacity>
                        );
                      })}
                    </ScrollView>
                  </View>
                )}

                <View style={styles.divider} />

                {/* Disponibilidad y Proveedor */}
                <View style={styles.infoGrid}>
                  <View style={styles.infoBox}>
                    <Text style={styles.infoBoxLabel}>DISPONIBILIDAD DE VARIANTE</Text>
                    {availableStock > 0 ? (
                      availableStock <= 5 ? (
                        <View style={styles.stockStatusLow}>
                          <Text style={styles.stockTextLow}>
                            🔥 ¡Últimas {availableStock} {availableStock === 1 ? 'unidad disponible' : 'unidades disponibles'}!{cartQty > 0 ? ` (${cartQty} en Carrito)` : ''}
                          </Text>
                        </View>
                      ) : (
                        <View style={styles.stockStatusIn}>
                          <Text style={styles.stockTextIn}>
                            ● En Stock ({availableStock} disponibles{cartQty > 0 ? ` — ${cartQty} en Carrito` : ''})
                          </Text>
                        </View>
                      )
                    ) : (
                      <View style={styles.stockStatusOut}>
                        <Text style={styles.stockTextOut}>
                          ● {cartQty >= rawDbStock && rawDbStock > 0
                            ? `Límite Alcanzado (${cartQty} de ${rawDbStock} en Carrito)`
                            : 'Agotado'}
                        </Text>
                      </View>
                    )}

                    {cartQty > 0 && (
                      <TouchableOpacity
                        style={styles.goToCartButtonInline}
                        onPress={() => {
                          onClose();
                          onGoToCart?.();
                        }}
                        activeOpacity={0.8}
                      >
                        <Text style={styles.goToCartButtonInlineText}>🛒 Ver en Carrito ({cartQty}) →</Text>
                      </TouchableOpacity>
                    )}
                  </View>

                  {!!productDetail.providerName && (
                    <View style={styles.infoBox}>
                      <Text style={styles.infoBoxLabel}>PROVEEDOR OFICIAL</Text>
                      <Text style={styles.infoBoxValue}>🏭 {productDetail.providerName}</Text>
                    </View>
                  )}
                </View>
              </View>
            </ScrollView>

            {/* Footer con Selector de Cantidad y Botón de Agregar al Carrito */}
            <View style={styles.footerContainer}>
              <View style={styles.quantityRow}>
                <Text style={styles.quantityLabel}>Cantidad:</Text>
                {availableStock <= 0 ? (
                  <View style={styles.stockStatusOutMini}>
                    <Text style={styles.stockTextOutMini}>🔴 Agotado</Text>
                  </View>
                ) : (variantQuantities[currentVarId] || 0) === 0 ? (
                  <TouchableOpacity 
                    style={styles.addToCartCardButtonModal}
                    activeOpacity={0.8}
                    onPress={() => setVariantQuantities(prev => ({ ...prev, [currentVarId]: 1 }))}
                  >
                    <Text style={styles.addToCartCardButtonModalText}>🛒 Agregar</Text>
                  </TouchableOpacity>
                ) : (
                  <View style={styles.qtyControls}>
                    <TouchableOpacity 
                      style={styles.qtyBtn} 
                      onPress={() => {
                        setVariantQuantities(prev => {
                          const cur = prev[currentVarId] || 1;
                          const next = cur - 1;
                          if (next <= 0) {
                            const copy = { ...prev };
                            delete copy[currentVarId];
                            return copy;
                          }
                          return { ...prev, [currentVarId]: next };
                        });
                      }}
                    >
                      <Text style={styles.qtyBtnText}>-</Text>
                    </TouchableOpacity>
                    <Text style={styles.qtyNumber}>{variantQuantities[currentVarId] || 1}</Text>
                    <TouchableOpacity
                      style={[
                        styles.qtyBtnPlus,
                        ((variantQuantities[currentVarId] || 1) >= availableStock) && styles.qtyBtnDisabled,
                      ]}
                      onPress={handleIncrement}
                      disabled={(variantQuantities[currentVarId] || 1) >= availableStock}
                    >
                      <Text style={styles.qtyBtnTextPlus}>+</Text>
                    </TouchableOpacity>
                  </View>
                )}
              </View>

              <TouchableOpacity
                style={[
                  styles.addToCartButton,
                  (availableStock <= 0 && totalDraftedItems === 0) && styles.disabledButton,
                ]}
                onPress={handleAddToCart}
                disabled={availableStock <= 0 && totalDraftedItems === 0}
                activeOpacity={0.8}
              >
                <Text style={styles.addToCartButtonText}>
                  {totalDraftedVariantsCount > 1
                    ? `🛒 Agregar ${totalDraftedVariantsCount} Opciones (${totalDraftedItems} ítems)`
                    : (variantQuantities[currentVarId] || 0) > 0
                    ? `🛒 Agregar al Carrito (${variantQuantities[currentVarId]})`
                    : totalDraftedItems > 0
                    ? `🛒 Agregar al Carrito (${totalDraftedItems})`
                    : `🛒 Agregar al Carrito (1)`}
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        ) : null}
      </SafeAreaView>
    </Modal>
  );
};

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#F8FAFC',
    paddingTop: Platform.OS === 'android' ? (StatusBar.currentHeight || 24) : 0,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    paddingVertical: 14,
    backgroundColor: '#FFFFFF',
    borderBottomWidth: 1,
    borderColor: '#E2E8F0',
    ...Platform.select({
      ios: {
        shadowColor: '#0F172A',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.04,
        shadowRadius: 4,
      },
      android: {
        elevation: 2,
      },
    }),
  },
  closeButton: {
    paddingHorizontal: 10,
    paddingVertical: 6,
    backgroundColor: '#EEF2FF',
    borderRadius: 10,
  },
  closeButtonText: {
    color: '#4F46E5',
    fontWeight: '800',
    fontSize: 13,
  },
  headerTitle: {
    fontSize: 16,
    fontWeight: '800',
    color: '#0F172A',
    flex: 1,
    textAlign: 'center',
  },
  centerContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 24,
  },
  loadingText: {
    marginTop: 12,
    fontSize: 14,
    color: '#64748B',
    fontWeight: '600',
  },
  errorIcon: {
    fontSize: 40,
    marginBottom: 12,
  },
  errorTitle: {
    fontSize: 16,
    fontWeight: '800',
    color: '#0F172A',
  },
  errorText: {
    fontSize: 13,
    color: '#64748B',
    textAlign: 'center',
    marginTop: 6,
  },
  retryButton: {
    marginTop: 16,
    backgroundColor: '#4F46E5',
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 12,
  },
  retryButtonText: {
    color: '#FFFFFF',
    fontWeight: '700',
  },
  container: {
    flex: 1,
  },
  scrollContent: {
    padding: 16,
    paddingBottom: 24,
  },
  imageCard: {
    backgroundColor: '#FFFFFF',
    borderRadius: 20,
    padding: 12,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: '#E2E8F0',
    height: 240,
    justifyContent: 'center',
    alignItems: 'center',
  },
  heroImageContainer: {
    width: '100%',
    height: '100%',
    borderRadius: 14,
    overflow: 'hidden',
  },
  heroImage: {
    width: '100%',
    height: '100%',
  },
  badgesRow: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    marginBottom: 16,
    marginHorizontal: -4,
  },
  badge: {
    paddingHorizontal: 10,
    paddingVertical: 5,
    borderRadius: 8,
    marginHorizontal: 4,
    marginBottom: 8,
  },
  brandBadge: {
    backgroundColor: '#0F172A',
  },
  brandBadgeText: {
    color: '#FFFFFF',
    fontSize: 10,
    fontWeight: '800',
  },
  categoryBadge: {
    backgroundColor: '#EEF2FF',
    borderWidth: 0.5,
    borderColor: '#C7D2FE',
  },
  subCategoryBadge: {
    backgroundColor: '#FEF3C7',
    borderWidth: 0.5,
    borderColor: '#FDE68A',
  },
  segmentBadge: {
    backgroundColor: '#ECFDF5',
    borderWidth: 0.5,
    borderColor: '#A7F3D0',
  },
  badgeText: {
    fontSize: 11,
    color: '#1E293B',
    fontWeight: '700',
  },
  detailsCard: {
    backgroundColor: '#FFFFFF',
    borderRadius: 20,
    padding: 18,
    borderWidth: 1,
    borderColor: '#E2E8F0',
  },
  productTitle: {
    fontSize: 20,
    fontWeight: '900',
    color: '#0F172A',
    lineHeight: 26,
  },
  productSubtitle: {
    fontSize: 14,
    color: '#475569',
    marginTop: 6,
    fontWeight: '500',
  },
  priceContainer: {
    marginTop: 16,
    backgroundColor: '#F8FAFC',
    padding: 12,
    borderRadius: 14,
    borderWidth: 1,
    borderColor: '#F1F5F9',
  },
  priceLabel: {
    fontSize: 9,
    fontWeight: '800',
    color: '#94A3B8',
    letterSpacing: 0.5,
  },
  priceValue: {
    fontSize: 24,
    fontWeight: '900',
    color: '#4F46E5',
    marginTop: 2,
  },
  divider: {
    height: 1,
    backgroundColor: '#E2E8F0',
    marginVertical: 16,
  },
  infoGrid: {
    gap: 12,
  },
  infoBox: {
    backgroundColor: '#F8FAFC',
    padding: 12,
    borderRadius: 12,
  },
  infoBoxLabel: {
    fontSize: 9,
    fontWeight: '800',
    color: '#64748B',
    letterSpacing: 0.5,
    marginBottom: 4,
  },
  infoBoxValue: {
    fontSize: 13,
    fontWeight: '700',
    color: '#0F172A',
  },
  variantsSection: { marginTop: 14, marginBottom: 10 },
  variantsSectionHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 },
  variantsSectionTitle: { fontSize: 11, fontWeight: '900', color: '#475569', letterSpacing: 0.5 },
  variantsSectionCount: { fontSize: 11, fontWeight: '700', color: '#6366F1' },
  variantsScroll: { flexDirection: 'row', paddingVertical: 4 },
  variantPill: {
    backgroundColor: '#FFFFFF',
    borderWidth: 1.5,
    borderColor: '#E2E8F0',
    borderRadius: 14,
    paddingHorizontal: 14,
    paddingVertical: 10,
    marginRight: 10,
    minWidth: 110,
  },
  variantPillActive: {
    borderColor: '#4F46E5',
    backgroundColor: '#EEF2FF',
  },
  variantPillText: { fontSize: 13, fontWeight: '800', color: '#334155' },
  variantPillTextActive: { color: '#4F46E5' },
  variantPillPrice: { fontSize: 12, fontWeight: '700', color: '#64748B' },
  variantPillPriceActive: { color: '#4F46E5' },
  variantOutBadge: { backgroundColor: '#FEE2E2', color: '#EF4444', fontSize: 9, fontWeight: '800', paddingHorizontal: 4, paddingVertical: 1, borderRadius: 4, marginLeft: 6 },
  variantLowBadge: { backgroundColor: '#FEF3C7', color: '#D97706', fontSize: 9, fontWeight: '800', paddingHorizontal: 4, paddingVertical: 1, borderRadius: 4, marginLeft: 6 },
  pillAddButton: {
    backgroundColor: '#EEF2FF',
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 8,
    marginLeft: 8,
  },
  pillAddButtonText: {
    color: '#4F46E5',
    fontSize: 10,
    fontWeight: '800',
  },
  addToCartCardButtonModal: {
    backgroundColor: '#EEF2FF',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 12,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  addToCartCardButtonModalText: {
    color: '#4F46E5',
    fontSize: 12,
    fontWeight: '800',
  },
  stockStatusOutMini: {
    backgroundColor: '#FEF2F2',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 8,
  },
  stockTextOutMini: {
    color: '#EF4444',
    fontSize: 11,
    fontWeight: '800',
  },
  pillQtyContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#EEF2FF',
    borderRadius: 8,
    paddingHorizontal: 4,
    paddingVertical: 2,
    marginLeft: 8,
  },
  pillQtyBtn: {
    width: 20,
    height: 20,
    borderRadius: 10,
    backgroundColor: '#4F46E5',
    alignItems: 'center',
    justifyContent: 'center',
  },
  pillQtyBtnText: {
    color: '#FFFFFF',
    fontSize: 12,
    fontWeight: '900',
  },
  pillQtyText: {
    fontSize: 11,
    fontWeight: '800',
    color: '#4F46E5',
    marginHorizontal: 6,
  },
  stockStatusLow: {
    alignSelf: 'flex-start',
    backgroundColor: '#FEF3C7',
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#F59E0B',
  },
  stockTextLow: {
    color: '#D97706',
    fontSize: 12,
    fontWeight: '800',
  },
  stockStatusIn: {
    alignSelf: 'flex-start',
    backgroundColor: '#ECFDF5',
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 8,
  },
  stockTextIn: {
    color: '#059669',
    fontSize: 12,
    fontWeight: '800',
  },
  stockStatusOut: {
    alignSelf: 'flex-start',
    backgroundColor: '#FEF2F2',
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 8,
  },
  stockTextOut: {
    color: '#EF4444',
    fontSize: 12,
    fontWeight: '800',
  },
  goToCartButtonInline: {
    backgroundColor: '#EEF2FF',
    borderColor: '#818CF8',
    borderWidth: 1,
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: 8,
    marginTop: 6,
    alignSelf: 'flex-start',
  },
  goToCartButtonInlineText: {
    color: '#4F46E5',
    fontSize: 12,
    fontWeight: '800',
  },
  footerContainer: {
    backgroundColor: '#FFFFFF',
    borderTopWidth: 1,
    borderColor: '#E2E8F0',
    padding: 16,
  },
  quantityRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: 12,
  },
  quantityLabel: {
    fontSize: 14,
    fontWeight: '800',
    color: '#0F172A',
  },
  qtyControls: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#EEF2FF',
    borderRadius: 12,
    padding: 4,
  },
  qtyBtn: {
    width: 28,
    height: 28,
    backgroundColor: '#FFFFFF',
    borderRadius: 8,
    justifyContent: 'center',
    alignItems: 'center',
  },
  qtyBtnPlus: {
    width: 28,
    height: 28,
    backgroundColor: '#4F46E5',
    borderRadius: 8,
    justifyContent: 'center',
    alignItems: 'center',
  },
  qtyBtnDisabled: {
    backgroundColor: '#94A3B8',
    opacity: 0.5,
  },
  qtyBtnText: {
    fontSize: 14,
    color: '#4F46E5',
    fontWeight: '800',
  },
  qtyBtnTextPlus: {
    fontSize: 14,
    color: '#FFFFFF',
    fontWeight: '800',
  },
  qtyNumber: {
    fontSize: 14,
    fontWeight: '800',
    color: '#4F46E5',
    paddingHorizontal: 12,
  },
  addToCartButton: {
    backgroundColor: '#4F46E5',
    height: 48,
    borderRadius: 16,
    justifyContent: 'center',
    alignItems: 'center',
  },
  disabledButton: {
    backgroundColor: '#94A3B8',
  },
  addToCartButtonText: {
    color: '#FFFFFF',
    fontSize: 15,
    fontWeight: '800',
  },
});
