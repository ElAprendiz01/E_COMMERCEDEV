using APLICATION.DTOs.AttributeProductVariables;
using APLICATION.Services;
using DOMAIN.VariablesSalida;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace PRESENTACION.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AttributeProductVariablesController : ControllerBase
    {
        private readonly AttributeProductVariablesServices _service;

        public AttributeProductVariablesController(AttributeProductVariablesServices service)
        {
            _service = service;
        }

        #region lectura

        [HttpGet("obtener")]
        public async Task<IActionResult> Obtener_AttributeProductVariables([FromQuery] AttributeProductVariablesFilterDTOs filter)
        {
            try
            {
                var lista = await _service.Obtener_AttributeProductVariables_Async(filter);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron atributos de variables para el producto especificado." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura

        [HttpPost("insertar")]
        public async Task<IActionResult> Insertar_AttributeProductVariables([FromBody] AttributeProductVariablesCreateDTOs dto)
        {
            try
            {
                if (!ModelState.IsValid || dto == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos de entrada no válidos." });
                }

                OUTPUT resultado = await _service.Insertar_AttributeProductVariables_Async(dto);

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
        public async Task<IActionResult> Actualizar_AttributeProductVariables([FromBody] AttributeProductVariablesUpdateDTOs dto)
        {
            try
            {
                if (!ModelState.IsValid || dto == null || !dto.AttributeProductVariableId.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del atributo es obligatorio." });
                }

                OUTPUT resultado = await _service.Actualizar_AttributeProductVariables_Async(dto);

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

        [HttpDelete("{attributeProductVariableId}/{attributeProductVariableModificatorId}")]
        public async Task<IActionResult> Eliminar_AttributeProductVariables(int? attributeProductVariableId, int? attributeProductVariableModificatorId)
        {
            try
            {
                if (!attributeProductVariableId.HasValue || !attributeProductVariableModificatorId.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID del atributo y el ID del modificador son requeridos." });
                }

                OUTPUT resultado = await _service.Eliminar_AttributeProductVariables_Async(attributeProductVariableId, attributeProductVariableModificatorId);

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

        #endregion
    }
}
