using AMS.Utilities;
using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;

namespace AMS.Data.Core;

public class ApplicationUser : IdentityUser
{
    public ApplicationUser()
    {
        AppMode = TemplateMode.Light;
        InsertedDate = DateTime.Now;
    }

    [Required, StringLength(64)]
    public string PersonalNumber { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    [StringLength(512)]
    public string ProfileImage { get; set; }
    public TemplateMode AppMode { get; set; }
    public LanguageEnum Language { get; set; }
    public bool AllowNotification { get; set; }
    public string InsertedFrom { get; set; }
    public DateTime InsertedDate { get; set; }
    public string UpdateFrom { get; set; }
    public DateTime? UpdateDate { get; set; }
    public int? UpdateNo { get; set; }
}
