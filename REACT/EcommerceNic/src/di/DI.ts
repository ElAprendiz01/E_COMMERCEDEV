import { AuthRepositoryImpl } from '../Data/repositories/AuthRepositoryImpl';
import { ProductRepositoryImpl } from '../Data/repositories/ProductRepositoryImpl';
import { DashboardRepositoryImpl } from '../Data/repositories/DashboardRepositoryImpl';
import { CartRepositoryImpl } from '../Data/repositories/CartRepositoryImpl';
import { LoginUseCase } from '../Domain/useCases/LoginUseCase';
import { RegisterUseCase } from '../Domain/useCases/RegisterUseCase';
import { GetProductsUseCase } from '../Domain/useCases/GetProductsUseCase';
import { GetProductsPagedUseCase } from '../Domain/useCases/GetProductsPagedUseCase';
import { CreateProductUseCase } from '../Domain/useCases/CreateProductUseCase';
import { UpdateProductUseCase } from '../Domain/useCases/UpdateProductUseCase';
import { DeleteProductUseCase } from '../Domain/useCases/DeleteProductUseCase';
import { GetDashboardMetricsUseCase } from '../Domain/useCases/GetDashboardMetricsUseCase';
import { GetCartByUserUseCase } from '../Domain/useCases/GetCartByUserUseCase';
import { AddToCartUseCase } from '../Domain/useCases/AddToCartUseCase';
import { UpdateCartQuantityUseCase } from '../Domain/useCases/UpdateCartQuantityUseCase';
import { DeleteCartItemUseCase } from '../Domain/useCases/DeleteCartItemUseCase';
import { ChatbotRepositoryImpl } from "../Data/repositories/ChatbotRepositoryImpl";
import { SendChatMessageUseCase } from "../Domain/useCases/SendChatMessageUseCase";
import { CatalogosRepositoryImpl } from "../Data/repositories/CatalogosRepositoryImpl";
import { GetPaisesUseCase } from "../Domain/useCases/GetPaisesUseCase";
import { GetGenerosUseCase } from "../Domain/useCases/GetGenerosUseCase";
import { GuardarSesionUseCase } from "../Domain/useCases/GuardarSesionUseCase";
import { ObtenerSesionGuardadaUseCase } from "../Domain/useCases/ObtenerSesionGuardadaUseCase";
import { CerrarSesionUseCase } from "../Domain/useCases/CerrarSesionUseCase";

import { GetProductByIdUseCase } from '../Domain/useCases/GetProductByIdUseCase';

// Instantiate single instances of the Repository implementations
const authRepository = new AuthRepositoryImpl();
const productRepository = new ProductRepositoryImpl();
const dashboardRepository = new DashboardRepositoryImpl();
const cartRepository = new CartRepositoryImpl();

// Instantiate Use Cases
export const loginUseCase = new LoginUseCase(authRepository);
export const registerUseCase = new RegisterUseCase(authRepository);
export const guardarSesionUseCase = new GuardarSesionUseCase(authRepository);
export const obtenerSesionGuardadaUseCase = new ObtenerSesionGuardadaUseCase(authRepository);
export const cerrarSesionUseCase = new CerrarSesionUseCase(authRepository);

export const getProductsUseCase = new GetProductsUseCase(productRepository);
export const getProductsPagedUseCase = new GetProductsPagedUseCase(productRepository);
export const getProductByIdUseCase = new GetProductByIdUseCase(productRepository);
export const createProductUseCase = new CreateProductUseCase(productRepository);
export const updateProductUseCase = new UpdateProductUseCase(productRepository);
export const deleteProductUseCase = new DeleteProductUseCase(productRepository);
export const getDashboardMetricsUseCase = new GetDashboardMetricsUseCase(dashboardRepository);

export const getCartByUserUseCase = new GetCartByUserUseCase(cartRepository);
export const addToCartUseCase = new AddToCartUseCase(cartRepository);
export const updateCartQuantityUseCase = new UpdateCartQuantityUseCase(cartRepository);
export const deleteCartItemUseCase = new DeleteCartItemUseCase(cartRepository);

const chatbotRepository = new ChatbotRepositoryImpl();
const catalogosRepository = new CatalogosRepositoryImpl();

export const getPaisesUseCase = new GetPaisesUseCase(catalogosRepository);
export const getGenerosUseCase = new GetGenerosUseCase(catalogosRepository);

export const sendChatMessageUseCase = new SendChatMessageUseCase(chatbotRepository);