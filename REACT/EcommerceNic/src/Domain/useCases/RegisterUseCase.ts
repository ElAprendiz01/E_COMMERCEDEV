import { AuthRepository } from '../repositories/AuthRepository';

export class RegisterUseCase {

  constructor(
    private authRepository: AuthRepository
  ) {}

  async execute(
    userFullName: string,
    userName: string,
    userPasswordPlain: string,
    userEmail: string,
    userPhoneNumber: string,
    userCountryId: number,
    userGenderId: number,
    userBirthDay: string
  ) {

    return await this.authRepository.register(
      userFullName,
      userName,
      userPasswordPlain,
      userEmail,
      userPhoneNumber,
      userCountryId,
      userGenderId,
      userBirthDay
    );

  }

}