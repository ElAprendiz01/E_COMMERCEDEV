using APLICATION.DTOs.Status;
using APLICATION.Services;
using DOMAIN.VariablesSalida;
using Microsoft.AspNetCore.Mvc;

namespace PRESENTACION.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StatusController : ControllerBase
    {
        private readonly StatusServices _service;

        public StatusController(StatusServices service)
        {
            _service = service;
        }

        #region lectura_status

        [HttpGet("Listar")]
        public async Task<IActionResult> Listar_Status()
        {
            try
            {
                var lista = await _service.Listar_Status_async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron estados." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpGet("filtrar")]
        public async Task<IActionResult> Filtrar_Status([FromQuery] StatusFilterDTOs filtro)
        {
            try
            {
                var lista = await _service.Filtrar_Status_async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron estados que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_status

        [HttpPost("insertar")]
        public async Task<IActionResult> Ingresar_Status([FromBody] StatusInsertarDTOs status)
        {
            try
            {
                if (!ModelState.IsValid || status == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                OUTPUT resultado = await _service.Insertar_Status_async(status);

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
        public async Task<IActionResult> Editar_Status([FromBody] StatusEditarDTOs status)
        {
            try
            {
                if (status == null || !status.statusId.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del estado es obligatorio." });
                }

                OUTPUT resultado = await _service.Editar_Status_async(status);

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

        [HttpDelete("{id}")]
        public async Task<IActionResult> Eliminar_Status(int? id)
        {
            try
            {
                if (!id.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID del estado es requerido." });
                }

                OUTPUT resultado = await _service.Eliminar_Status_async(id);

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
