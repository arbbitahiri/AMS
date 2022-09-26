using AMS.Areas.Authorization.Models.Menu;
using AMS.Controllers;
using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models.Shared;
using AMS.Resources;
using AMS.Utilities;
using AMS.Utilities.General;
using AMS.Utilities.Security;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AMS.Areas.Authorization.Controllers;

[Route("/{area}/{controller}/{action}")]
public class MenuController : BaseController
{
    public MenuController(AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
    }

    #region Search

    [Authorize(Policy = "52:m"), Description("Arb Tahiri", "Form to display list of menus and submenus.")]
    public IActionResult Index() => View();

    [Authorize(Policy = "52:r"), Description("Arb Tahiri", "Form to display list of menus.")]
    public async Task<IActionResult> Search()
    {
        var menus = await db.Menu.Select(a => new MenuVM
        {
            MenuIde = CryptoSecurity.Encrypt(a.MenuId),
            Title = user.Language == LanguageEnum.Albanian ? a.NameSq : a.NameEn,
            Controller = a.Controller,
            Action = a.Action,
            HasSubMenu = a.HasSubMenu,
            Icon = a.Icon
        }).ToListAsync();
        return PartialView(menus);
    }

    #endregion

    #region Create

    [HttpGet, Authorize(Policy = "52:c"), Description("Arb Tahiri", "Form to create a new menu.")]
    public IActionResult _Create() => PartialView();

    [HttpPost, Authorize(Policy = "52:c"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to create a new menu.")]
    public async Task<IActionResult> Create(Create create)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Title = Resource.Warning, Description = Resource.InvalidData });
        }

        db.Menu.Add(new Menu
        {
            NameSq = create.NameSq,
            NameEn = create.NameEn,
            HasSubMenu = create.HasSubMenu,
            Active = true,
            Icon = create.Icon,
            Claim = create.ClaimPolicy,
            ClaimType = create.ClaimPolicy?.Split(":")[0],
            Controller = create.Controller,
            Action = create.Action,
            OrdinalNumber = create.OrdinalNumber,
            OpenFor = create.OpenFor,
            TagsSq = create.TagsSQ,
            TagsEn = create.TagsEN,
            InsertedFrom = user.Id,
            InsertedDate = DateTime.Now
        });
        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Title = Resource.Success, Description = Resource.DataRegisteredSuccessfully });
    }

    #endregion

    #region Edit

    [HttpGet, Authorize(Policy = "52:e"), Description("Arb Tahiri", "Form to edit a new menu.")]
    public async Task<IActionResult> _Edit(string ide)
    {
        var menuId = CryptoSecurity.Decrypt<int>(ide);
        var menu = await db.Menu.FindAsync(menuId);
        var edit = new Edit
        {
            MenuIde = ide,
            NameSq = menu.NameSq,
            NameEn = menu.NameEn,
            HasSubMenu = menu.HasSubMenu,
            Active = menu.Active,
            Icon = menu.Icon,
            ClaimPolicy = menu.Claim,
            Controller = menu.Controller,
            Action = menu.Action,
            OrdinalNumber = menu.OrdinalNumber,
            OpenFor = menu.OpenFor
        };
        return PartialView(edit);
    }

    [HttpPost, Authorize(Policy = "52:e"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to edit a new menu.")]
    public async Task<IActionResult> Edit(Edit edit)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Title = Resource.Warning, Description = Resource.InvalidData });
        }

        var menuId = CryptoSecurity.Decrypt<int>(edit.MenuIde);
        var menu = await db.Menu.FindAsync(menuId);
        menu.NameSq = edit.NameSq;
        menu.NameEn = edit.NameEn;
        menu.HasSubMenu = edit.HasSubMenu;
        menu.Active = edit.Active;
        menu.Icon = edit.Icon;
        menu.Claim = edit.ClaimPolicy;
        menu.ClaimType = edit.ClaimPolicy?.Split(":")[0];
        menu.Controller = edit.Controller;
        menu.Action = edit.Action;
        menu.OrdinalNumber = edit.OrdinalNumber;
        menu.OpenFor = edit.OpenFor;
        menu.TagsSq = edit.TagsSQ;
        menu.TagsEn = edit.TagsEN;
        menu.UpdatedFrom = user.Id;
        menu.UpdatedDate = DateTime.Now;
        menu.UpdatedNo = UpdateNo(menu.UpdatedNo);

        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Title = Resource.Success, Description = Resource.DataUpdatedSuccessfully });
    }

    #endregion

    #region Delete

    [HttpPost, Authorize(Policy = "52:d"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Form to edit a new menu.")]
    public async Task<IActionResult> Delete(string ide)
    {
        var menuId = CryptoSecurity.Decrypt<int>(ide);
        var menu = await db.Menu.FindAsync(menuId);
        menu.Active = false;
        menu.UpdatedFrom = user.Id;
        menu.UpdatedDate = DateTime.Now;
        menu.UpdatedNo = UpdateNo(menu.UpdatedNo);

        await db.SaveChangesAsync();

        return Json(new ErrorVM { Status = ErrorStatus.Success, Title = Resource.Success, Description = Resource.DataDeletedSuccessfully });
    }

    #endregion
}
