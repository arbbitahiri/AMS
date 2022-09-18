namespace AMS.Models.Home;

public class DeveloperVM
{
    public int UsersCount { get; set; }
    public int LogsCount { get; set; }
    public int WorkingSince { get; set; }

    public List<UserRolesVM> UserRoles { get; set; }
    public List<LogVM> Logs { get; set; }
}

public class UserRolesVM
{
    public int Count { get; set; }
    public string Role { get; set; }
}
