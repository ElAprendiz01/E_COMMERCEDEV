import { API_CONFIG, safeFetch } from './apiConfig';
import { UserAddress } from '../../Domain/entities/UserAddress';

export class UserAddressRemoteDataSource {
  async getAddressesByUser(userId: number): Promise<UserAddress[]> {
    try {
      console.log('📡 [GET /api/UserAddress/filtrar] Consultando direcciones para usuario ID:', userId);
      let rawData: any[] = [];

      try {
        const response = await safeFetch<{ codigo: number; msj: string; data: any[] }>(
          `${API_CONFIG.BASE_URL}/api/UserAddress/filtrar?UserId=${userId}`
        );
        rawData = response.data || [];
      } catch (e) {
        console.log('📡 [GET /api/UserAddress/Listar] Fallback a Listar direcciones...');
        const response = await safeFetch<{ codigo: number; msj: string; data: any[] }>(
          `${API_CONFIG.BASE_URL}/api/UserAddress/Listar`
        );
        rawData = response.data || [];
      }

      // Filtrar direcciones correspondientes al usuario especificado (ej. userId = 1)
      const userSpecificData = rawData.filter(item => {
        const itemUserId = Number(item.userId ?? item.userAddressUserId ?? 1);
        return itemUserId === userId;
      });

      return userSpecificData.map(item => ({
        userAddressId: Number(item.userAddressId ?? item.id ?? 0),
        userAddressUserId: Number(item.userId ?? item.userAddressUserId ?? userId),
        userAddressCountryId: Number(item.countryId ?? item.userAddressCountryId ?? 1),
        countryName: item.countryName ?? item.paisNombre ?? 'Nicaragua',
        userAddressZIPCode: Number(item.zipCode ?? item.userAddressZIPCode ?? 10000),
        userAddressDescription: item.addressDescription ?? item.userAddressDescription ?? item.direccionTexto ?? 'Dirección sin descripción',
        userAddressIsPrincipal: Boolean(item.isPrincipal ?? item.userAddressIsPrincipal ?? false),
        userAddressCreatorId: Number(item.userAddressCreatorId ?? userId),
        userAddressStatusId: item.statusId ?? item.userAddressStatusId ?? true,
      }));
    } catch (error: any) {
      console.log('Info al consultar direcciones de usuario:', error);
      return [];
    }
  }

  async createAddress(
    userId: number,
    description: string,
    isPrincipal: boolean = false
  ): Promise<{ success: boolean; addressId?: number; message?: string }> {
    try {
      const payload = {
        userAddressUserId: userId,
        userAddressCountryId: 1,
        userAddressZIPCode: 10000,
        userAddressDescription: description,
        userAddressIsPrincipal: isPrincipal,
        userAddressCreatorId: userId,
        userAddressStatusId: true,
      };

      console.log('📡 [POST /api/UserAddress/insertar] Guardando nueva dirección:', payload);

      const response = await safeFetch<{ codigo: number; msj: string; templateId?: number }>(
        `${API_CONFIG.BASE_URL}/api/UserAddress/insertar`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(payload),
        }
      );

      return {
        success: response.codigo === 200 || Boolean(response.templateId),
        addressId: response.templateId,
        message: response.msj || 'Dirección registrada con éxito.',
      };
    } catch (error: any) {
      console.log('Error al crear dirección:', error);
      return { success: false, message: error?.message || 'Error al conectar con la API de direcciones.' };
    }
  }

  async updateAddress(
    addressId: number,
    userId: number,
    description: string,
    isPrincipal: boolean = false
  ): Promise<{ success: boolean; message?: string }> {
    try {
      const payload = {
        userAddressId: addressId,
        userAddressUserId: userId,
        userAddressCountryId: 1,
        userAddressZIPCode: 10000,
        userAddressDescription: description,
        userAddressIsPrincipal: isPrincipal,
        userAddressModificatorId: userId,
        userAddressStatusId: true,
      };

      console.log('📡 [PUT /api/UserAddress/actualizar] Actualizando dirección ID:', addressId, payload);

      const response = await safeFetch<{ codigo: number; msj: string }>(
        `${API_CONFIG.BASE_URL}/api/UserAddress/actualizar`,
        {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(payload),
        }
      );

      return {
        success: response.codigo === 200,
        message: response.msj || 'Dirección actualizada correctamente.',
      };
    } catch (error: any) {
      console.log('Error al actualizar dirección:', error);
      return { success: false, message: error?.message || 'Error al actualizar dirección.' };
    }
  }

  async deleteAddress(
    addressId: number,
    userId: number
  ): Promise<{ success: boolean; message?: string }> {
    try {
      console.log(`📡 [DELETE /api/UserAddress/${addressId}/${userId}] Eliminando dirección...`);
      const response = await safeFetch<{ codigo: number; msj: string }>(
        `${API_CONFIG.BASE_URL}/api/UserAddress/${addressId}/${userId}`,
        {
          method: 'DELETE',
        }
      );

      return {
        success: response.codigo === 200,
        message: response.msj || 'Dirección eliminada correctamente.',
      };
    } catch (error: any) {
      console.log('Error al eliminar dirección:', error);
      return { success: false, message: error?.message || 'Error al eliminar la dirección.' };
    }
  }
}
