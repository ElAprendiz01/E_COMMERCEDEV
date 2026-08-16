using System;

namespace APLICATION.DTOs.ProductVariableTypes
{
    public class ProductVariableTypesFiltrarDTOs
    {
        public int? ProductVariableTypeId { get; set; }
        public string? ProductVariableTypeName { get; set; }
        public string? ProductVariableTypeDescription { get; set; }
        public int? ProductVariableTypeCreatorId { get; set; }
        public DateTime? ProductVariableTypeCreationDate { get; set; }
        public int? ProductVariableTypeModificatorId { get; set; }
        public DateTime? ProductVariableTypeModificationDate { get; set; }
        public bool? ProductVariableTypeStatusId { get; set; }
    }
}
