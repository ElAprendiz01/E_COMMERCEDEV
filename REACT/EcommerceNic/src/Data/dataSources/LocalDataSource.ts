import { User } from '../../Domain/entities/User';
import { Product } from '../../Domain/entities/Product';

class LocalDataSource {
  private users: User[] = [
    { id: '1', email: 'admin@nicstore.com', password: '123456', name: 'Admin Nic Store', role: 'admin' },
    { id: '2', email: 'user@nicstore.com', password: '123456', name: 'Chele User', role: 'user' },
  ];

  private products: Product[] = [];

  // Helper delay
  private delay(ms: number) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  // Auth Operations
  async login(email: string, password: string): Promise<User> {
    await this.delay(1000);
    const user = this.users.find(
      u => u.email.toLowerCase().trim() === email.toLowerCase().trim()
    );
    if (!user) {
      throw new Error('Este correo electrónico no está registrado.');
    }
    if (user.password !== password) {
      throw new Error('Contraseña incorrecta. Verifícala e intenta de nuevo.');
    }
    return user;
  }

  async register(name: string, email: string, password: string, role: 'user' | 'admin' = 'user'): Promise<User> {
    await this.delay(1000);
    const exists = this.users.some(u => u.email.toLowerCase().trim() === email.toLowerCase().trim());
    if (exists) {
      throw new Error('Este correo electrónico ya está registrado.');
    }
    const newUser: User = {
      id: Math.random().toString(),
      name,
      email,
      password,
      role,
    };
    this.users.push(newUser);
    return newUser;
  }

  async getUsers(): Promise<User[]> {
    await this.delay(500);
    return [...this.users];
  }

  // Product Operations
  async getProducts(): Promise<Product[]> {
    await this.delay(800);
    return [...this.products];
  }

  async createProduct(product: Omit<Product, 'id'>): Promise<Product> {
    await this.delay(800);
    const newProduct: Product = {
      ...product,
      id: Math.random().toString(),
    };
    this.products.unshift(newProduct); // Add new products at the top
    return newProduct;
  }

  async updateProduct(id: string, updatedFields: Partial<Product>): Promise<Product> {
    await this.delay(800);
    const index = this.products.findIndex(p => p.id === id);
    if (index === -1) {
      throw new Error('Producto no encontrado');
    }
    const updatedProduct = {
      ...this.products[index],
      ...updatedFields,
    };
    this.products[index] = updatedProduct;
    return updatedProduct;
  }

  async deleteProduct(id: string): Promise<boolean> {
    await this.delay(800);
    const exists = this.products.some(p => p.id === id);
    if (!exists) {
      return false;
    }
    this.products = this.products.filter(p => p.id !== id);
    return true;
  }

  // Operaciones de Persistencia Local de Sesión
  private readonly CLAVE_SESION_LOCAL = '@EcommerceNic:sesion_usuario';

  async guardarSesionLocal(usuario: User, token: string): Promise<void> {
    try {
      const datosSesion = JSON.stringify({ usuario, token });
      if (typeof window !== 'undefined' && window.localStorage) {
        window.localStorage.setItem(this.CLAVE_SESION_LOCAL, datosSesion);
      }
    } catch (error) {
      console.error('Error al guardar la sesión en el almacenamiento local:', error);
    }
  }

  async obtenerSesionLocal(): Promise<{ usuario: User; token: string } | null> {
    try {
      if (typeof window !== 'undefined' && window.localStorage) {
        const datos = window.localStorage.getItem(this.CLAVE_SESION_LOCAL);
        if (datos) {
          return JSON.parse(datos);
        }
      }
      return null;
    } catch (error) {
      console.error('Error al obtener la sesión guardada del almacenamiento local:', error);
      return null;
    }
  }

  async eliminarSesionLocal(): Promise<void> {
    try {
      if (typeof window !== 'undefined' && window.localStorage) {
        window.localStorage.removeItem(this.CLAVE_SESION_LOCAL);
      }
    } catch (error) {
      console.error('Error al eliminar la sesión del almacenamiento local:', error);
    }
  }
}

export const localDataSource = new LocalDataSource();

