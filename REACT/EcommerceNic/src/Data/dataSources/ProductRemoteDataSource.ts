import { API_CONFIG, safeFetch } from './apiConfig';
import { ProductsPageResponse } from '../../Domain/entities/ProductApiResponse';

export class ProductRemoteDataSource {
  async getProductsPaged(page: number = 1, pageSize?: number, search?: string): Promise<ProductsPageResponse> {
    const isSearching = search && search.trim().length > 0;

    if (isSearching) {
      const url = `${API_CONFIG.BASE_URL}/api/Products/filtrar?searchTerm=${encodeURIComponent(search.trim())}&pageNumber=${page}`;
      return await safeFetch<ProductsPageResponse>(url);
    } else {
      const url = `${API_CONFIG.BASE_URL}/api/Products/Listar?pageNumber=${page}`;
      return await safeFetch<ProductsPageResponse>(url);
    }
  }

  async getProductById(productId: number | string): Promise<any> {
    const url = `${API_CONFIG.BASE_URL}/api/Products/filtrar_por_id/${productId}`;
    return await safeFetch<any>(url);
  }
}

export const productRemoteDataSource = new ProductRemoteDataSource();
