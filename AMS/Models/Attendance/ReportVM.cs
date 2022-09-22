namespace AMS.Models.Attendance;

public class ReportVM
{
    public int StaffId { get; set; }
    public string PersonalNumber { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string BirthDate { get; set; }
    public string Department { get; set; }
    public string StartDate { get; set; }
    public string EndDate { get; set; }
    public string Attended { get; set; }
    public string AbsentType { get; set; }
    public string WorkingSince { get; set; }
}
