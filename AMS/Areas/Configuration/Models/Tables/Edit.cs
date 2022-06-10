using AMS.Resources;
using AMS.Utilities;
using System.ComponentModel.DataAnnotations;

namespace AMS.Areas.Configuration.Models.Tables;

public class Edit
{
    public string Ide { get; set; }

    public LookUpTable Table { get; set; }
    public string Title { get; set; }

    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string NameSQ { get; set; }

    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string NameEN { get; set; }
}
