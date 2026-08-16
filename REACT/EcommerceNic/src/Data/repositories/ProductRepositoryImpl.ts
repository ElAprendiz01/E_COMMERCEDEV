import { ProductRepository } from '../../Domain/repositories/ProductRepository';
import { Product } from '../../Domain/entities/Product';
import { ProductsPageResponse } from '../../Domain/entities/ProductApiResponse';
import { localDataSource } from '../dataSources/LocalDataSource';
import { mapApiToProduct } from '../mappers/ProductMapper';
import { productRemoteDataSource, ProductRemoteDataSource } from '../dataSources/ProductRemoteDataSource';

export class ProductRepositoryImpl implements ProductRepository {
  constructor(private remoteDataSource: ProductRemoteDataSource = productRemoteDataSource) {}

  async getProducts(): Promise<Product[]> {
    try {
      const response = await this.remoteDataSource.getProductsPaged(1, 100);
      return (response.data || []).map(mapApiToProduct);
    } catch (error) {
      console.log('Error al obtener productos remotos de la API C#:', error);
      return [];
    }
  }

  async getProductsPaged(page: number = 1, pageSize?: number, search?: string): Promise<ProductsPageResponse> {
    try {
      return await this.remoteDataSource.getProductsPaged(page, pageSize, search);
    } catch (error) {
      console.log('Error fetching paged products from API, falling back or throwing:', error);
      throw error;
    }
  }

  async getProductById(productId: number | string): Promise<any> {
    try {
      return await this.remoteDataSource.getProductById(productId);
    } catch (error) {
      console.log('Error fetching product by ID from API:', error);
      throw error;
    }
  }

  async createProduct(product: Omit<Product, 'id'>): Promise<Product> {
    return localDataSource.createProduct(product);
  }

  async updateProduct(id: string, product: Partial<Product>): Promise<Product> {
    return localDataSource.updateProduct(id, product);
  }

  async deleteProduct(id: string): Promise<boolean> {
    return localDataSource.deleteProduct(id);
  }
}
