namespace AMS.Models.Profile;

public class DepartmentVM
{
    public string StaffIde { get; set; }
    public List<DepartmentDetails> Departments { get; set; }
}

public class DepartmentDetails
{
    public string StaffDepartmentIde { get; set; }
    public string Department { get; set; }
    public string StaffType { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
}
