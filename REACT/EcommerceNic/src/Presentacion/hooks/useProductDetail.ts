import { useState, useEffect, useCallback } from 'react';
import { getProductByIdUseCase } from '../../di/DI';

export interface ProductDetailItem {
  productID: number;
  productName: string;
  productVariableID?: number;
  productVariableName?: string;
  productVariablePrice: number;
  currencyID?: number;
  currencyISO?: string;
  categoryID?: number;
  categoryName?: string;
  subcategoryID?: number;
  subcategoryName?: string;
  segmentID?: number;
  segmentName?: string;
  markID?: number;
  markName?: string;
  providerID?: number;
  providerName?: string;
  stockAvilable?: number;
  productImageURL?: string;
}

export const useProductDetail = (productId: number | string | null) => {
  const [productDetail, setProductDetail] = useState<ProductDetailItem | null>(null);
  const [allVariants, setAllVariants] = useState<ProductDetailItem[]>([]);
  const [selectedVariant, setSelectedVariant] = useState<ProductDetailItem | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [error, setError] = useState<string | null>(null);

  const fetchDetail = useCallback(async (idToFetch: number | string) => {
    if (!idToFetch) return;
    setIsLoading(true);
    setError(null);
    try {
      const response = await getProductByIdUseCase.execute(idToFetch);
      const rawData = response?.data || response;
      const rawList: any[] = Array.isArray(rawData) ? rawData : (rawData?.productID ? [rawData] : []);

      if (rawList.length > 0) {
        // Mapear 100% dinámicamente desde SQL Server
        const mappedList: ProductDetailItem[] = rawList.map(item => ({
          productID: item.productID ?? item.ProductID,
          productName: item.productName ?? item.ProductName ?? 'Producto',
          productVariableID: item.productVariableID ?? item.ProductVariableID,
          productVariableName: item.productVariableName ?? item.ProductVariableName ?? '',
          productVariablePrice: item.productVariablePrice ?? item.ProductVariablePrice ?? 0,
          currencyID: item.currencyID ?? item.CurrencyID,
          currencyISO: item.currencyISO ?? item.CurrencyISO ?? 'USD',
          categoryID: item.categoryID ?? item.CategoryID,
          categoryName: item.categoryName ?? item.CategoryName ?? 'General',
          subcategoryID: item.subcategoryID ?? item.SubcategoryID,
          subcategoryName: item.subcategoryName ?? item.SubcategoryName ?? '',
          segmentID: item.segmentID ?? item.SegmentID,
          segmentName: item.segmentName ?? item.SegmentName ?? '',
          markID: item.markID ?? item.MarkID,
          markName: item.markName ?? item.MarkName ?? '',
          providerID: item.providerID ?? item.ProviderID,
          providerName: item.providerName ?? item.ProviderName ?? '',
          stockAvilable: item.stockAvilable ?? item.StockAvilable ?? 0,
          productImageURL: item.productImageURL ?? item.ProductImageURL ?? item.image ?? '',
        }));

        // Agrupar y consolidar por NOMBRE ÚNICO DE VARIANTE (Talla/Color) sumando stock real
        const uniqueMap = new Map<string, ProductDetailItem>();

        mappedList.forEach(item => {
          const nameKey = (item.productVariableName || '').trim().toLowerCase();
          const keyToUse = nameKey || String(item.productVariableID || item.productID || 0);

          if (uniqueMap.has(keyToUse)) {
            const existing = uniqueMap.get(keyToUse)!;
            existing.stockAvilable = (existing.stockAvilable || 0) + (item.stockAvilable || 0);
          } else {
            uniqueMap.set(keyToUse, { ...item });
          }
        });

        const uniqueVariants = Array.from(uniqueMap.values());
        const firstInStockVariant = uniqueVariants.find(v => (v.stockAvilable || 0) > 0) || uniqueVariants[0];

        setAllVariants(uniqueVariants);
        setProductDetail(firstInStockVariant);
        setSelectedVariant(firstInStockVariant);
      } else {
        setAllVariants([]);
        setProductDetail(null);
        setSelectedVariant(null);
        setError('No se encontraron detalles para este producto.');
      }
    } catch (err: any) {
      console.error('Error al obtener detalle del producto por ID:', err);
      setError(err?.message || 'Error al conectar con la API de productos.');
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    if (productId) {
      fetchDetail(productId);
    } else {
      setProductDetail(null);
      setAllVariants([]);
      setSelectedVariant(null);
    }
  }, [productId, fetchDetail]);

  const selectVariant = (variant: ProductDetailItem) => {
    setSelectedVariant(variant);
    setProductDetail(variant);
  };

  return {
    productDetail: selectedVariant || productDetail,
    selectedVariant: selectedVariant || productDetail,
    allVariants,
    selectVariant,
    isLoading,
    error,
    refetch: () => productId && fetchDetail(productId),
  };
};
