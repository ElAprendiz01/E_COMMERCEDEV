import { CartRepository } from '../repositories/CartRepository';
import { CartItem } from '../entities/CartItem';

export class GetCartByUserUseCase {
  constructor(private repository: CartRepository) {}

  async execute(userId: number): Promise<CartItem[]> {
    return await this.repository.getCartByUser(userId);
  }
}
