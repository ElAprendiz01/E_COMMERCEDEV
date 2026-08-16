import { ProductRepository } from '../repositories/ProductRepository';

export class GetProductsUseCase {
  private productRepository: ProductRepository;

  constructor(productRepository: ProductRepository) {
    this.productRepository = productRepository;
  }

  async execute() {
    return this.productRepository.getProducts();
  }
}
