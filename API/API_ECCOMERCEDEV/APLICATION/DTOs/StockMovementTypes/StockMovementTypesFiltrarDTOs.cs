using System;

namespace APLICATION.DTOs.StockMovementTypes
{
    public class StockMovementTypesFiltrarDTOs
    {
        public int? StockMovementTypeId { get; set; }
        public string? StockMovementTypeName { get; set; }
        public string? StockMovementTypeDescription { get; set; }
        public int? StockMovementTypeCreatorId { get; set; }
        public DateTime? StockMovementTypeCreationDate { get; set; }
        public int? StockMovementTypeModificatorId { get; set; }
        public DateTime? StockMovementTypeModificationDate { get; set; }
        public bool? StockMovementTypeStatusId { get; set; }
    }
}
