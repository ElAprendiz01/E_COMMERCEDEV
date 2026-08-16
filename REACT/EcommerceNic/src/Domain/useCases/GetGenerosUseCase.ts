import { CatalogosRepository } from "../repositories/CatalogosRepository";

export class GetGenerosUseCase {

    constructor(
        private repository: CatalogosRepository
    ) {}

    async execute() {
        return await this.repository.getGeneros();
    }

}