using APLICATION.DTOs.UserPaymentMethods;
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
    public class UserPaymentMethodsController : ControllerBase
    {
        private readonly UserPaymentMethodsServices _service;

        public UserPaymentMethodsController(UserPaymentMethodsServices service)
        {
            _service = service;
        }

        #region lectura_userpaymentmethods

        [HttpGet("Listar")]
        public async Task<IActionResult> Listar_UserPaymentMethods()
        {
            try
            {
                var lista = await _service.Listar_UserPaymentMethods_async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron métodos de pago de usuarios." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpGet("filtrar")]
        public async Task<IActionResult> Filtrar_UserPaymentMethods([FromQuery] string? searchTerm)
        {
            try
            {
                var lista = await _service.Filtrar_UserPaymentMethods_async(searchTerm);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron métodos de pago de usuarios que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_userpaymentmethods

        [HttpPost("insertar")]
        public async Task<IActionResult> Ingresar_UserPaymentMethods([FromBody] UserPaymentMethodsinsertarDTOs model)
        {
            try
            {
                if (!ModelState.IsValid || model == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                OUTPUT resultado = await _service.Insertar_UserPaymentMethods_async(model);

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
        public async Task<IActionResult> Editar_UserPaymentMethods([FromBody] UserPaymentMethodsEditarDTOs model)
        {
            try
            {
                if (model == null || !model.userPaymentMethodId.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del método de pago del usuario es obligatorio." });
                }

                OUTPUT resultado = await _service.Editar_UserPaymentMethods_async(model);

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
        public async Task<IActionResult> Eliminar_UserPaymentMethods(int? id, int? idModificador)
        {
            try
            {
                if (!id.HasValue || !idModificador.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID del método de pago del usuario y el ID del modificador son requeridos." });
                }

                OUTPUT resultado = await _service.Eliminar_UserPaymentMethods_async(id, idModificador);

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
