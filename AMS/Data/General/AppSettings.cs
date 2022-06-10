using System;
using System.Collections.Generic;

namespace AMS.Data.General
{
    public partial class AppSettings
    {
        public int AppSettingsId { get; set; }
        public string OldVersion { get; set; } = null!;
        public string NewVersion { get; set; } = null!;
        public string InsertedFrom { get; set; } = null!;
        public DateTime? InsertedDate { get; set; }

        public virtual AspNetUsers InsertedFromNavigation { get; set; } = null!;
    }
}
