using AMS.Resources;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace AMS.Models.StaffDepartment;

public class AddStaff
{
    public string StaffIde { get; set; }
    public string StaffName { get; set; }

    [Display(Name = "Department", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public int DepartmentId { get; set; }

    [Display(Name = "StaffType", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public int StaffTypeId { get; set; }

    [Display(Name = "StartDate", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public DateTime StartDate { get; set; }

    [Display(Name = "EndDate", ResourceType = typeof(Resource))]
    [Remote("CheckDates", "StaffDepartment", AdditionalFields = nameof(StartDate), ErrorMessageResourceName = "StartDateVSEndDate", ErrorMessageResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public DateTime EndDate { get; set; }

    [Display(Name = "Description", ResourceType = typeof(Resource))]
    public string Description { get; set; }
}
