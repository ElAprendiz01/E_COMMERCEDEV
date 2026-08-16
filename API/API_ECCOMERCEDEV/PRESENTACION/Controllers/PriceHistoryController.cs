using APLICATION.DTOs.PriceHistory;
using APLICATION.Services;
using DOMAIN.VariablesSalida;
using Microsoft.AspNetCore.Mvc;

namespace PRESENTACION.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PriceHistoryController : ControllerBase
    {
        private readonly PriceHistoryServices _service;

        public PriceHistoryController(PriceHistoryServices service)
        {
            _service = service;
        }

        #region lectura_pricehistory

        [HttpGet("Listar")]
        public async Task<IActionResult> Listar_PriceHistory()
        {
            try
            {
                var lista = await _service.Listar_PriceHistory_async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron registros de historial de precios." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpGet("filtrar")]
        public async Task<IActionResult> Filtrar_PriceHistory([FromQuery] PriceHistoryFilterDTOs filtro)
        {
            try
            {
                var lista = await _service.Filtrar_PriceHistory_async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron registros de historial de precios que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_pricehistory

        [HttpPost("insertar")]
        public async Task<IActionResult> Ingresar_PriceHistory([FromBody] PriceHistoryInsertarDTOs item)
        {
            try
            {
                if (!ModelState.IsValid || item == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                OUTPUT resultado = await _service.Insertar_PriceHistory_async(item);

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
