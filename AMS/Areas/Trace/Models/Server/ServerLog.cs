using System.Diagnostics;

namespace AMS.Areas.Trace.Models.Server;

public class ServerLog
{
    public EventLogEntryType EventLogEntryType { get; set; }
    public string EntryType { get; set; }
    public string Machine { get; set; }
    public string Source { get; set; }
    public DateTime Time { get; set; }
    public string Username { get; set; }
    public string Message { get; set; }
}
