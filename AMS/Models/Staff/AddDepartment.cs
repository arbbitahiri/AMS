using AMS.Resources;
using AMS.Utilities.AttributeValidations;
using System.ComponentModel.DataAnnotations;

namespace AMS.Models.Staff;

public class AddDepartment
{
    public string StaffIde { get; set; }
    public string StaffDepartmentIde { get; set; }

    [Display(Name = "Department", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public int DepartmentId { get; set; }

    [Display(Name = "StaffType", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public int StaffTypeId { get; set; }

    [Display(Name = "StartDate", ResourceType = typeof(Resource))]
    [DateGreaterThanToday(ErrorMessageResourceName = "DateCannotBeLessThanToday", ErrorMessageResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public DateTime StartDate { get; set; }

    [Display(Name = "EndDate", ResourceType = typeof(Resource))]
    [DateGreaterThanToday(ErrorMessageResourceName = "DateCannotBeLessThanToday", ErrorMessageResourceType = typeof(Resource))]
    [DateCompare(nameof(StartDate), nameof(StartDate), ErrorMessageResourceName = "StartDateVSEndDate", ErrorMessageResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public DateTime EndDate { get; set; }

    [Display(Name = "Description", ResourceType = typeof(Resource))]
    public string Description { get; set; }
}
