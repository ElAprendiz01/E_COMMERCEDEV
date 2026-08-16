using APLICATION.DTOs.PaymentOrders;
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
    public class PaymentOrdersController : ControllerBase
    {
        private readonly PaymentOrdersServices _service;

        public PaymentOrdersController(PaymentOrdersServices service)
        {
            _service = service;
        }

        #region lectura_paymentorders

        [HttpGet("Listar")]
        public async Task<IActionResult> Listar_PaymentOrders()
        {
            try
            {
                var lista = await _service.Listar_PaymentOrders_async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron ordenes de pago." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpGet("filtrar")]
        public async Task<IActionResult> Filtrar_PaymentOrders([FromQuery] PaymentOrdersFilterDTOs filtro)
        {
            try
            {
                var lista = await _service.Filtrar_PaymentOrders_async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron ordenes de pago que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_paymentorders

        [HttpPost("insertar")]
        public async Task<IActionResult> Ingresar_PaymentOrders([FromBody] PaymentOrdersInsertarDTOs order)
        {
            try
            {
                if (!ModelState.IsValid || order == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                OUTPUT resultado = await _service.Insertar_PaymentOrders_async(order);

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
