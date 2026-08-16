using System;

namespace DOMAIN.AttributeProductVariables
{
    public class DM_AttributeProductVariables_update
    {
        public int? AttributeProductVariableId { get; set; }
        public int? AttributeProductVariableProductVariableId { get; set; }
        public int? AttributeProductVariableAttributeProductId { get; set; }
        public string? AttributeProductVariableValue { get; set; }
        public int? AttributeProductVariableModificatorId { get; set; }
        public bool? AttributeProductVariableStatusId { get; set; }
        public bool? ForzarRecuperacion { get; set; }
    }
}
