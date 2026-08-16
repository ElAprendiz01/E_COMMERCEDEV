import { CartRepository } from '../../Domain/repositories/CartRepository';
import { CartItem } from '../../Domain/entities/CartItem';
import { cartRemoteDataSource, CartRemoteDataSource } from '../dataSources/CartRemoteDataSource';

export class CartRepositoryImpl implements CartRepository {
  constructor(private remoteDataSource: CartRemoteDataSource = cartRemoteDataSource) {}

  async getCartByUser(userId: number): Promise<CartItem[]> {
    return await this.remoteDataSource.getCartByUser(userId);
  }

  async addToCart(userId: number, productVariableId: number, quantity: number = 1): Promise<number | boolean> {
    return await this.remoteDataSource.addToCart(userId, productVariableId, quantity);
  }

  async updateCartQuantity(cartDetailId: number, newQuantity: number, modificatorId: number): Promise<boolean> {
    return await this.remoteDataSource.updateCartQuantity(cartDetailId, newQuantity, modificatorId);
  }

  async deleteCartItem(cartDetailId: number, modificatorId: number): Promise<boolean> {
    return await this.remoteDataSource.deleteCartItem(cartDetailId, modificatorId);
  }
}
