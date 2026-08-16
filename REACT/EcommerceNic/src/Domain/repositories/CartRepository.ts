import { CartItem } from '../entities/CartItem';

export interface CartRepository {
  getCartByUser(userId: number): Promise<CartItem[]>;
  addToCart(userId: number, productVariableId: number, quantity?: number): Promise<number | boolean>;
  updateCartQuantity(cartDetailId: number, newQuantity: number, modificatorId: number): Promise<boolean>;
  deleteCartItem(cartDetailId: number, modificatorId: number): Promise<boolean>;
}
