import { ProductRepository } from '../repositories/ProductRepository';

export class GetProductByIdUseCase {
  constructor(private repository: ProductRepository) {}

  async execute(productId: number | string): Promise<any> {
    return await this.repository.getProductById(productId);
  }
}
