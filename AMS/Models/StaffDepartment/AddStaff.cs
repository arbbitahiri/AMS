using AMS.Resources;
using AMS.Utilities.AttributeValidations;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace AMS.Models.StaffDepartment;

public class AddStaff
{
    public string StaffIde { get; set; }
    public string StaffName { get; set; }

    [Display(Name = "Department", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public int ADepartmentId { get; set; }

    [Display(Name = "StaffType", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public int AStaffTypeId { get; set; }

    [Display(Name = "StartDate", ResourceType = typeof(Resource))]
    [DateGreaterThanToday(ErrorMessageResourceName = "DateCannotBeLessThanToday", ErrorMessageResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public DateTime AStartDate { get; set; }

    [Display(Name = "EndDate", ResourceType = typeof(Resource))]
    [DateGreaterThanToday(ErrorMessageResourceName = "DateCannotBeLessThanToday", ErrorMessageResourceType = typeof(Resource))]
    [DateCompare(nameof(AStartDate), nameof(AStartDate), ErrorMessageResourceName = "StartDateVSEndDate", ErrorMessageResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public DateTime AEndDate { get; set; }

    [Display(Name = "Description", ResourceType = typeof(Resource))]
    public string Description { get; set; }
}
