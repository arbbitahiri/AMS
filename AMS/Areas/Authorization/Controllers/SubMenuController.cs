using AMS.Areas.Authorization.Models.SubMenu;
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
public class SubMenuController : BaseController
{
    public SubMenuController(AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
    }

    #region List

    [Authorize(Policy = "53:r"), Description("Arb Tahiri", "Form to dipslay list of submenus.")]
    public async Task<IActionResult> Index()
    {
        var subMenus = await db.SubMenu
            .Select(a => new SubMenuVM
            {
                SubMenuIde = CryptoSecurity.Encrypt(a.SubMenuId),
                Title = user.Language == LanguageEnum.Albanian ? a.NameSq : a.NameEn,
                MenuTitle = user.Language == LanguageEnum.Albanian ? a.Menu.NameSq : a.Menu.NameEn,
                Controller = a.Controller,
                Action = a.Action,
                Icon = a.Icon
            }).ToListAsync();
        return PartialView(subMenus);
    }

    [Authorize(Policy = "53:r"), Description("Arb Tahiri", "Form to dipslay list of submenus for a menu.")]
    public async Task<IActionResult> SubMenu(string mIde)
    {
        var menuId = CryptoSecurity.Decrypt<int>(mIde);
        var subMenus = await db.SubMenu
            .Where(a => a.MenuId == menuId)
            .Select(a => new SubMenuVM
            {
                MenuIde = mIde,
                SubMenuIde = CryptoSecurity.Encrypt(a.SubMenuId),
                Title = user.Language == LanguageEnum.Albanian ? a.NameSq : a.NameEn,
                MenuTitle = user.Language == LanguageEnum.Albanian ? a.Menu.NameSq : a.Menu.NameEn,
                Controller = a.Controller,
                Action = a.Action,
                Icon = a.Icon
            }).ToListAsync();
        return PartialView(subMenus);
    }

    #endregion

    #region Create

    [HttpGet, Authorize(Policy = "53:c"), Description("Arb Tahiri", "Form to create a new submenu.")]
    public async Task<IActionResult> _Create(string ide)
    {
        var menuId = CryptoSecurity.Decrypt<int>(ide);
        var menu = await db.Menu.FindAsync(menuId);
        var create = new Create
        {
            MenuIde = ide,
            MenuTitle = user.Language == LanguageEnum.Albanian ? menu.NameSq : menu.NameEn,
            HasSubMenu = menu.HasSubMenu
        };
        return PartialView(create);
    }

    [HttpPost, Authorize(Policy = "53:c"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to create a new submenu.")]
    public async Task<IActionResult> Create(Create create)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Title = Resource.Warning, Description = Resource.InvalidData });
        }

        var menuId = CryptoSecurity.Decrypt<int>(create.MenuIde);
        db.SubMenu.Add(new SubMenu
        {
            MenuId = menuId,
            NameSq = create.NameSq,
            NameEn = create.NameEn,
            Active = true,
            Icon = create.Icon,
            Claim = create.ClaimPolicy,
            ClaimType = create.ClaimPolicy?.Split(":")[0],
            Area = create.Area,
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

    [HttpGet, Authorize(Policy = "53:e")]
    [Description("Arb Tahiri", "Form to edit a new submenu.")]
    public async Task<IActionResult> _Edit(string sIde, string mIde)
    {
        var subMenuId = CryptoSecurity.Decrypt<int>(sIde);
        var subMenu = await db.SubMenu.FindAsync(subMenuId);
        var edit = new Edit
        {
            SubMenuIde = sIde,
            MenuIde = mIde,
            NameSq = subMenu.NameSq,
            NameEn = subMenu.NameEn,
            Active = subMenu.Active,
            Icon = subMenu.Icon,
            ClaimPolicy = subMenu.Claim,
            Area = subMenu.Area,
            Controller = subMenu.Controller,
            Action = subMenu.Action,
            OrdinalNumber = subMenu.OrdinalNumber,
            OpenFor = subMenu.OpenFor,
            TagsSQ = subMenu.TagsSq,
            TagsEN = subMenu.TagsEn
        };
        return PartialView(edit);
    }

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "53:e")]
    [Description("Arb Tahiri", "Action to edit a new submenu.")]
    public async Task<IActionResult> Edit(Edit edit)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Title = Resource.Warning, Description = Resource.InvalidData });
        }

        var subMenuId = CryptoSecurity.Decrypt<int>(edit.SubMenuIde);
        var subMenu = await db.SubMenu.FindAsync(subMenuId);
        subMenu.NameSq = edit.NameSq;
        subMenu.NameEn = edit.NameEn;
        subMenu.Active = edit.Active;
        subMenu.Icon = edit.Icon;
        subMenu.Claim = edit.ClaimPolicy;
        subMenu.ClaimType = edit.ClaimPolicy?.Split(":")[0];
        subMenu.Area = edit.Area;
        subMenu.Controller = edit.Controller;
        subMenu.Action = edit.Action;
        subMenu.OrdinalNumber = edit.OrdinalNumber;
        subMenu.OpenFor = edit.OpenFor;
        subMenu.TagsSq = edit.TagsSQ;
        subMenu.TagsEn = edit.TagsEN;
        subMenu.UpdatedFrom = user.Id;
        subMenu.UpdatedDate = DateTime.Now;
        subMenu.UpdatedNo = UpdateNo(subMenu.UpdatedNo);

        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Title = Resource.Success, Description = Resource.DataUpdatedSuccessfully });
    }

    #endregion

    #region Delete

    [HttpPost, Authorize(Policy = "53:d"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Form to edit a new submenu.")]
    public async Task<IActionResult> Delete(string sIde)
    {
        var subMenuId = CryptoSecurity.Decrypt<int>(sIde);
        var subMenu = await db.SubMenu.FindAsync(subMenuId);
        subMenu.Active = false;
        subMenu.UpdatedFrom = user.Id;
        subMenu.UpdatedDate = DateTime.Now;
        subMenu.UpdatedNo = UpdateNo(subMenu.UpdatedNo);

        await db.SaveChangesAsync();

        return Json(new ErrorVM { Status = ErrorStatus.Success, Title = Resource.Success, Description = Resource.DataDeletedSuccessfully });
    }

    #endregion
}
