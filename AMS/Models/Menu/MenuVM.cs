namespace AMS.Models.Menu;

public class MenuVM
{
    public string Title { get; set; }
    public string Area { get; set; }
    public string Controller { get; set; }
    public string Action { get; set; }
    public bool HasSubMenu { get; set; }
    public string Icon { get; set; }
    public string OpenFor { get; set; }

    public List<SubMenuVM> SubMenus { get; set; }
}
