import { API_CONFIG, safeFetch } from './apiConfig';
import { SubCategory } from '../../Domain/entities/SubCategory';

export class SubCategoryRemoteDataSource {
  async getSubCategories(): Promise<SubCategory[]> {
    try {
      const response = await safeFetch<any[]>(`${API_CONFIG.BASE_URL}/api/SubCategories/filtrar`, {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
      });

      if (Array.isArray(response) && response.length > 0) {
        return response.map(item => ({
          subCategoryId: item.subCategoryId ?? item.subCategoriaId ?? item.id ?? 0,
          subCategoriaId: item.subCategoryId ?? item.subCategoriaId ?? item.id ?? 0,
          subCategoryName: item.subCategoryName ?? item.subCategoriaNombre ?? item.nombre ?? item.title ?? 'Subcategoría',
          subCategoriaNombre: item.subCategoryName ?? item.subCategoriaNombre ?? item.nombre ?? item.title ?? 'Subcategoría',
          subCategoryDescription: item.subCategoryDescription ?? item.subCategoriaDescripcion,
          subCategoryStatusId: item.subCategoryStatusId ?? item.estadoId ?? 1,
        })).filter(s => s.subCategoryId > 0 && s.subCategoryStatusId !== 0 && s.subCategoryName.toLowerCase() !== 'string');
      }
    } catch (error) {
      console.log('Info al consultar subcategorías desde la API C#:', error);
    }

    // Lista por defecto con los registros reales de SQL Server compartidos
    return [
      { subCategoryId: 1, subCategoryName: 'Masculino', subCategoryDescription: 'Ropa Masculina' },
      { subCategoryId: 2, subCategoryName: 'Femenino', subCategoryDescription: 'Ropa Femenina' },
      { subCategoryId: 3, subCategoryName: 'Niños', subCategoryDescription: 'Ropa para Niños' },
      { subCategoryId: 4, subCategoryName: 'Niñas', subCategoryDescription: 'Ropa para Niñas' },
      { subCategoryId: 5, subCategoryName: 'Celulares', subCategoryDescription: 'Celulares en general' },
      { subCategoryId: 6, subCategoryName: 'Computadoras', subCategoryDescription: 'Computadoras en general' },
      { subCategoryId: 8, subCategoryName: 'Componentes de Laptop', subCategoryDescription: 'RAM, SSD, Pantallas y teclados' },
      { subCategoryId: 9, subCategoryName: 'Calzado Deportivo', subCategoryDescription: 'Zapatillas para correr' },
      { subCategoryId: 10, subCategoryName: 'Consolas de Videojuegos', subCategoryDescription: 'Sistemas de entretenimiento' },
    ];
  }
}
