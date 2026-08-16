using APLICATION.DTOs.StockMovementTypes;
using APLICATION.Services;
using DOMAIN.VariablesSalida;
using Microsoft.AspNetCore.Mvc;

namespace PRESENTACION.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StockMovementTypesController : ControllerBase
    {
        private readonly StockMovementTypesServices _service;

        public StockMovementTypesController(StockMovementTypesServices service)
        {
            _service = service;
        }

        #region lectura_stockmovementtypes

        [HttpGet("Listar")]
        public async Task<IActionResult> Listar_StockMovementTypes()
        {
            try
            {
                var lista = await _service.Listar_StockMovementTypes_async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron tipos de movimientos de stock." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpGet("filtrar")]
        public async Task<IActionResult> Filtrar_StockMovementTypes([FromQuery] StockMovementTypesFilterDTOs filtro)
        {
            try
            {
                var lista = await _service.Filtrar_StockMovementTypes_async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron tipos de movimientos de stock que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_stockmovementtypes

        [HttpPost("insertar")]
        public async Task<IActionResult> Ingresar_StockMovementTypes([FromBody] StockMovementTypesInsertarDTOs item)
        {
            try
            {
                if (!ModelState.IsValid || item == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                OUTPUT resultado = await _service.Insertar_StockMovementTypes_async(item);

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
        public async Task<IActionResult> Editar_StockMovementTypes([FromBody] StockMovementTypesEditarDTOs item)
        {
            try
            {
                if (item == null || !item.StockMovementTypeId.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del tipo de movimiento de stock es obligatorio." });
                }

                OUTPUT resultado = await _service.Editar_StockMovementTypes_async(item);

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
        public async Task<IActionResult> Eliminar_StockMovementTypes(int? id, int? idModificador)
        {
            try
            {
                if (!id.HasValue || !idModificador.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID del tipo de movimiento de stock y el ID del modificador son requeridos." });
                }

                OUTPUT resultado = await _service.Eliminar_StockMovementTypes_async(id, idModificador);

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
