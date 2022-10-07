using System;
using System.Collections.Generic;

namespace AMS.Data.General
{
    public partial class DatabaseQuery
    {
        public int DatabaseQueryId { get; set; }
        public string Query { get; set; }
        public string InsertedFrom { get; set; }
        public DateTime InsertedDate { get; set; }

        public virtual AspNetUsers InsertedFromNavigation { get; set; }
    }
}
