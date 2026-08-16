import { ProductRepository } from '../repositories/ProductRepository';
import { Product } from '../entities/Product';

export class UpdateProductUseCase {
  private productRepository: ProductRepository;

  constructor(productRepository: ProductRepository) {
    this.productRepository = productRepository;
  }

  async execute(id: string, product: Partial<Product>) {
    return this.productRepository.updateProduct(id, product);
  }
}
