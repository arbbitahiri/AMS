using System;
using System.Collections.Generic;

namespace AMS.Data.General
{
    public partial class Notification
    {
        public int NotificationId { get; set; }
        public string Receiver { get; set; } = null!;
        public int Type { get; set; }
        public string Title { get; set; } = null!;
        public string? Description { get; set; }
        public string? Url { get; set; }
        public string Icon { get; set; } = null!;
        public bool Read { get; set; }
        public bool Deleted { get; set; }
        public string InsertedFrom { get; set; } = null!;
        public DateTime InsertedDate { get; set; }

        public virtual AspNetUsers InsertedFromNavigation { get; set; } = null!;
        public virtual AspNetUsers ReceiverNavigation { get; set; } = null!;
    }
}
