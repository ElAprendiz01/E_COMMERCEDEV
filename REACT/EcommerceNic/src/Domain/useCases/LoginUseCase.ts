import { AuthRepository } from '../repositories/AuthRepository';

export class LoginUseCase {
  private authRepository: AuthRepository;

  constructor(authRepository: AuthRepository) {
    this.authRepository = authRepository;
  }

async execute(email: string, password: string) {
    return await this.authRepository.login(email, password);
}
}
