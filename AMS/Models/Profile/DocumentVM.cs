namespace AMS.Models.Profile;

public class DocumentVM
{
    public string StaffIde { get; set; }
    public List<DocumentDetails> Documents { get; set; }
}

public class DocumentDetails
{
    public string StaffDocumentIde { get; set; }
    public string Title { get; set; }
    public string Path { get; set; }
    public string PathExtension { get; set; }
    public string DocumentType { get; set; }
    public string Description { get; set; }
    public bool Active { get; set; }
}
