using APLICATION.DTOs.StockMovements;
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
    public class StockMovementsController : ControllerBase
    {
        private readonly StockMovementsServices _service;

        public StockMovementsController(StockMovementsServices service)
        {
            _service = service;
        }

        #region lectura_stockmovements

        [HttpGet("Listar")]
        public async Task<IActionResult> Listar_StockMovements()
        {
            try
            {
                var lista = await _service.Listar_StockMovements_async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron movimientos de stock." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpGet("filtrar")]
        public async Task<IActionResult> Filtrar_StockMovements([FromQuery] string? searchTerm)
        {
            try
            {
                var lista = await _service.Filtrar_StockMovements_async(searchTerm);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron movimientos de stock que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_stockmovements

        [HttpPost("insertar")]
        public async Task<IActionResult> Ingresar_StockMovements([FromBody] StockMovementsInsertarDTOs movement)
        {
            try
            {
                if (!ModelState.IsValid || movement == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                OUTPUT resultado = await _service.Insertar_StockMovements_async(movement);

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
