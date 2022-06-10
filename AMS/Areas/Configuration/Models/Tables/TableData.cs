using AMS.Utilities;

namespace AMS.Areas.Configuration.Models.Tables;

public class TableData
{
    public LookUpTable Table { get; set; }
    public string Title { get; set; }
    public List<DataList> DataList { get; set; }
}
