using System;
using System.Collections.Generic;

namespace AMS.Data.General
{
    public partial class StaffDepartment
    {
        public StaffDepartment()
        {
            StaffDepartmentAttendance = new HashSet<StaffDepartmentAttendance>();
        }

        public int StaffDepartmentId { get; set; }
        public int StaffId { get; set; }
        public int DepartmentId { get; set; }
        public int StaffTypeId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string? Description { get; set; }
        public string InsertedFrom { get; set; } = null!;
        public DateTime InsertedDate { get; set; }
        public string? UpdatedFrom { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? UpdatedNo { get; set; }

        public virtual Department Department { get; set; } = null!;
        public virtual AspNetUsers InsertedFromNavigation { get; set; } = null!;
        public virtual Staff Staff { get; set; } = null!;
        public virtual AspNetUsers? UpdatedFromNavigation { get; set; }
        public virtual ICollection<StaffDepartmentAttendance> StaffDepartmentAttendance { get; set; }
    }
}
