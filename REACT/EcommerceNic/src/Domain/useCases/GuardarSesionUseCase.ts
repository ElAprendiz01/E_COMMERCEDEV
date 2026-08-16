import { AuthRepository } from '../repositories/AuthRepository';
import { User } from '../entities/User';

export class GuardarSesionUseCase {
  constructor(private authRepository: AuthRepository) {}

  async execute(usuario: User, token: string): Promise<void> {
    return await this.authRepository.guardarSesion(usuario, token);
  }
}
