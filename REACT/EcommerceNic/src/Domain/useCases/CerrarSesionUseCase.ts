import { AuthRepository } from '../repositories/AuthRepository';

export class CerrarSesionUseCase {
  constructor(private authRepository: AuthRepository) {}

  async execute(): Promise<void> {
    return await this.authRepository.eliminarSesion();
  }
}
