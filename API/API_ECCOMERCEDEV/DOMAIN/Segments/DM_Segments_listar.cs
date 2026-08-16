using System;

namespace DOMAIN.Segments
{
    public class DM_Segments_listar
    {
        public int? segmentId { get; set; }
        public string? segmentName { get; set; }
        public string? segmentDescription { get; set; }
        public int? segmentCreatorId { get; set; }
        public bool? segmentStatusId { get; set; }
        public DateTime? segmentCreationDate { get; set; }
        public DateTime? segmentModificationDate { get; set; }
    }
}
