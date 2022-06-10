using AMS.Resources;
using System.ComponentModel.DataAnnotations;

namespace AMS.Areas.Administration.Models.Users;

public class SetPassword
{
    public string UserIde { get; set; }
    public string Name { get; set; }

    [DataType(DataType.Password)]
    [Display(Name = "NewPassword", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    [StringLength(32, ErrorMessageResourceName = "CharacterLength", ErrorMessageResourceType = typeof(Resource), MinimumLength = 6)]
    public string NewPassword { get; set; }

    [DataType(DataType.Password)]
    [Display(Name = "ConfirmNewPassword", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    [Compare("NewPassword", ErrorMessageResourceName = "PasswordNotMatch", ErrorMessageResourceType = typeof(Resource))]
    public string ConfirmPassword { get; set; }
}
