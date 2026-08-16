import { API_CONFIG, safeFetch } from "./apiConfig";

export interface LoginResponse {
  codigo: number;
  msj: string;
  data: {
    token: string;
    userFullName: string;
    userEmail: string;
    userId: number;
  };
}

export interface RegisterResponse {
  codigo: number;
  msj: string;
  templateId: number;
}

class AuthRemoteDataSource {
  async login(email: string, password: string): Promise<LoginResponse> {
    const data = await safeFetch<LoginResponse>(`${API_CONFIG.BASE_URL}/api/Users/login`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        userEmail: email,
        userPasswordPlain: password,
      }),
    });

    console.log("RESPUESTA C#:", data);
    return data;
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
  ): Promise<RegisterResponse> {
    const data = await safeFetch<RegisterResponse>(`${API_CONFIG.BASE_URL}/api/Users/insertar`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        userFullName,
        userName,
        userPasswordPlain,
        userEmail,
        userPhoneNumber,
        userCountryId,
        userGenderId,
        userBirthDay,
        userCreatorId: 1,
        userStatusId: 1,
      }),
    });

    console.log("RESPUESTA REGISTER:", data);
    return data;
  }
}

export const authRemoteDataSource = new AuthRemoteDataSource();