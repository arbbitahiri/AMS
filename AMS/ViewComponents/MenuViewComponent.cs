using AMS.Data.Core;
using AMS.Data.SqlFunctions;
using AMS.Models.Menu;
using AMS.Repositories;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace AMS.ViewComponents;

public class MenuViewComponent : ViewComponent
{
    private readonly UserManager<ApplicationUser> userManager;
    private readonly IFunctionRepository function;

    public MenuViewComponent(UserManager<ApplicationUser> userManager, IFunctionRepository function)
    {
        this.userManager = userManager;
        this.function = function;
    }

    public async Task<IViewComponentResult> InvokeAsync()
    {
        var menusTemp = new List<MenuList>();
        var user = (ApplicationUser)ViewData["InternalUser"];

        var roles = await userManager.GetRolesAsync(user);
        foreach (var role in roles)
        {
            var getMenu = (await function.MenuList(role, user.Language)).Where(a => !menusTemp.Any(n => n.SubMenuController == a.SubMenuController)).ToList();

            menusTemp.AddRange(getMenu);
        }

        var menus = menusTemp.OrderBy(a => a.MenuOrdinalNumber)
            .Select(a => new
            {
                a.MenuId,
                a.MenuTitle,
                a.HasSubMenu,
                a.MenuIcon,
                a.MenuArea,
                a.MenuController,
                a.MenuAction,
                a.MenuOpenFor
            }).Distinct().ToList()
            .Select(a => new MenuVM
            {
                Title = a.MenuTitle,
                HasSubMenu = a.HasSubMenu,
                Icon = a.MenuIcon,
                Area = a.MenuArea,
                Controller = a.MenuController,
                Action = a.MenuAction,
                OpenFor = a.MenuOpenFor ?? "",
                SubMenus = menusTemp.Where(b => b.MenuId == a.MenuId).OrderBy(a => a.SubMenuOrdinalNumber)
                    .Select(b => new SubMenuVM
                    {
                        SubMenuId = b.SubMenuId,
                        Title = b.SubMenuTitle,
                        Icon = b.SubMenuIcon,
                        Area = b.SubMenuArea,
                        Controller = b.SubMenuController,
                        Action = b.SubMenuAction,
                        OpenFor = b.SubMenuOpenFor
                    }).Distinct().ToList()
            }).ToList();

        return View(menus);
    }
}
