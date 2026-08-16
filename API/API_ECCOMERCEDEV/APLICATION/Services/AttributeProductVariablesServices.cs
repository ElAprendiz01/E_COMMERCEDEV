using APLICATION.DTOs.AttributeProductVariables;
using APLICATION.Interfaces;
using DOMAIN.AttributeProductVariables;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class AttributeProductVariablesServices
    {
        private readonly IAttributeProductVariablesRepository _repository;

        public AttributeProductVariablesServices(IAttributeProductVariablesRepository repository)
        {
            _repository = repository;
        }

        public async Task<OUTPUT> Insertar_AttributeProductVariables_Async(AttributeProductVariablesCreateDTOs dto)
        {
            var modelo = new DM_AttributeProductVariables_create
            {
                AttributeProductVariableProductVariableId = dto.AttributeProductVariableProductVariableId,
                AttributeProductVariableAttributeProductId = dto.AttributeProductVariableAttributeProductId,
                AttributeProductVariableValue = dto.AttributeProductVariableValue,
                AttributeProductVariableCreatorId = dto.AttributeProductVariableCreatorId,
                AttributeProductVariableStatusId = dto.AttributeProductVariableStatusId
            };
            return await _repository.Insertar_AttributeProductVariablesAsync(modelo);
        }

        public async Task<OUTPUT> Actualizar_AttributeProductVariables_Async(AttributeProductVariablesUpdateDTOs dto)
        {
            var modelo = new DM_AttributeProductVariables_update
            {
                AttributeProductVariableId = dto.AttributeProductVariableId,
                AttributeProductVariableProductVariableId = dto.AttributeProductVariableProductVariableId,
                AttributeProductVariableAttributeProductId = dto.AttributeProductVariableAttributeProductId,
                AttributeProductVariableValue = dto.AttributeProductVariableValue,
                AttributeProductVariableModificatorId = dto.AttributeProductVariableModificatorId,
                AttributeProductVariableStatusId = dto.AttributeProductVariableStatusId,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Actualizar_AttributeProductVariablesAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_AttributeProductVariables_Async(int? attributeProductVariableId, int? attributeProductVariableModificatorId)
        {
            return await _repository.Eliminar_AttributeProductVariablesAsync(attributeProductVariableId, attributeProductVariableModificatorId);
        }

        public async Task<IEnumerable<AttributeProductVariablesObtenerDTOs>> Obtener_AttributeProductVariables_Async(AttributeProductVariablesFilterDTOs filter)
        {
            var data = await _repository.Obtener_AttributeProductVariablesAsync(filter.ProductVariableId, filter.SearchTerm);
            return data.Select(x => new AttributeProductVariablesObtenerDTOs
            {
                IdAtributoVariable = x.IdAtributoVariable,
                ValorAtributo = x.ValorAtributo,
                RegistroActivo = x.RegistroActivo,
                IdTipoVariable = x.IdTipoVariable,
                TipoVariable = x.TipoVariable,
                DescripcionTipoVariable = x.DescripcionTipoVariable,
                IdVariante = x.IdVariante,
                ValorVariante = x.ValorVariante,
                PrecioVariante = x.PrecioVariante,
                CodigoMoneda = x.CodigoMoneda,
                NombreMoneda = x.NombreMoneda,
                IdProducto = x.IdProducto,
                NombreProducto = x.NombreProducto,
                DescripcionProducto = x.DescripcionProducto,
                NombreMarca = x.NombreMarca,
                NombreProveedor = x.NombreProveedor,
                FechaCreacion = x.FechaCreacion,
                CreadoPor = x.CreadoPor,
                FechaModificacion = x.FechaModificacion,
                ModificadoPor = x.ModificadoPor
            });
        }
    }
}
