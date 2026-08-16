import { CartRepository } from '../repositories/CartRepository';

export class DeleteCartItemUseCase {
  constructor(private repository: CartRepository) {}

  async execute(cartDetailId: number, modificatorId: number): Promise<boolean> {
    return await this.repository.deleteCartItem(cartDetailId, modificatorId);
  }
}
