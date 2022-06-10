using System;
using System.Collections.Generic;

namespace AMS.Data.General
{
    public partial class RealRole
    {
        public int RealRoleId { get; set; }
        public string UserId { get; set; } = null!;
        public string RoleId { get; set; } = null!;
        public string InsertedFrom { get; set; } = null!;
        public DateTime InsertedDate { get; set; }
        public string? UpdatedFrom { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? UpdatedNo { get; set; }

        public virtual AspNetUsers InsertedFromNavigation { get; set; } = null!;
        public virtual AspNetRoles Role { get; set; } = null!;
        public virtual AspNetUsers? UpdatedFromNavigation { get; set; }
        public virtual AspNetUsers User { get; set; } = null!;
    }
}
