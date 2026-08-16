export interface ProductImage {
  id: number;
  url: string;
  description: string;
  isPrimary: boolean;
}

export interface PriceHistory {
  id: number;
  oldPrice: number;
  newPrice: number;
  changeDate: string; // ISO string
}

export interface ProductVariable {
  id: number;
  productId: number;
  value: string; // e.g., "Color: Black, Size: L"
  price: number;
  currencyId: number;
  currencyISO: string; // e.g., "NIO", "USD"
  stock: number; // Mapped from related Tbl_Stocks
  priceHistory?: PriceHistory[];
}

export interface ProductDto {
  id: number;
  name: string;
  description: string;
  categoryId: number;
  categoryName: string;
  subCategoryId: number;
  subCategoryName: string;
  segmentId: number;
  segmentName: string;
  brandId: number;
  brandName: string;
  providerId: number;
  providerName: string;
  images: ProductImage[];
  variables: ProductVariable[];
}
