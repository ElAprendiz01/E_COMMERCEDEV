using System;

namespace APLICATION.DTOs.ProductVariableTypes
{
    public class ProductVariableTypesInsertarDTOs
    {
        public string? ProductVariableTypeName { get; set; }
        public string? ProductVariableTypeDescription { get; set; }
        public int? ProductVariableTypeCreatorId { get; set; }
        public bool? ProductVariableTypeStatusId { get; set; }
    }
}
