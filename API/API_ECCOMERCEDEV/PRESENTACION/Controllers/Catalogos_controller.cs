
using APLICATION.DTOs.Catalogos;
using Microsoft.AspNetCore.Mvc;


namespace PRESENTACION.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class Catalogos_controller : Controller
    {

            [HttpGet("Paises")]
            public IActionResult ObtenerPaises()
            {
                var paises = new List<catalogos_Fire>()
            {
                new catalogos_Fire{ id=1, nombre="Nicaragua"},
                new catalogos_Fire{ id=2, nombre="Honduras"},
                new catalogos_Fire{ id=3, nombre="El Salvador"},
                new catalogos_Fire{ id=4, nombre="Guatemala"},
                new catalogos_Fire{ id=5, nombre="Costa Rica"},
                new catalogos_Fire{ id=6, nombre="Panamá"},
                new catalogos_Fire{ id=7, nombre="Belice"},
            };

                return Ok(paises);
            }

            [HttpGet("Generos")]
            public IActionResult ObtenerGeneros()
            {
                var generos = new List<catalogos_Fire>()
            {
                new catalogos_Fire{ id=1, nombre="Masculino"},
                new catalogos_Fire{ id=2, nombre="Femenino"},
            };

                return Ok(generos);
            }

        
    }
}
