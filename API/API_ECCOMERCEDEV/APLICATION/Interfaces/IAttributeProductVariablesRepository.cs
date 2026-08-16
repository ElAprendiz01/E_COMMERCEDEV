using DOMAIN.AttributeProductVariables;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APLICATION.Interfaces
{
    public interface IAttributeProductVariablesRepository
    {
        Task<OUTPUT> Insertar_AttributeProductVariablesAsync(DM_AttributeProductVariables_create modelo);
        Task<OUTPUT> Actualizar_AttributeProductVariablesAsync(DM_AttributeProductVariables_update modelo);
        Task<OUTPUT> Eliminar_AttributeProductVariablesAsync(int? attributeProductVariableId, int? attributeProductVariableModificatorId);
        Task<IEnumerable<DM_AttributeProductVariables_obtener>> Obtener_AttributeProductVariablesAsync(int? productVariableId, string? searchTerm);
    }
}
