using APLICATION.DTOs.CartDetails;
using APLICATION.Interfaces;
using DOMAIN.CartDetails;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class CartDetailsServices
    {
        private readonly ICartDetailsRepository _repository;

        public CartDetailsServices(ICartDetailsRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_CartDetails_listar>> Listar_CartDetails_async()
        {
            return await _repository.Listar_CartDetailsAsync();
        }

        public async Task<OUTPUT> Insertar_CartDetails_async(CartDetailsInsertarDTOs dto)
        {
            var modelo = new DM_CartDetails_insertar
            {
                userId = dto.userId,
                productVariableId = dto.productVariableId,
                quantity = dto.quantity,
                discount = dto.discount,
                creatorId = dto.creatorId,
                statusId = dto.statusId
            };
            return await _repository.Insertar_CartDetailsAsync(modelo);
        }

        public async Task<OUTPUT> Editar_CartDetails_Cantidad_async(CartDetailsActualizarCantidadDTOs dto)
        {
            var modelo = new DM_CartDetails_actualizar
            {
                cartDetailId = dto.cartDetailId,
                newQuantity = dto.newQuantity,
                modificatorId = dto.modificatorId
            };
            return await _repository.Editar_CartDetails_CantidadAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_CartDetails_async(int cartDetailId, int cartDetailModificatorId)
        {
            return await _repository.Eliminar_CartDetailsAsync(cartDetailId, cartDetailModificatorId);
        }

        public async Task<IEnumerable<DM_CartDetails_filtrar>> Obtener_CarritoCliente_async(int userId)
        {
            return await _repository.Obtener_CarritoClienteAsync(userId);
        }
    }
}
