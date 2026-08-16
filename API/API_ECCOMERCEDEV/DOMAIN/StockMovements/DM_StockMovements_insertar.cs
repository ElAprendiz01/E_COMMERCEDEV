using System;

namespace DOMAIN.StockMovements
{
    public class DM_StockMovements_insertar
    {
        public int? stockMovementType { get; set; }
        public int? stockMovementOrderId { get; set; }
        public string? stockMovementReference { get; set; }
        public DateTime? stockMovementDate { get; set; }
        public int? stockMovementCreatorId { get; set; }
        public int? stockMovementStatusId { get; set; }
    }
}
