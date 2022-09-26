using System;
using System.Collections.Generic;

namespace AMS.Data.General
{
    public partial class Email
    {
        public int EmailId { get; set; }
        public string EmailAddress { get; set; }
        public string Password { get; set; }
        public string Smtphost { get; set; }
        public string Cc { get; set; }
        public int Port { get; set; }
        public bool Sslprotocol { get; set; }
        public bool Active { get; set; }
        public string InsertedFrom { get; set; }
        public DateTime InsertedDate { get; set; }
        public string UpdatedFrom { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? UpdatedNo { get; set; }

        public virtual AspNetUsers InsertedFromNavigation { get; set; }
        public virtual AspNetUsers UpdatedFromNavigation { get; set; }
    }
}
