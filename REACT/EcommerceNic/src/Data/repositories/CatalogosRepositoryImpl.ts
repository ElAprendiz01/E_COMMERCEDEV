import { CatalogosRepository } from "../../Domain/repositories/CatalogosRepository";
import { Pais } from "../../Domain/entities/Pais";
import { Genero } from "../../Domain/entities/Genero";
import { catalogosRemoteDataSource } from "../dataSources/CatalogosRemoteDataSource";

export class CatalogosRepositoryImpl implements CatalogosRepository {

    async getPaises(): Promise<Pais[]> {
        return await catalogosRemoteDataSource.getPaises();
    }

    async getGeneros(): Promise<Genero[]> {
        return await catalogosRemoteDataSource.getGeneros();
    }

}