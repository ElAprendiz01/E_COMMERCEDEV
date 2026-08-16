import { AuthRepository } from '../../Domain/repositories/AuthRepository';
import { User } from '../../Domain/entities/User';
import { localDataSource } from '../dataSources/LocalDataSource';
import { authRemoteDataSource } from "../dataSources/AuthRemoteDataSource";
import { LoginResponse } from "../dataSources/AuthRemoteDataSource";

export class AuthRepositoryImpl implements AuthRepository {
async login(
    email: string,
    password: string
): Promise<LoginResponse> {

    return await authRemoteDataSource.login(email, password);

}
async register(
  userFullName: string,
  userName: string,
  userPasswordPlain: string,
  userEmail: string,
  userPhoneNumber: string,
  userCountryId: number,
  userGenderId: number,
  userBirthDay: string
): Promise<any> {

  return await authRemoteDataSource.register(
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
  async getUsers(): Promise<User[]> {
    return localDataSource.getUsers();
  }

  async guardarSesion(usuario: User, token: string): Promise<void> {
    return localDataSource.guardarSesionLocal(usuario, token);
  }

  async obtenerSesionGuardada(): Promise<{ usuario: User; token: string } | null> {
    return localDataSource.obtenerSesionLocal();
  }

  async eliminarSesion(): Promise<void> {
    return localDataSource.eliminarSesionLocal();
  }
}

