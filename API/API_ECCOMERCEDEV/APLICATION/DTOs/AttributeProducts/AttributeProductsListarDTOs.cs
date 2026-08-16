using System;

namespace APLICATION.DTOs.AttributeProducts
{
    public class AttributeProductsListarDTOs
    {
        public int? AttributeProductId { get; set; }
        public int? AttributeProductAttributesTypeId { get; set; }
        public string? AttributeProductName { get; set; }
        public string? AttributeProductDescription { get; set; }
        public int? AttributeProductCreatorId { get; set; }
        public DateTime? AttributeProductCreationDate { get; set; }
        public int? AttributeProductModificatorId { get; set; }
        public DateTime? AttributeProductModificationDate { get; set; }
        public int? AttributeProductStatusId { get; set; }
    }
}