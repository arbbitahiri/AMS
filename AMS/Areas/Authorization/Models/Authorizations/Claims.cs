namespace AMS.Areas.Authorization.Models.Authorizations;

public class Claims
{
    public string Role { get; set; }
    public string Policy { get; set; }
    public bool Access { get; set; }
}
