using System;

namespace APLICATION.DTOs.AttributeProductVariables
{
    public class AttributeProductVariablesCreateDTOs
    {
        public int? AttributeProductVariableProductVariableId { get; set; }
        public int? AttributeProductVariableAttributeProductId { get; set; }
        public string? AttributeProductVariableValue { get; set; }
        public int? AttributeProductVariableCreatorId { get; set; }
        public bool? AttributeProductVariableStatusId { get; set; }
    }
}
