namespace AMS.Models.StaffDepartment;

public class Search
{
    public int? StaffId { get; set; }
    public int? DepartmentId { get; set; }
    public int? StaffTypeId { get; set; }
    public DateTime? StartDate { get; set; }
    public DateTime? EndDate { get; set; }

    public string PersonalNumber { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public DateTime? BirthDate { get; set; }
    public int? StatusTypeId { get; set; }

    public bool AdvancedSearch { get; set; }
}
