using APLICATION.DTOs.StockMovementDetails;
using APLICATION.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace PRESENTACION.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StockMovementDetailsController : ControllerBase
    {
        private readonly StockMovementDetailsServices _service;

        public StockMovementDetailsController(StockMovementDetailsServices service)
        {
            _service = service;
        }

        #region lectura_stockmovementdetails

        [HttpGet("Listar")]
        public async Task<IActionResult> Listar_StockMovementDetails()
        {
            try
            {
                var lista = await _service.Listar_StockMovementDetails_async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron detalles de movimientos de stock." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpGet("filtrar")]
        public async Task<IActionResult> Filtrar_StockMovementDetails([FromQuery] StockMovementDetailsFilterDTOs filtro)
        {
            try
            {
                var lista = await _service.Filtrar_StockMovementDetails_async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron detalles de movimientos de stock que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion
    }
}
