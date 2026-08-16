using System;

namespace APLICATION.DTOs.ProductVariableTypes
{
    public class ProductVariableTypesActualizarDTOs
    {
        public int? ProductVariableTypeId { get; set; }
        public string? ProductVariableTypeName { get; set; }
        public string? ProductVariableTypeDescription { get; set; }
        public int? ProductVariableTypeModificatorId { get; set; }
        public bool? ProductVariableTypeStatusId { get; set; }
    }
}
