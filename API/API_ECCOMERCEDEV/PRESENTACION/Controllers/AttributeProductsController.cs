using APLICATION.DTOs.AttributeProducts;
using APLICATION.Services;
using DOMAIN.VariablesSalida;
using Microsoft.AspNetCore.Mvc;

namespace PRESENTACION.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AttributeProductsController : ControllerBase
    {
        private readonly AttributeProductsServices _service;

        public AttributeProductsController(AttributeProductsServices service)
        {
            _service = service;
        }

        #region lectura_attributeproducts

        [HttpGet("Listar")]
        public async Task<IActionResult> Listar_AttributeProducts()
        {
            try
            {
                var lista = await _service.Listar_AttributeProducts_async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron atributos de productos." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpGet("filtrar")]
        public async Task<IActionResult> Filtrar_AttributeProducts([FromQuery] AttributeProductsFilterDTOs filtro)
        {
            try
            {
                var lista = await _service.Filtrar_AttributeProducts_async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron atributos de productos que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_attributeproducts

        [HttpPost("insertar")]
        public async Task<IActionResult> Ingresar_AttributeProducts([FromBody] AttributeProductsInsertarDTOs item)
        {
            try
            {
                if (!ModelState.IsValid || item == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                OUTPUT resultado = await _service.Insertar_AttributeProducts_async(item);

                if (!resultado.IsSuccess)
                {
                    return BadRequest(new { codigo = resultado.Code, msj = resultado.Message });
                }

                return Ok(new { codigo = resultado.Code, msj = resultado.Message, templateId = resultado.TemplateId });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpPut("actualizar")]
        public async Task<IActionResult> Editar_AttributeProducts([FromBody] AttributeProductsEditarDTOs item)
        {
            try
            {
                if (item == null || !item.AttributeProductId.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del atributo de producto es obligatorio." });
                }

                OUTPUT resultado = await _service.Editar_AttributeProducts_async(item);

                if (!resultado.IsSuccess)
                {
                    return BadRequest(new { codigo = resultado.Code, msj = resultado.Message });
                }

                return Ok(new { codigo = resultado.Code, msj = resultado.Message, templateId = resultado.TemplateId });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpDelete("{id}/{idModificador}")]
        public async Task<IActionResult> Eliminar_AttributeProducts(int? id, int? idModificador)
        {
            try
            {
                if (!id.HasValue || !idModificador.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID del atributo de producto y el ID del modificador son requeridos." });
                }

                OUTPUT resultado = await _service.Eliminar_AttributeProducts_async(id, idModificador);

                if (!resultado.IsSuccess)
                {
                    return BadRequest(new { codigo = resultado.Code, msj = resultado.Message });
                }

                return Ok(new { codigo = resultado.Code, msj = resultado.Message });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion
    }
}
