namespace AMS.Models.Attendance;

public class SearchAbsence
{
    public int? BStaffId { get; set; }
    public int? BDepartmentId { get; set; }
    public int? BStaffTypeId { get; set; }
    public int? BAbsentTypeId { get; set; }
    public DateTime? BInsertedDate { get; set; }
}
