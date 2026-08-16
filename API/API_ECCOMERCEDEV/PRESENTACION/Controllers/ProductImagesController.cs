using APLICATION.DTOs.ProductImages;
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
    public class ProductImagesController : ControllerBase
    {
        private readonly ProductImagesServices _service;

        public ProductImagesController(ProductImagesServices service)
        {
            _service = service;
        }

        [HttpGet("Listar")]
        public async Task<IActionResult> Listar_ProductImages()
        {
            try
            {
                var lista = await _service.Listar_ProductImages();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron imágenes de producto." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpPost("filtrar")]
        public async Task<IActionResult> Filtrar_ProductImages([FromBody] ProductImagesFiltrarDTOs dto)
        {
            try
            {
                var lista = await _service.Filtrar_ProductImages(dto);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron registros con los filtros proporcionados." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpPost("insertar")]
        public async Task<IActionResult> Insertar_ProductImages([FromBody] ProductImagesInsertarDTOs dto)
        {
            try
            {
                if (!ModelState.IsValid || dto == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                OUTPUT resultado = await _service.Insertar_ProductImages_async(dto);

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
        public async Task<IActionResult> Actualizar_ProductImages([FromBody] ProductImagesActualizarDTOs dto)
        {
            try
            {
                if (dto == null || !dto.ProductImageId.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del registro es obligatorio." });
                }

                OUTPUT resultado = await _service.Editar_ProductImages_async(dto);

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
        public async Task<IActionResult> Eliminar_ProductImages(int id, int idModificador)
        {
            try
            {
                OUTPUT resultado = await _service.Eliminar_ProductImages_async(id, idModificador);

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
    }
}
