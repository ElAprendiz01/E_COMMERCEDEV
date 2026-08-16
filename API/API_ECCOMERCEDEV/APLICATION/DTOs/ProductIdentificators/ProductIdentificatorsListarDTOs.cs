using System;

namespace APLICATION.DTOs.ProductIdentificators
{
    public class ProductIdentificatorsListarDTOs
    {
        public int? ProductIdentificatorId { get; set; }
        public int? ProductIdentificatorCategoryId { get; set; }
        public int? ProductIdentificatorSubCategoryId { get; set; }
        public int? ProductIdentificatorSegmentId { get; set; }
        public int? ProductIdentificatorCreatorId { get; set; }
        public bool? ProductIdentificatorStatusId { get; set; }
    }
}
