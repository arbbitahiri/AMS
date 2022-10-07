using AMS.Models.Shared;

namespace AMS.Areas.Trace.Models.Database;

public class DatabaseResult
{
    public List<string[]> Results { get; set; }
    public ErrorVM Error { get; set; }
}
