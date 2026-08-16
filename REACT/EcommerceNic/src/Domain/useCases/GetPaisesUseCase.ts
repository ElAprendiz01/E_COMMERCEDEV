import { CatalogosRepository } from "../repositories/CatalogosRepository";

export class GetPaisesUseCase {

    constructor(
        private repository: CatalogosRepository
    ) {}

    async execute() {
        return await this.repository.getPaises();
    }

}