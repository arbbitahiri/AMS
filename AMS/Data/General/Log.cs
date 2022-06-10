using System;
using System.Collections.Generic;

namespace AMS.Data.General
{
    public partial class Log
    {
        public int LogId { get; set; }
        public string? UserId { get; set; }
        public string Ip { get; set; } = null!;
        public string Controller { get; set; } = null!;
        public string Action { get; set; } = null!;
        public string? Developer { get; set; }
        public string? Description { get; set; }
        public string HttpMethod { get; set; } = null!;
        public string Url { get; set; } = null!;
        public string? FormContent { get; set; }
        public bool Error { get; set; }
        public string? Exception { get; set; }
        public DateTime InsertedDate { get; set; }

        public virtual AspNetUsers? User { get; set; }
    }
}
