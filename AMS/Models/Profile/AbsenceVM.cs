namespace AMS.Models.Profile;

public class AbsenceVM
{
    public string StaffIde { get; set; }
    public List<AbsenceDetails> Absences { get; set; }
}

public class AbsenceDetails
{
    public string StaffAttendanceIde { get; set; }
    public DateTime InsertedDate { get; set; }
    public string AbsenceType { get; set; }
    public string Description { get; set; }
}
