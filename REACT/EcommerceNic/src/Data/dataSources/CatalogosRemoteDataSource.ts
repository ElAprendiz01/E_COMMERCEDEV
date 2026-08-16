import { API_CONFIG, safeFetch } from "./apiConfig";

export interface PaisResponse {
  id: number;
  nombre: string;
}

export interface GeneroResponse {
  id: number;
  nombre: string;
}

class CatalogosRemoteDataSource {
  async getPaises(): Promise<PaisResponse[]> {
    return await safeFetch<PaisResponse[]>(`${API_CONFIG.BASE_URL}/api/Catalogos_/Paises`);
  }

  async getGeneros(): Promise<GeneroResponse[]> {
    return await safeFetch<GeneroResponse[]>(`${API_CONFIG.BASE_URL}/api/Catalogos_/Generos`);
  }
}

export const catalogosRemoteDataSource = new CatalogosRemoteDataSource();