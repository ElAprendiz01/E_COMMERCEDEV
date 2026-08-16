import { ProductRepository } from '../repositories/ProductRepository';

export class DeleteProductUseCase {
  private productRepository: ProductRepository;

  constructor(productRepository: ProductRepository) {
    this.productRepository = productRepository;
  }

  async execute(id: string) {
    return this.productRepository.deleteProduct(id);
  }
}
