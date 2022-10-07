using AMS.Resources;
using AMS.Utilities.AttributeValidations;
using System.ComponentModel.DataAnnotations;

namespace AMS.Models.Document;

public class Edit
{
    public string StaffDocumentIde { get; set; }
    public string StaffName { get; set; }

    [Display(Name = "DocumentType", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public int EDocumentTypeId { get; set; }

    [Display(Name = "Title", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string ETitle { get; set; }

    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public bool Expires { get; set; }

    [Display(Name = "ExpireDate", ResourceType = typeof(Resource))]
    [RequiredIfChecked(nameof(Expires), true, ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public DateTime? ExpireDate { get; set; }

    [Display(Name = "Description", ResourceType = typeof(Resource))]
    public string Description { get; set; }
}
