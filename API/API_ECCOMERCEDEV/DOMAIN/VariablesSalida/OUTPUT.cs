using System;
using System.Collections.Generic;
using System.Text;

namespace DOMAIN.VariablesSalida
{
    public class OUTPUT
    {
        public int? Code { get; set; }
        public string? Message { get; set; }
        public int? TemplateId { get; set; }

        public int? PageNumber { get; set; }
        public int? PageSize { get; set; }
        public int? TotalRows { get; set; }

        public object? Data { get; set; }

        public bool IsSuccess => Code >= 0;
    }
}