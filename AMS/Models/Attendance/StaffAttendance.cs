namespace AMS.Models.Attendance;

public class StaffAttendance
{
    public string AttendanceIde { get; set; }
    public string StaffName { get; set; }
    public string AttendanceDate { get; set; }
    public int? AbsentTypeId { get; set; }
    public string Description { get; set; }
}
