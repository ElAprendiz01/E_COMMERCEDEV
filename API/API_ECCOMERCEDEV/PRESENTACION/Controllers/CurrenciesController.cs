using APLICATION.DTOs.Currencies;
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
    public class CurrenciesController : ControllerBase
    {
        private readonly CurrenciesServices _service;

        public CurrenciesController(CurrenciesServices service)
        {
            _service = service;
        }

        #region lectura_currencies

        [HttpGet("Listar")]
        public async Task<IActionResult> Listar_Currencies()
        {
            try
            {
                var lista = await _service.Listar_Currencies_async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron monedas." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpGet("filtrar")]
        public async Task<IActionResult> Filtrar_Currencies([FromQuery] CurrenciesFilterDTOs filtro)
        {
            try
            {
                var lista = await _service.Filtrar_Currencies_async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron monedas que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_currencies

        [HttpPost("insertar")]
        public async Task<IActionResult> Ingresar_Currencies([FromBody] CurrenciesInsertarDTOs currency)
        {
            try
            {
                if (!ModelState.IsValid || currency == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                OUTPUT resultado = await _service.Insertar_Currencies_async(currency);

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
        public async Task<IActionResult> Editar_Currencies([FromBody] CurrenciesEditarDTOs currency)
        {
            try
            {
                if (currency == null || !currency.currencyId.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador de la moneda es obligatorio." });
                }

                OUTPUT resultado = await _service.Editar_Currencies_async(currency);

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
        public async Task<IActionResult> Eliminar_Currencies(int? id, int? idModificador)
        {
            try
            {
                if (!id.HasValue || !idModificador.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID de la moneda y el ID del modificador son requeridos." });
                }

                OUTPUT resultado = await _service.Eliminar_Currencies_async(id, idModificador);

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
