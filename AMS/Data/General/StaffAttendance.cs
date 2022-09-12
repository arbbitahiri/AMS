using System;
using System.Collections.Generic;

namespace AMS.Data.General
{
    public partial class StaffAttendance
    {
        public int StaffAttendanceId { get; set; }
        public int StaffId { get; set; }
        public bool Absent { get; set; }
        public int? AbsentTypeId { get; set; }
        public string Description { get; set; }
        public bool Active { get; set; }
        public string InsertedFrom { get; set; }
        public DateTime InsertedDate { get; set; }
        public string UpdatedFrom { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? UpdatedNo { get; set; }

        public virtual AbsentType AbsentType { get; set; }
        public virtual AspNetUsers InsertedFromNavigation { get; set; }
        public virtual Staff Staff { get; set; }
        public virtual AspNetUsers UpdatedFromNavigation { get; set; }
    }
}
