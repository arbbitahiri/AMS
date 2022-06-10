namespace AMS.Areas.Administration.Models.Users;

public class AddRole
{
    public string UserIde { get; set; }
    public string Name { get; set; }
    public List<string> Roles { get; set; }
    public string Password { get; set; }
}
