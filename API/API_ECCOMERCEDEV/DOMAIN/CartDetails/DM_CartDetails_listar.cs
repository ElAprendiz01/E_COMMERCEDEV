using System;

namespace DOMAIN.CartDetails
{
    public class DM_CartDetails_listar
    {
        public int? cartDetailId { get; set; }
        public int? cartDetailCartId { get; set; }
        public int? cartDetailProductVariableId { get; set; }
        public decimal? cartDetailPrice { get; set; }
        public int? cartDetailQuantity { get; set; }
        public decimal? cartDetailDiscount { get; set; }
        public decimal? cartDetailSubTotal { get; set; }
        public decimal? cartDetailTAX { get; set; }
        public decimal? cartDetailTotal { get; set; }
        public int? cartDetailCurrencyId { get; set; }
        public int? cartDetailCreatorId { get; set; }
        public DateTime? cartDetailCreationDate { get; set; }
        public int? cartDetailModificatorId { get; set; }
        public DateTime? cartDetailModificationDate { get; set; }
        public bool? cartDetailStatusId { get; set; }
    }
}
