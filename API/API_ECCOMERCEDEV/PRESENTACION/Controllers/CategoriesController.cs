using APLICATION.DTOs.Categories;
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
    public class CategoriesController : ControllerBase
    {
        private readonly CategoriesServices _service;

        public CategoriesController(CategoriesServices service)
        {
            _service = service;
        }

        #region lectura_categories

        [HttpGet("Listar")]
        public async Task<IActionResult> Listar_Categories()
        {
            try
            {
                var lista = await _service.Listar_Categories_async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron categorías." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpGet("filtrar")]
        public async Task<IActionResult> Filtrar_Categories([FromQuery] CategoriesFilterDTOs filtro)
        {
            try
            {
                var lista = await _service.Filtrar_Categories_async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron categorías que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_categories

        [HttpPost("insertar")]
        public async Task<IActionResult> Ingresar_Categories([FromBody] CategoriesInsertarDTOs category)
        {
            try
            {
                if (!ModelState.IsValid || category == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                OUTPUT resultado = await _service.Insertar_Categories_async(category);

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
        public async Task<IActionResult> Editar_Categories([FromBody] CategoriesEditarDTOs category)
        {
            try
            {
                if (category == null || !category.categoryId.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador de la categoría es obligatorio." });
                }

                OUTPUT resultado = await _service.Editar_Categories_async(category);

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
        public async Task<IActionResult> Eliminar_Categories(int? id, int? idModificador)
        {
            try
            {
                if (!id.HasValue || !idModificador.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID de la categoría y el ID del modificador son requeridos." });
                }

                OUTPUT resultado = await _service.Eliminar_Categories_async(id.Value, idModificador.Value);

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
