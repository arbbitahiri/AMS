using System;
using System.Collections.Generic;

namespace AMS.Data.General
{
    public partial class SubMenu
    {
        public int SubMenuId { get; set; }
        public int MenuId { get; set; }
        public string NameSq { get; set; } = null!;
        public string NameEn { get; set; } = null!;
        public string? Icon { get; set; }
        public string? Claim { get; set; }
        public string? ClaimType { get; set; }
        public string? Area { get; set; }
        public string? Controller { get; set; }
        public string? Action { get; set; }
        public int OrdinalNumber { get; set; }
        public string? Roles { get; set; }
        public string? OpenFor { get; set; }
        public bool Active { get; set; }
        public string InsertedFrom { get; set; } = null!;
        public DateTime InsertedDate { get; set; }
        public string? UpdatedFrom { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? UpdatedNo { get; set; }

        public virtual AspNetUsers InsertedFromNavigation { get; set; } = null!;
        public virtual Menu Menu { get; set; } = null!;
        public virtual AspNetUsers? UpdatedFromNavigation { get; set; }
    }
}
