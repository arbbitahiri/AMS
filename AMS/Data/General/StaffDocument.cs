using System;
using System.Collections.Generic;

namespace AMS.Data.General
{
    public partial class StaffDocument
    {
        public int StaffDocumentId { get; set; }
        public int StaffId { get; set; }
        public int DocumentTypeId { get; set; }
        public string Title { get; set; } = null!;
        public string Path { get; set; } = null!;
        public string? Description { get; set; }
        public bool Active { get; set; }
        public string InsertedFrom { get; set; } = null!;
        public DateTime InsertedDate { get; set; }
        public string? UpdatedFrom { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? UpdatedNo { get; set; }

        public virtual DocumentType DocumentType { get; set; } = null!;
        public virtual AspNetUsers InsertedFromNavigation { get; set; } = null!;
        public virtual Staff Staff { get; set; } = null!;
        public virtual AspNetUsers? UpdatedFromNavigation { get; set; }
    }
}
