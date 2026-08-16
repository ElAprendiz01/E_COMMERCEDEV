import { Pais } from "../entities/Pais";
import { Genero } from "../entities/Genero";

export interface CatalogosRepository {

    getPaises(): Promise<Pais[]>;

    getGeneros(): Promise<Genero[]>;

}