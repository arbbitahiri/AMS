using AMS.Areas.Administration.Models.Roles;
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

namespace AMS.Areas.Administration.Controllers;

[Route("/{area}/{controller}/{action}")]
public class RolesController : BaseController
{
    private readonly RoleManager<ApplicationRole> roleManager;
    public RolesController(RoleManager<ApplicationRole> roleManager,
        AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
        this.roleManager = roleManager;
    }

    [HttpGet, Authorize(Policy = "32:m"), Description("Arb Tahiri", "Entry home to display users.")]
    public async Task<IActionResult> Index()
    {
        var roles = await roleManager.Roles
            .Select(a => new RoleVM
            {
                RoleIde = CryptoSecurity.Encrypt(a.Id),
                NormalizedName = a.NormalizedName,
                NameSQ = a.NameSQ,
                NameEN = a.NameEN,
                Description = a.Description,
            }).ToListAsync();

        return View(roles.OrderBy(a => a.NormalizedName));
    }

    #region Create

    [Authorize(Policy = "32:c"), Description("Arb Tahiri", "Form to create a role.")]
    public IActionResult Create() => PartialView();

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "32:c")]
    [Description("Arb Tahiri", "Action to create a role.")]
    public async Task<IActionResult> Create(Create create)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
        }

        if (await roleManager.Roles.AnyAsync(a => a.NameSQ == create.NameSQ || a.NameEN == create.NameEN))
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.RoleExists });
        }

        await roleManager.CreateAsync(new ApplicationRole
        {
            Name = create.NameEN,
            NameSQ = create.NameSQ,
            NameEN = create.NameEN,
            Description = create.Description,
        });

        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = Resource.DataRegisteredSuccessfully });
    }

    #endregion

    #region Edit

    [Authorize(Policy = "32:e"), Description("Arb Tahiri", "Form to edit a role.")]
    public async Task<IActionResult> Edit(string rIde)
    {
        var roleId = CryptoSecurity.Decrypt<string>(rIde);
        var role = await roleManager.Roles
            .Where(a => a.Id == roleId)
            .Select(a => new Create
            {
                RoleIde = rIde,
                NameSQ = a.NameSQ,
                NameEN = a.NameEN,
                Description = a.Description,
            }).FirstOrDefaultAsync();
        return PartialView(role);
    }

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "32:e")]
    [Description("Arb Tahiri", "Action to edit a role.")]
    public async Task<IActionResult> Edit(Create edit)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
        }

        if (await roleManager.Roles.CountAsync(a => a.NameSQ == edit.NameSQ || a.NameEN == edit.NameEN) > 1)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.RoleExists });
        }

        var role = await roleManager.Roles.FirstOrDefaultAsync(a => a.Id == CryptoSecurity.Decrypt<string>(edit.RoleIde));
        role.NormalizedName = edit.NameEN.ToUpper();
        role.NameSQ = edit.NameSQ;
        role.NameEN = edit.NameEN;
        role.Description = edit.Description;
        await roleManager.UpdateAsync(role);

        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = Resource.DataUpdatedSuccessfully });
    }

    #endregion

    #region Delete

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "32:d")]
    [Description("Arb Tahiri", "Action to delete a role.")]
    public async Task<IActionResult> Delete(string rIde)
    {
        var roleId = CryptoSecurity.Decrypt<string>(rIde);
        await roleManager.DeleteAsync(await roleManager.Roles.FirstOrDefaultAsync(a => a.Id == roleId));

        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = Resource.DataDeletedSuccessfully });
    }

    #endregion
}
