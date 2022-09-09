using AMS.Resources;
using AMS.Utilities.Validation;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace AMS.Models.Staff;

public class StaffPost
{
    public int MethodType { get; set; }
    public string StaffIde { get; set; }

    [Display(Name = "PersonalNumber", ResourceType = typeof(Resource))]
    [RegularExpression(@"^.{10,}$", ErrorMessageResourceName = "MinChar10", ErrorMessageResourceType = typeof(Resource))]
    [StringLength(10, MinimumLength = 10, ErrorMessageResourceName = "MaxChar10", ErrorMessageResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string PersonalNumber { get; set; }

    [Display(Name = "Firstname", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string Firstname { get; set; }

    [Display(Name = "Lastname", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string Lastname { get; set; }

    [Display(Name = "Birthdate", ResourceType = typeof(Resource))]
    [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}")]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string BirthDate { get; set; }

    [Display(Name = "Gender", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public int GenderId { get; set; }

    [Display(Name = "City", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public int CityId { get; set; }

    [Display(Name = "Country", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public int CountryId { get; set; }

    [Display(Name = "Address", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string Address { get; set; }

    [Display(Name = "PostalCode", ResourceType = typeof(Resource))]
    public string PostalCode { get; set; }

    [Display(Name = "Email", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string Email { get; set; }

    [Display(Name = "PhoneNumber", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string PhoneNumber { get; set; }

    [Display(Name = "Username", ResourceType = typeof(Resource))]
    [RequiredIf(nameof(NewUser), "true", ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string Username { get; set; }

    [Display(Name = "NewUser", ResourceType = typeof(Resource))]
    public bool NewUser { get; set; }
}
