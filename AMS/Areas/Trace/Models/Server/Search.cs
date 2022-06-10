using System.Diagnostics;

namespace AMS.Areas.Trace.Models.Server;

public class Search
{
    public string LogTime { get; set; }

    public EventLogEntryType? EventLogEntryType { get; set; }
}
