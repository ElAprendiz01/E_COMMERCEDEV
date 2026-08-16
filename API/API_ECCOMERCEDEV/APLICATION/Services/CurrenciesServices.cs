using APLICATION.DTOs.Currencies;
using APLICATION.Interfaces;
using DOMAIN.Currencies;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class CurrenciesServices
    {
        private readonly ICurrenciesRepository _repository;

        public CurrenciesServices(ICurrenciesRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_Currencies_listar>> Listar_Currencies_async()
        {
            return await _repository.Listar_CurrenciesAsync();
        }

        public async Task<IEnumerable<DM_Currencies_filtrar>> Filtrar_Currencies_async(CurrenciesFilterDTOs dto)
        {
            return await _repository.Filtrar_CurrenciesAsync(dto.SearchTerm, dto.StatusId);
        }

        public async Task<OUTPUT> Insertar_Currencies_async(CurrenciesInsertarDTOs dto)
        {
            var modelo = new DM_Currencies_insertar
            {
                currencyName = dto.currencyName,
                currencyISO = dto.currencyISO,
                currencyCode = dto.currencyCode,
                currencyDescription = dto.currencyDescription,
                currencyCreatorId = dto.currencyCreatorId,
                currencyStatusId = dto.currencyStatusId
            };
            return await _repository.Insertar_CurrenciesAsync(modelo);
        }

        public async Task<OUTPUT> Editar_Currencies_async(CurrenciesEditarDTOs dto)
        {
            var modelo = new DM_Currencies_actualizar
            {
                currencyId = dto.currencyId,
                currencyName = dto.currencyName,
                currencyISO = dto.currencyISO,
                currencyCode = dto.currencyCode,
                currencyDescription = dto.currencyDescription,
                currencyModificatorId = dto.currencyModificatorId,
                currencyStatusId = dto.currencyStatusId,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Editar_CurrenciesAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_Currencies_async(int? currencyId, int? currencyModificatorId)
        {
            return await _repository.Eliminar_CurrenciesAsync(currencyId, currencyModificatorId);
        }
    }
}
