namespace AMS.Models.Menu;

public class SubMenuVM
{
    public int? SubMenuId { get; set; }
    public int? MenuId { get; set; }
    public string Title { get; set; }
    public string Area { get; set; }
    public string Controller { get; set; }
    public string Action { get; set; }
    public bool Submenu { get; set; }
    public string Icon { get; set; }
    public string OpenFor { get; set; }
}
