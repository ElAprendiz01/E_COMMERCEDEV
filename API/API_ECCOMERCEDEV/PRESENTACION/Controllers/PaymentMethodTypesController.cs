using APLICATION.DTOs.PaymentMethodTypes;
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
    public class PaymentMethodTypesController : ControllerBase
    {
        private readonly PaymentMethodTypesServices _service;

        public PaymentMethodTypesController(PaymentMethodTypesServices service)
        {
            _service = service;
        }

        #region lectura_paymentmethodtypes

        [HttpGet("Listar")]
        public async Task<IActionResult> Listar_PaymentMethodTypes()
        {
            try
            {
                var lista = await _service.Listar_PaymentMethodTypes_async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron tipos de métodos de pago." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpGet("filtrar")]
        public async Task<IActionResult> Filtrar_PaymentMethodTypes([FromQuery] PaymentMethodTypesFilterDTOs filtro)
        {
            try
            {
                var lista = await _service.Filtrar_PaymentMethodTypes_async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron tipos de métodos de pago que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_paymentmethodtypes

        [HttpPost("insertar")]
        public async Task<IActionResult> Ingresar_PaymentMethodTypes([FromBody] PaymentMethodTypesinsertarDTOs model)
        {
            try
            {
                if (!ModelState.IsValid || model == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                OUTPUT resultado = await _service.Insertar_PaymentMethodTypes_async(model);

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
        public async Task<IActionResult> Editar_PaymentMethodTypes([FromBody] PaymentMethodTypesEditarDTOs model)
        {
            try
            {
                if (model == null || !model.paymentMethodTypeId.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del tipo de método de pago es obligatorio." });
                }

                OUTPUT resultado = await _service.Editar_PaymentMethodTypes_async(model);

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
        public async Task<IActionResult> Eliminar_PaymentMethodTypes(int? id, int? idModificador)
        {
            try
            {
                if (!id.HasValue || !idModificador.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID del tipo de método de pago y el ID del modificador son requeridos." });
                }

                OUTPUT resultado = await _service.Eliminar_PaymentMethodTypes_async(id, idModificador);

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
