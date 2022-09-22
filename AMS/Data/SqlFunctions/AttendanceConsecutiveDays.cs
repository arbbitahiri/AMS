namespace AMS.Data.SqlFunctions;

public class AttendanceConsecutiveDays
{
    public int StaffAttendanceId { get; set; }
    public int StaffId { get; set; }
    public string PersonalNumber { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string Department { get; set; }
    public string StaffType { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public int WorkingSince { get; set; }
}
