using AMS.Resources;
using System.ComponentModel.DataAnnotations;

namespace AMS.Areas.Administration.Models.Email;

public class DataBaseEmail
{
    public string EmailIde { get; set; }

    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string DBEmail { get; set; }

    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string DBPassword { get; set; }

    public string DBCC { get; set; }

    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string DBHost { get; set; }

    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public int DBPort { get; set; }

    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public bool DBSSLEnable { get; set; }
}
