import { ApiProduct } from '../../Domain/entities/ProductApiResponse';
import { Product } from '../../Domain/entities/Product';
import { API_CONFIG } from '../dataSources/apiConfig';

const PLACEHOLDER_IMAGE = 'https://placehold.co/400x400/F1F5F9/94A3B8?text=Sin+Imagen';

export function mapApiToProduct(apiProduct: ApiProduct): Product {
  let imageUrl = PLACEHOLDER_IMAGE;

  // Soportar todas las variaciones de casing que pueda enviar C# (productImageURL, productImageUrl, ProductImageURL)
  const rawImage =
    apiProduct.productImageURL ||
    (apiProduct as any).productImageUrl ||
    (apiProduct as any).ProductImageURL ||
    (apiProduct as any).productImageUrl ||
    (apiProduct as any).image;

  if (rawImage && typeof rawImage === 'string' && rawImage.trim().length > 0) {
    const rawUrl = rawImage.trim();
    if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://') || rawUrl.startsWith('file://')) {
      imageUrl = rawUrl;
    } else {
      // Si la URL es relativa (/uploads/products/xyz.jpg), anteponer BASE_URL
      imageUrl = `${API_CONFIG.BASE_URL}${rawUrl.startsWith('/') ? '' : '/'}${rawUrl}`;
    }
  }

  const realProductId = Number(apiProduct.productID ?? (apiProduct as any).productId ?? (apiProduct as any).ProductID ?? 0);
  const realVariableId = Number(apiProduct.productVariableID ?? (apiProduct as any).productVariableId ?? (apiProduct as any).ProductVariableID ?? realProductId);

  const rawStock = Number(
    apiProduct.stockAvilable ??
    (apiProduct as any).StockAvilable ??
    (apiProduct as any).stockAvailable ??
    (apiProduct as any).StockAvailable ??
    (apiProduct as any).stock ??
    0
  );

  return {
    id: String(realVariableId || realProductId),
    productId: realProductId,
    title: apiProduct.productName || (apiProduct as any).ProductName || 'Producto sin nombre',
    subtitle: apiProduct.productVariableName || apiProduct.subcategoryName || '',
    numericPrice: apiProduct.productVariablePrice ?? 0,
    tag: apiProduct.segmentName || '',
    brand: apiProduct.markName || 'NIC STORE',
    category: apiProduct.categoryName || 'General',
    image: imageUrl,
    categoryId: apiProduct.categoryID,
    stockAvailable: isNaN(rawStock) ? 0 : rawStock,
    productVariableId: realVariableId,
  };
}
