namespace AMS.Models.Document;

public class Search
{
    public string Title { get; set; }
    public int? StaffId { get; set; }
    public int? DocumentTypeId { get; set; }
    public DateTime? InsertDate { get; set; }
    public int? ExpireId { get; set; }
}
