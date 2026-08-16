using System;

namespace APLICATION.DTOs.Status
{
    public class StatusListarDTOs
    {
        public int? statusId { get; set; }
        public string? statusName { get; set; }
        public int? statusCreatorId { get; set; }
        public DateTime? statusCreationDate { get; set; }
        public int? statusStatusId { get; set; }
    }
}