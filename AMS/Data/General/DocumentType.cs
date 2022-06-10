using System;
using System.Collections.Generic;

namespace AMS.Data.General
{
    public partial class DocumentType
    {
        public DocumentType()
        {
            StaffDocument = new HashSet<StaffDocument>();
        }

        public int DocumentTypeId { get; set; }
        public string NameSq { get; set; } = null!;
        public string NameEn { get; set; } = null!;
        public bool Active { get; set; }
        public string InsertedFrom { get; set; } = null!;
        public DateTime InsertedDate { get; set; }
        public string? UpdatedFrom { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? UpdatedNo { get; set; }

        public virtual AspNetUsers InsertedFromNavigation { get; set; } = null!;
        public virtual AspNetUsers? UpdatedFromNavigation { get; set; }
        public virtual ICollection<StaffDocument> StaffDocument { get; set; }
    }
}
