import { ProductRepository } from '../repositories/ProductRepository';
import { ProductsPageResponse } from '../entities/ProductApiResponse';

export class GetProductsPagedUseCase {
  constructor(private productRepository: ProductRepository) {}

  async execute(page: number = 1, pageSize?: number, search?: string): Promise<ProductsPageResponse> {
    return await this.productRepository.getProductsPaged(page, pageSize, search);
  }
}
