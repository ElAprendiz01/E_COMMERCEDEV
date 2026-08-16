using APLICATION.DTOs.Stocks;
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
    public class StocksController : ControllerBase
    {
        private readonly StocksServices _service;

        public StocksController(StocksServices service)
        {
            _service = service;
        }

        #region lectura

        [HttpGet("listar")]
        public async Task<IActionResult> Listar_Stocks()
        {
            try
            {
                var lista = await _service.Listar_Stocks_Async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron registros de stock." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpGet("filtrar")]
        public async Task<IActionResult> Filtrar_Stocks([FromQuery] StocksFilterDTOs filter)
        {
            try
            {
                var lista = await _service.Filtrar_Stocks_Async(filter);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron resultados para los filtros especificados." });
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
        public async Task<IActionResult> Insertar_Stocks([FromBody] StocksCreateDTOs dto)
        {
            try
            {
                if (!ModelState.IsValid || dto == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos de entrada no válidos." });
                }

                OUTPUT resultado = await _service.Insertar_Stocks_Async(dto);

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
        public async Task<IActionResult> Actualizar_Stocks([FromBody] StocksUpdateDTOs dto)
        {
            try
            {
                if (!ModelState.IsValid || dto == null || !dto.StockId.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del stock es obligatorio." });
                }

                OUTPUT resultado = await _service.Actualizar_Stocks_Async(dto);

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

        [HttpDelete("{stockId}/{stockModificatorId}")]
        public async Task<IActionResult> Eliminar_Stocks(int? stockId, int? stockModificatorId)
        {
            try
            {
                if (!stockId.HasValue || !stockModificatorId.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID del stock y el ID del modificador son requeridos." });
                }

                OUTPUT resultado = await _service.Eliminar_Stocks_Async(stockId, stockModificatorId);

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
