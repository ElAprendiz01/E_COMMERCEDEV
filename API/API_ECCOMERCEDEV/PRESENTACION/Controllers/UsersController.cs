using APLICATION.DTOs.Users;
using APLICATION.Services;
using APPLICATION.DTOs.Users;
using DOMAIN.VariablesSalida;
using Microsoft.AspNetCore.Mvc;

namespace PRESENTACION.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly UsersServices _service;

        public UsersController(UsersServices service)
        {
            _service = service;
        }

        #region lectura_users

        [HttpGet("Listar")]
        public async Task<IActionResult> Listar_Users()
        {
            try
            {
                var lista = await _service.Listar_Users_async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron usuarios." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpGet("filtrar")]
        public async Task<IActionResult> Filtrar_Users([FromQuery] UsersFilterDTOs filtro)
        {
            try
            {
                var lista = await _service.Filtrar_Users_async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron usuarios que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_users

        [HttpPost("insertar")]
        public async Task<IActionResult> Ingresar_Users([FromBody] UsersinsertarDTOs user)
        {
            try
            {
                if (!ModelState.IsValid || user == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                OUTPUT resultado = await _service.Insertar_Users_async(user);

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
        public async Task<IActionResult> Editar_Users([FromBody] UsersEditarDTOs user)
        {
            try
            {
                if (user == null || !user.userId.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del usuario es obligatorio." });
                }

                OUTPUT resultado = await _service.Editar_Users_async(user);

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
        public async Task<IActionResult> Eliminar_Users(int? id, int? idModificador)
        {
            try
            {
                if (!id.HasValue || !idModificador.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID del usuario y el ID del modificador son requeridos." });
                }

                OUTPUT resultado = await _service.Eliminar_Users_async(id, idModificador);

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

        [HttpPut("cambiar_password")]
        public async Task<IActionResult> CambiarPassword_Users([FromBody] UsersCambiarPasswordDTOs pwd)
        {
            try
            {
                if (pwd == null || !pwd.userId.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del usuario es obligatorio." });
                }

                OUTPUT resultado = await _service.CambiarPassword_Users_async(pwd);

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

        #region login_users
        [HttpPost("login")]
        public async Task<IActionResult> Login_Users([FromBody] User_Login credentials)
        {
            try
            {
                if (credentials == null || string.IsNullOrWhiteSpace(credentials.userEmail) || string.IsNullOrWhiteSpace(credentials.userPasswordPlain))
                {
                    return BadRequest(new { codigo = 400, msj = "El correo y la contraseña son obligatorios." });
                }

                // Llamamos al servicio de login que conecta con el repositorio
                OUTPUT resultado = await _service.Login_User_async(credentials);

                if (!resultado.IsSuccess) // Si el SP devuelve error (ej. credenciales inválidas)
                {
                    return BadRequest(new { codigo = resultado.Code, msj = resultado.Message });
                }

                // Si todo sale bien, devolvemos un 200 OK con la "mochila" de datos (donde viene el token)
                return Ok(new { codigo = resultado.Code, msj = resultado.Message, data = resultado.Data });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }
        #endregion
    }
}
