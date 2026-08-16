using System;

namespace APLICATION.DTOs.AttributeProductVariables
{
    public class AttributeProductVariablesFiltrarDTOs
    {
        public int? AttributeProductVariableId { get; set; }
        public int? AttributeProductVariableProductVariableId { get; set; }
        public int? AttributeProductVariableAttributeProductId { get; set; }
        public string? AttributeProductVariableValue { get; set; }
        public int? AttributeProductVariableCreatorId { get; set; }
        public DateTime? AttributeProductVariableCreationDate { get; set; }
        public int? AttributeProductVariableModificatorId { get; set; }
        public DateTime? AttributeProductVariableModificationDate { get; set; }
        public bool? AttributeProductVariableStatusId { get; set; }
    }
}
