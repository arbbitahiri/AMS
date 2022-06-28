namespace AMS.Models.Staff;

public class DepartmentVM
{
    public string StaffIde { get; set; }

    public StaffDetails StaffDetails { get; set; }
    public List<Departments> Departments { get; set; }

    public int DepartmentCount { get; set; }
    public int MethodType { get; set; }
}
