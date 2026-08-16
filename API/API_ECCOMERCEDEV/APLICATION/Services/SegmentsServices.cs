using APLICATION.DTOs.Segments;
using APLICATION.Interfaces;
using DOMAIN.Segments;
using DOMAIN.VariablesSalida;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace APLICATION.Services
{
    public class SegmentsServices
    {
        private readonly ISegmentsRepository _repository;

        public SegmentsServices(ISegmentsRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<SegmentsListarDTOs>> Listar_Segments_async()
        {
            var data = await _repository.Listar_SegmentsAsync();
            return data.Select(x => new SegmentsListarDTOs
            {
                segmentId = x.segmentId,
                segmentName = x.segmentName,
                segmentDescription = x.segmentDescription,
                segmentCreatorId = x.segmentCreatorId,
                segmentStatusId = x.segmentStatusId,
                segmentCreationDate = x.segmentCreationDate,
                segmentModificationDate = x.segmentModificationDate
            });
        }

        public async Task<IEnumerable<SegmentsFiltrarDTOs>> Filtrar_Segments_async(string? searchTerm)
        {
            var data = await _repository.Filtrar_SegmentsAsync(searchTerm);
            return data.Select(x => new SegmentsFiltrarDTOs
            {
                segmentId = x.segmentId,
                segmentName = x.segmentName,
                segmentDescription = x.segmentDescription,
                segmentStatusId = x.segmentStatusId
            });
        }

        public async Task<OUTPUT> Insertar_Segments_async(SegmentsinsertarDTOs dto)
        {
            var modelo = new DM_Segments_insertar
            {
                segmentName = dto.segmentName,
                segmentDescription = dto.segmentDescription,
                segmentCreatorId = dto.segmentCreatorId,
                segmentStatusId = dto.segmentStatusId
            };
            return await _repository.Insertar_SegmentsAsync(modelo);
        }

        public async Task<OUTPUT> Editar_Segments_async(SegmentsEditarDTOs dto)
        {
            var modelo = new DM_Segments_actualizar
            {
                segmentId = dto.segmentId,
                segmentName = dto.segmentName,
                segmentDescription = dto.segmentDescription,
                segmentModificatorId = dto.segmentModificatorId,
                segmentStatusId = dto.segmentStatusId,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Editar_SegmentsAsync(modelo);
        }

        public async Task<OUTPUT> Eliminar_Segments_async(int? segmentId, int? segmentModificatorId)
        {
            return await _repository.Eliminar_SegmentsAsync(segmentId, segmentModificatorId);
        }
    }
}
