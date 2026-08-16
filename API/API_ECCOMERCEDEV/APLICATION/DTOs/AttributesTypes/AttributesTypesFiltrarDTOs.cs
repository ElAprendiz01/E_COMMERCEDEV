using System;

namespace APLICATION.DTOs.AttributesTypes
{
    public class AttributesTypesFiltrarDTOs
    {
        public int? attributeTypeId { get; set; }
        public string? attributeTypeName { get; set; }
        public string? attributeTypeDescription { get; set; }
        public int? attributeTypeCreatorId { get; set; }
        public DateTime? attributeTypeCreationDate { get; set; }
        public int? attributeTypeModificatorId { get; set; }
        public DateTime? attributeTypeModificationDate { get; set; }
        public bool? attributeTypeStatusId { get; set; }
    }
}