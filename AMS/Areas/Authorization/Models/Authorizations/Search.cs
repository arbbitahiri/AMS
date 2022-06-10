using AMS.Resources;
using System.ComponentModel.DataAnnotations;

namespace AMS.Areas.Authorization.Models.Authorizations;

public class Search
{
    [Display(Name = "Role", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string Role { get; set; }
}
