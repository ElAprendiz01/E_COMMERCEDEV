using DOMAIN.Currencies;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Interfaces
{
    public interface ICurrenciesRepository
    {
        Task<IEnumerable<DM_Currencies_listar>> Listar_CurrenciesAsync();
        Task<IEnumerable<DM_Currencies_filtrar>> Filtrar_CurrenciesAsync(string? searchTerm, bool? statusId);
        Task<OUTPUT> Insertar_CurrenciesAsync(DM_Currencies_insertar modelo);
        Task<OUTPUT> Editar_CurrenciesAsync(DM_Currencies_actualizar modelo);
        Task<OUTPUT> Eliminar_CurrenciesAsync(int? currencyId, int? currencyModificatorId);
    }
}
