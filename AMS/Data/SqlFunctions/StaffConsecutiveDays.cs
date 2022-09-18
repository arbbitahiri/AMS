namespace AMS.Data.SqlFunctions;

public class StaffConsecutiveDays
{
    public int StaffId { get; set; }
    public string PersonalNumber { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public DateTime BirthDate { get; set; }
    public string Department { get; set; }
    public int WorkingSince { get; set; }
    public bool Attended { get; set; }
}
