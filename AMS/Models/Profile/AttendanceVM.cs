namespace AMS.Models.Profile;

public class AttendanceVM
{
    public string StaffIde { get; set; }
    public List<AttendanceDetails> Attendances { get; set; }
}

public class AttendanceDetails
{
    public string AttendanceIde { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public int WorkingSince { get; set; }
}
