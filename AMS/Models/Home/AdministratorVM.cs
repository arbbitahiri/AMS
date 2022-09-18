namespace AMS.Models.Home;

public class AdministratorVM
{
    public int StaffCount { get; set; }
    public int DocumentsCount { get; set; }
    public int AttendanceCount { get; set; }
    public int WorkingSince { get; set; }

    public List<LogVM> Logs { get; set; }
    public List<AttendanceVM> WeekAttandance { get; set; }
}
