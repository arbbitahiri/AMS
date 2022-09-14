using AMS.Resources;
using System.ComponentModel.DataAnnotations;

namespace AMS.Models.Attendance;

public class AbsentDetails
{
    public string AttendanceIde { get; set; }
    public string StaffName { get; set; }

    [Display(Name = "Date", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string AttendanceDate { get; set; }

    [Display(Name = "AbsentType", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public int? AbsentTypeId { get; set; }

    [Display(Name = "Description", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string Description { get; set; }
}
