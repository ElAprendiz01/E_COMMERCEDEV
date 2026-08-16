using APLICATION.DTOs.PaymentOrderDetails;
using APLICATION.Services;
using DOMAIN.VariablesSalida;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PRESENTACION.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PaymentOrderDetailsController : ControllerBase
    {
        private readonly PaymentOrderDetailsServices _service;

        public PaymentOrderDetailsController(PaymentOrderDetailsServices service)
        {
            _service = service;
        }

        #region lectura_paymentorderdetails

        [HttpGet("Listar")]
        public async Task<IActionResult> Listar_PaymentOrderDetails()
        {
            try
            {
                var lista = await _service.Listar_PaymentOrderDetails_async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron detalles de orden de pago." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpGet("filtrar")]
        public async Task<IActionResult> Filtrar_PaymentOrderDetails([FromQuery] PaymentOrderDetailsFilterDTOs filtro)
        {
            try
            {
                var lista = await _service.Filtrar_PaymentOrderDetails_async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron detalles de orden de pago que coincidan con la búsqueda." });
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
