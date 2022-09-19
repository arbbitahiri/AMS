namespace AMS.Models.Attendance;

public class AttendanceDetails
{
    public string StaffIde { get; set; }
    public string Name { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public List<AttendanceList> AttendanceList { get; set; }
}
