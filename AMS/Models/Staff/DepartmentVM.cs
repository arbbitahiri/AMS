namespace AMS.Models.Staff;

public class DepartmentVM
{
    public StaffDetails StaffDetails { get; set; }
    public List<Departments> Departments { get; set; }
    public List<Roles> Roles { get; set; }
}
