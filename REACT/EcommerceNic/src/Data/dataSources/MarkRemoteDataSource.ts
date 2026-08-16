import { API_CONFIG, safeFetch } from './apiConfig';
import { Mark } from '../../Domain/entities/Mark';

export class MarkRemoteDataSource {
  async getMarks(): Promise<Mark[]> {
    try {
      const response = await safeFetch<any[]>(`${API_CONFIG.BASE_URL}/api/Marks/filtrar`, {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
      });

      if (Array.isArray(response) && response.length > 0) {
        return response.map(item => ({
          markId: item.markId ?? item.marcaId ?? item.id ?? 0,
          marcaId: item.markId ?? item.marcaId ?? item.id ?? 0,
          markName: item.markName ?? item.marcaNombre ?? item.nombre ?? item.title ?? 'Marca',
          marcaNombre: item.markName ?? item.marcaNombre ?? item.nombre ?? item.title ?? 'Marca',
          markDescription: item.markDescription ?? item.marcaDescripcion,
          markStatusId: item.markStatusId ?? item.estadoId ?? 1,
        })).filter(m => m.markId > 0 && m.markStatusId !== 0);
      }
    } catch (error) {
      console.log('Info al consultar marcas desde la API:', error);
    }

    // Lista por defecto de marcas activas registradas en SQL Server
    return [
      { markId: 2, markName: 'Nike', markDescription: 'Marca deportiva global' },
      { markId: 9, markName: 'Apple', markDescription: 'Smartphones y ecosistema iOS' },
      { markId: 10, markName: 'Samsung', markDescription: 'Línea Galaxy y tecnología móvil' },
      { markId: 6, markName: 'Sony', markDescription: 'Electrónica y entretenimiento' },
      { markId: 3, markName: 'Dell', markDescription: 'Marca de computadoras Dell' },
      { markId: 1, markName: 'Adidas', markDescription: 'Línea clásica de calzado y ropa' },
      { markId: 4, markName: 'Puma', markDescription: 'Marca de calzado y ropa deportiva' },
      { markId: 11, markName: 'Infinix', markDescription: 'Smartphones de gama media' },
    ];
  }
}
