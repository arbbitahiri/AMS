using System;
using System.Collections.Generic;

namespace AMS.Data.General
{
    public partial class AbsentType
    {
        public AbsentType()
        {
            StaffAttendance = new HashSet<StaffAttendance>();
        }

        public int AbsentTypeId { get; set; }
        public string NameSq { get; set; }
        public string NameEn { get; set; }
        public bool Active { get; set; }
        public string InsertedFrom { get; set; }
        public DateTime InsertedDate { get; set; }
        public string UpdatedFrom { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? UpdatedNo { get; set; }

        public virtual AspNetUsers InsertedFromNavigation { get; set; }
        public virtual AspNetUsers UpdatedFromNavigation { get; set; }
        public virtual ICollection<StaffAttendance> StaffAttendance { get; set; }
    }
}
