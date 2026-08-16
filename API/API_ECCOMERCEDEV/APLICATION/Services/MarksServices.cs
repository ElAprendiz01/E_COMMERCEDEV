using APLICATION.DTOs.Marks;
using APLICATION.Interfaces;
using DOMAIN.Marks;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class MarksServices
    {
        private readonly IMarksRepository _repository;

        public MarksServices(IMarksRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<MarksListarDTOs>> Listar_Marks_async()
        {
            var data = await _repository.Listar_MarksAsync();
            return data.Select(x => new MarksListarDTOs
            {
                MarcaID = x.MarcaID,
                Marca = x.Marca,
                Descripcion = x.Descripcion,
                CreadorID = x.CreadorID,
                CreadorNombre = x.CreadorNombre,
                FechaCreacion = x.FechaCreacion,
                ModificadorID = x.ModificadorID,
                ModificadorNombre = x.ModificadorNombre,
                FechaModificacion = x.FechaModificacion,
                EstadoID = x.EstadoID,
                Estado = x.Estado
            });
        }

        public async Task<IEnumerable<MarksFiltrarDTOs>> Filtrar_Marks_async(string? searchTerm)
        {
            var data = await _repository.Filtrar_MarksAsync(searchTerm);
            return data.Select(x => new MarksFiltrarDTOs
            {
                MarcaID = x.MarcaID,
                Marca = x.Marca,
                Descripcion = x.Descripcion,
                CreadorID = x.CreadorID,
                CreadorNombre = x.CreadorNombre,
                FechaCreacion = x.FechaCreacion,
                ModificadorID = x.ModificadorID,
                ModificadorNombre = x.ModificadorNombre,
                FechaModificacion = x.FechaModificacion,
                EstadoID = x.EstadoID,
                Estado = x.Estado
            });
        }

        public async Task<OUTPUT> Insertar_Marks_async(MarksinsertarDTOs dto)
        {
            var modelo = new DM_Marks_insertar
            {
                markName = dto.markName,
                markDescription = dto.markDescription,
                markCreatorId = dto.markCreatorId,
                markStatusId = dto.markStatusId
            };
            return await _repository.Insertar_MarksAsync(modelo);
        }

        public async Task<OUTPUT> Editar_Marks_async(MarksEditarDTOs dto)
        {
            var modelo = new DM_Marks_actualizar
            {
                markId = dto.markId,
                markName = dto.markName,
                markDescription = dto.markDescription,
                markModificatorId = dto.markModificatorId,
                markStatusId = dto.markStatusId,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Editar_MarksAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_Marks_async(int? markId, int? markModificatorId)
        {
            return await _repository.Eliminar_MarksAsync(markId, markModificatorId);
        }
    }
}
