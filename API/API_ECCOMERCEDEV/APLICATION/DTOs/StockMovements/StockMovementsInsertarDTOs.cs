using System;

namespace APLICATION.DTOs.StockMovements
{
    public class StockMovementsInsertarDTOs
    {
        public int? stockMovementType { get; set; }
        public int? stockMovementOrderId { get; set; }
        public string? stockMovementReference { get; set; }
        public DateTime? stockMovementDate { get; set; }
        public int? stockMovementCreatorId { get; set; }
        public int? stockMovementStatusId { get; set; }
    }
}
