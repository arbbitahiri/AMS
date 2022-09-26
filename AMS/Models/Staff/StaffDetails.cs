namespace AMS.Models.Staff;

public class StaffDetails
{
    public string Ide { get; set; }
    public string PersonalNumber { get; set; }
    public string Firstname { get; set; }
    public string Lastname { get; set; }
    public DateTime BirthDate { get; set; }
    public string Gender { get; set; }
    public string ProfileImage { get; set; }
    public string Email { get; set; }
    public string PhoneNumber { get; set; }
    public string StaffType { get; set; }

    public int MethodType { get; set; }
    public DateTime InsertedDate { get; set; }

    public string UserId { get; set; }
    public bool HasAccount { get; set; }
}
