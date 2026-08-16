using APLICATION.DTOs.UserAddress;
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
    public class UserAddressController : ControllerBase
    {
        private readonly UserAddressServices _service;

        public UserAddressController(UserAddressServices service)
        {
            _service = service;
        }

        #region lectura_useraddress

        [HttpGet("Listar")]
        public async Task<IActionResult> Listar_UserAddress()
        {
            try
            {
                var lista = await _service.Listar_UserAddress_async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron direcciones de usuarios." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpGet("filtrar")]
        public async Task<IActionResult> Filtrar_UserAddress([FromQuery] UserAddressFilterDTOs filtro)
        {
            try
            {
                var lista = await _service.Filtrar_UserAddress_async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron direcciones de usuarios que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_useraddress

        [HttpPost("insertar")]
        public async Task<IActionResult> Ingresar_UserAddress([FromBody] UserAddressinsertarDTOs model)
        {
            try
            {
                if (!ModelState.IsValid || model == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                OUTPUT resultado = await _service.Insertar_UserAddress_async(model);

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
        public async Task<IActionResult> Editar_UserAddress([FromBody] UserAddressEditarDTOs model)
        {
            try
            {
                if (model == null || !model.userAddressId.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador de la dirección del usuario es obligatorio." });
                }

                OUTPUT resultado = await _service.Editar_UserAddress_async(model);

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
        public async Task<IActionResult> Eliminar_UserAddress(int? id, int? idModificador)
        {
            try
            {
                if (!id.HasValue || !idModificador.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID de la dirección del usuario y el ID del modificador son requeridos." });
                }

                OUTPUT resultado = await _service.Eliminar_UserAddress_async(id, idModificador);

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
