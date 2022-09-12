namespace AMS.Models.Attendance;

public class SearchAttendance
{
    public int? AStaffId { get; set; }
    public int? ADepartmentId { get; set; }
    public int? AStaffTypeId { get; set; }
    public DateTime? AStartDate { get; set; }
    public DateTime? AEndDate { get; set; }
}
