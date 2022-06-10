using System;
using System.Collections.Generic;

namespace AMS.Data.General
{
    public partial class Staff
    {
        public Staff()
        {
            StaffDepartment = new HashSet<StaffDepartment>();
            StaffDocument = new HashSet<StaffDocument>();
        }

        public int StaffId { get; set; }
        public string UserId { get; set; } = null!;
        public string PersonalNumber { get; set; } = null!;
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public DateTime BirthDate { get; set; }
        public int GenderId { get; set; }
        public int CityId { get; set; }
        public int CountryId { get; set; }
        public string? Address { get; set; }
        public string? PostalCode { get; set; }
        public string InsertedFrom { get; set; } = null!;
        public DateTime InsertedDate { get; set; }
        public string? UpdatedFrom { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? UpdatedNo { get; set; }

        public virtual City City { get; set; } = null!;
        public virtual Country Country { get; set; } = null!;
        public virtual Gender Gender { get; set; } = null!;
        public virtual AspNetUsers InsertedFromNavigation { get; set; } = null!;
        public virtual AspNetUsers? UpdatedFromNavigation { get; set; }
        public virtual AspNetUsers User { get; set; } = null!;
        public virtual ICollection<StaffDepartment> StaffDepartment { get; set; }
        public virtual ICollection<StaffDocument> StaffDocument { get; set; }
    }
}
