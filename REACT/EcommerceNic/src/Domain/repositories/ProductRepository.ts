import { Product } from '../entities/Product';
import { ProductsPageResponse } from '../entities/ProductApiResponse';

export interface ProductRepository {
  getProducts(): Promise<Product[]>;
  getProductsPaged(page: number, pageSize?: number, search?: string): Promise<ProductsPageResponse>;
  getProductById(productId: number | string): Promise<any>;
  createProduct(product: Omit<Product, 'id'>): Promise<Product>;
  updateProduct(id: string, product: Partial<Product>): Promise<Product>;
  deleteProduct(id: string): Promise<boolean>;
}
