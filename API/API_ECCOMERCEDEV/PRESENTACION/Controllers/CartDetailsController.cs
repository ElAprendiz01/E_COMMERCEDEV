using APLICATION.DTOs.CartDetails;
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
    public class CartDetailsController : ControllerBase
    {
        private readonly CartDetailsServices _service;

        public CartDetailsController(CartDetailsServices service)
        {
            _service = service;
        }

        #region lectura_cartdetails

        [HttpGet("Listar")]
        public async Task<IActionResult> Listar_CartDetails()
        {
            try
            {
                var lista = await _service.Listar_CartDetails_async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron detalles del carrito." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpGet("obtener_carrito_cliente/{userId}")]
        public async Task<IActionResult> Obtener_CarritoCliente(int? userId)
        {
            try
            {
                if (!userId.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador de usuario es obligatorio." });
                }

                var lista = await _service.Obtener_CarritoCliente_async(userId.Value);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontró un carrito activo para el usuario." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_cartdetails

        [HttpPost("insertar")]
        public async Task<IActionResult> Ingresar_CartDetails([FromBody] CartDetailsInsertarDTOs cartDetail)
        {
            try
            {
                if (!ModelState.IsValid || cartDetail == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                OUTPUT resultado = await _service.Insertar_CartDetails_async(cartDetail);

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
        public async Task<IActionResult> Editar_CartDetails_Cantidad([FromBody] CartDetailsActualizarCantidadDTOs cartDetail)
        {
            try
            {
                if (cartDetail == null || !cartDetail.cartDetailId.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del detalle del carrito es obligatorio." });
                }

                OUTPUT resultado = await _service.Editar_CartDetails_Cantidad_async(cartDetail);

                if (!resultado.IsSuccess)
                {
                    string msg = resultado.Message ?? string.Empty;
                    if (msg.Contains("no existe") || msg.Contains("no se encuentra activo") || msg.Contains("inactivo"))
                    {
                        return Ok(new { codigo = 200, msj = "El producto ya no está activo en el carrito.", templateId = resultado.TemplateId });
                    }
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
        public async Task<IActionResult> Eliminar_CartDetails(int? id, int? idModificador)
        {
            try
            {
                if (!id.HasValue || !idModificador.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID del detalle del carrito y el ID del modificador son requeridos." });
                }

                OUTPUT resultado = await _service.Eliminar_CartDetails_async(id.Value, idModificador.Value);

                if (!resultado.IsSuccess)
                {
                    string msg = resultado.Message ?? string.Empty;
                    if (msg.Contains("no existe") || msg.Contains("no se encuentra activo") || msg.Contains("inactivo"))
                    {
                        return Ok(new { codigo = 200, msj = "El producto ya no está activo en el carrito.", templateId = resultado.TemplateId });
                    }
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
