namespace AMS.Models.Attendance;

public class AttendanceList
{
    public string StaffAttendanceIde { get; set; }
    public string PersonalNumber { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string Department { get; set; }
    public string StaffType { get; set; }
    public DateTime Date { get; set; }
    public string Absent { get; set; }
    public int WorkingSince { get; set; }
}
