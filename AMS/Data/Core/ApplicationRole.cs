using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;

namespace AMS.Data.Core;

public class ApplicationRole : IdentityRole
{
    [Required, StringLength(128)]
    public string NameSQ { get; set; }

    [Required, StringLength(128)]
    public string NameEN { get; set; }

    [StringLength(4000)]
    public string Description { get; set; }

}
