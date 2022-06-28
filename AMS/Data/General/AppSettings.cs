using System;
using System.Collections.Generic;

namespace AMS.Data.General
{
    public partial class AppSettings
    {
        public int AppSettingsId { get; set; }
        public string OldVersion { get; set; }
        public string NewVersion { get; set; }
        public string InsertedFrom { get; set; }
        public DateTime? InsertedDate { get; set; }

        public virtual AspNetUsers InsertedFromNavigation { get; set; }
    }
}
