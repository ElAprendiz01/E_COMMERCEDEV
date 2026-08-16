using System;

namespace DOMAIN.Status
{
    public class DM_StatusListar
    {
        public int? statusId { get; set; }
        public string? statusName { get; set; }
        public int? statusCreatorId { get; set; }
        public DateTime? statusCreationDate { get; set; }
        public int? statusStatusId { get; set; }
    }
}