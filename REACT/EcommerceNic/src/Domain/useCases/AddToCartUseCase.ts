import { CartRepository } from '../repositories/CartRepository';

export class AddToCartUseCase {
  constructor(private repository: CartRepository) {}

  async execute(userId: number, productVariableId: number, quantity: number = 1): Promise<number | boolean> {
    return await this.repository.addToCart(userId, productVariableId, quantity);
  }
}
