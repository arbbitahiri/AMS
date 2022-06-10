using System;
using System.Collections.Generic;

namespace AMS.Data.General
{
    public partial class Gender
    {
        public Gender()
        {
            Staff = new HashSet<Staff>();
        }

        public int GenderId { get; set; }
        public string NameSq { get; set; } = null!;
        public string NameEn { get; set; } = null!;

        public virtual ICollection<Staff> Staff { get; set; }
    }
}
