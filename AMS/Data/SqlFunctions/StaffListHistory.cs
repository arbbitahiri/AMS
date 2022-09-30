namespace AMS.Data.SqlFunctions;

public class StaffListHistory
{
    public int StaffDepartmentId { get; set; }
    public int StaffId { get; set; }
    public string PersonalNumber { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public DateTime DateOfBirth { get; set; }
    public string Department { get; set; }
    public string StaffType { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public string StatusType { get; set; }
}
