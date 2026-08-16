import { AuthRepository } from '../repositories/AuthRepository';
import { User } from '../entities/User';

export class ObtenerSesionGuardadaUseCase {
  constructor(private authRepository: AuthRepository) {}

  async execute(): Promise<{ usuario: User; token: string } | null> {
    return await this.authRepository.obtenerSesionGuardada();
  }
}
