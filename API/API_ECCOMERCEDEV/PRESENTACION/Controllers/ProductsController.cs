using APLICATION.DTOs.Products;
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
    public class ProductsController : ControllerBase
    {
        private readonly ProductsServices _service;

        public ProductsController(ProductsServices service)
        {
            _service = service;
        }

        [HttpGet("Listar")]
        public async Task<IActionResult> Listar_Products([FromQuery] int? pageNumber)
        {
            try
             {
                var (lista, output) = await _service.Listar_Products_async(pageNumber);
                if (lista == null || !lista.Any())
                {
                    return Ok(new
                    {
                        codigo = output.Code ?? 204,
                        msj = output.Message ?? "No hay más productos disponibles.",
                        pageNumber = output.PageNumber,
                        pageSize = output.PageSize,
                        totalRows = output.TotalRows ?? 0,
                        data = new List<ProductsListarDTOs>()
                    });
                }
                return Ok(new
                {
                    codigo = output.Code ?? 200,
                    msj = output.Message ?? "Consulta exitosa",
                    pageNumber = output.PageNumber,
                    pageSize = output.PageSize,
                    totalRows = output.TotalRows,
                    data = lista
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpGet("filtrar")]
        public async Task<IActionResult> Filtrar_Products([FromQuery] string? searchTerm, [FromQuery] int? pageNumber = 1)
        {
            try
            {
                var (lista, output) = await _service.Filtrar_Products_async(searchTerm, pageNumber);
                if (lista == null || !lista.Any())
                {
                    return Ok(new
                    {
                        codigo = output.Code ?? 204,
                        msj = output.Message ?? "No se encontraron productos que coincidan con la búsqueda.",
                        pageNumber = output.PageNumber,
                        pageSize = output.PageSize,
                        totalRows = output.TotalRows ?? 0,
                        data = new List<ProductsFiltrarDTOs>()
                    });
                }
                return Ok(new
                {
                    codigo = output.Code ?? 200,
                    msj = output.Message ?? "Consulta exitosa",
                    pageNumber = output.PageNumber,
                    pageSize = output.PageSize,
                    totalRows = output.TotalRows,
                    data = lista
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpGet("filtrar_por_id/{productId}")]
        public async Task<IActionResult> Filtrar_Products_Por_Id([FromRoute] int productId)
        {
            try
            {
                var (lista, output) = await _service.Filtrar_Products_Por_Id_async(productId);
                if (lista == null || !lista.Any())
                {
                    return Ok(new
                    {
                        codigo = output.Code ?? 204,
                        msj = output.Message ?? "No se encontró el producto especificado.",
                        data = new List<ProductsFiltrarIdDTOs>()
                    });
                }
                return Ok(new
                {
                    codigo = output.Code ?? 200,
                    msj = output.Message ?? "Búsqueda de producto satisfactoria",
                    data = lista
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

       
        [HttpPost("insertar")]
        public async Task<IActionResult> Ingresar_Products([FromBody] ProductsinsertarDTOs model)
        {
            try
            {
                if (!ModelState.IsValid || model == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                OUTPUT resultado = await _service.Insertar_Products_async(model);

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
        public async Task<IActionResult> Editar_Products([FromBody] ProductsEditarDTOs model)
        {
            try
            {
                if (model == null || !model.productId.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del producto es obligatorio." });
                }

                OUTPUT resultado = await _service.Editar_Products_async(model);

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
        public async Task<IActionResult> Eliminar_Products(int? id, int? idModificador)
        {
            try
            {
                if (!id.HasValue || !idModificador.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID del producto y el ID del modificador son requeridos." });
                }

                OUTPUT resultado = await _service.Eliminar_Products_async(id, idModificador);

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
