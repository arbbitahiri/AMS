namespace AMS.Models.Staff;

public class Documents
{
    public string StaffDocumentIde { get; set; }
    public string Title { get; set; }
    public string Path { get; set; }
    public string FileType { get; set; }
    public bool Expires { get; set; }
    public string DocumentType { get; set; }
    public string Description { get; set; }
    public bool Active { get; set; }
}

public class DocumentsVM
{
    public string StaffIde { get; set; }

    public StaffDetails StaffDetails { get; set; }
    public List<Documents> Documents { get; set; }

    public int DocumentCount { get; set; }
}
