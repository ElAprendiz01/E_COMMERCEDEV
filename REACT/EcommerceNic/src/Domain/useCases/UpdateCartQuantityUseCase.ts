import { CartRepository } from '../repositories/CartRepository';

export class UpdateCartQuantityUseCase {
  constructor(private repository: CartRepository) {}

  async execute(cartDetailId: number, newQuantity: number, modificatorId: number): Promise<boolean> {
    return await this.repository.updateCartQuantity(cartDetailId, newQuantity, modificatorId);
  }
}
