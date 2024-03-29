﻿using System;
using System.Collections.Generic;

namespace AMS.Data.General
{
    public partial class AspNetRoles
    {
        public AspNetRoles()
        {
            AspNetRoleClaims = new HashSet<AspNetRoleClaims>();
            RealRole = new HashSet<RealRole>();
            User = new HashSet<AspNetUsers>();
        }

        public string Id { get; set; }
        public string Name { get; set; }
        public string NameSq { get; set; }
        public string NameEn { get; set; }
        public string Description { get; set; }
        public string NormalizedName { get; set; }
        public string ConcurrencyStamp { get; set; }

        public virtual ICollection<AspNetRoleClaims> AspNetRoleClaims { get; set; }
        public virtual ICollection<RealRole> RealRole { get; set; }

        public virtual ICollection<AspNetUsers> User { get; set; }
    }
}
