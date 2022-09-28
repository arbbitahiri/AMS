namespace AMS.Models.Attendance;

public class StaffList
{
    public string StaffAttendanceIde { get; set; }
    public string StaffIde { get; set; }
    public string PersonalNumber { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public DateTime BirthDate { get; set; }
    public string Department { get; set; }
    public string StaffType { get; set; }
    public string AbsentType { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public bool Attended { get; set; }
    public int WorkingSince { get; set; }
}
