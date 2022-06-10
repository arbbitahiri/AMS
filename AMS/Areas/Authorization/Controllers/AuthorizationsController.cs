using AMS.Areas.Authorization.Models.Authorizations;
using AMS.Controllers;
using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models.Shared;
using AMS.Repositories;
using AMS.Resources;
using AMS.Utilities;
using AMS.Utilities.EqualityComparers;
using AMS.Utilities.General;
using AMS.Utilities.Security;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Reflection;
using System.Security.Claims;

namespace AMS.Areas.Authorization.Controllers;

public class AuthorizationsController : BaseController
{
    private readonly RoleManager<ApplicationRole> roleManager;
    private readonly IFunctionRepository function;

    public AuthorizationsController(RoleManager<ApplicationRole> roleManager, IFunctionRepository function,
        AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
        this.roleManager = roleManager;
        this.function = function;
    }

    #region Search

    [Authorize(Policy = "51:m"), Description("Arb Tahiri", "Authorization configuration.")]
    public IActionResult Index() => View();

    [HttpPost, Authorize(Policy = "51:c"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Form to search through authorizations.")]
    public async Task<IActionResult> Search(Search search)
    {
        var authorizations = (await function.MenuListAccess(search.Role, user.Language))
            .Select(a => new AuthorizationList
            {
                MenuIde = CryptoSecurity.Encrypt(a.MenuId),
                SubMenuIde = a.SubMenuId != 0 ? CryptoSecurity.Encrypt(a.SubMenuId) : string.Empty,
                MenuTitle = a.Menu,
                SubMenuTitle = a.SubMenu,
                Icon = a.Icon,
                HasSubMenu = a.HasSubMenu,
                HasAccess = a.HasAccess,
                ClaimPolicy = a.ClaimPolicy
            }).ToList();
        return PartialView(authorizations);
    }

    #endregion

    #region Change access

    [HttpPost, Authorize(Policy = "51:c"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Form to search through authorizations.")]
    public async Task<IActionResult> ChangeAccess(ChangeAccess change)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Title = Resource.Warning, Description = Resource.InvalidData });
        }

        Menu menu = null; SubMenu subMenu = null;
        string claimType = string.Empty, claimValue = string.Empty;
        var getRole = await roleManager.FindByIdAsync(change.Role);

        if (!string.IsNullOrEmpty(change.SubMenuIde))
        {
            subMenu = await db.SubMenu.FindAsync(CryptoSecurity.Decrypt<int>(change.SubMenuIde));
            claimType = subMenu.Claim.Split(":")[0];
            claimValue = subMenu.Claim.Split(":")[1];
        }
        else
        {
            menu = await db.Menu.FindAsync(CryptoSecurity.Decrypt<int>(change.MenuIde));
            claimType = menu.Claim.Split(":")[0];
            claimValue = menu.Claim.Split(":")[1];
        }

        if (change.Access && !await db.AspNetRoleClaims.AnyAsync(a => a.ClaimType == claimType && a.ClaimValue == claimValue && a.RoleId == change.Role))
        {
            await roleManager.AddClaimAsync(getRole, new Claim(claimType, claimValue));
            if (!string.IsNullOrEmpty(change.SubMenuIde))
            {
                subMenu.Roles += getRole.Name + ", ";
            }
            else
            {
                menu.Roles += getRole.Name + ", ";
            }
        }
        else
        {
            await roleManager.RemoveClaimAsync(getRole, new Claim(claimType, claimValue));
            if (!string.IsNullOrEmpty(change.SubMenuIde))
            {
                subMenu.Roles = subMenu.Roles.Replace(getRole.Name, string.Empty);
            }
            else
            {
                menu.Roles = menu.Roles.Replace(getRole.Name, string.Empty);
            }
        }

        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Title = Resource.Success, Description = Resource.AccessChangedSuccessfully });
    }

    #endregion

    #region Application rules

    [Description("Arb Tahiri", "Entry form in application rules")]
    public async Task<IActionResult> Rules(string role)
    {
        var rules = new List<Rule>();
        Assembly.GetEntryAssembly().GetTypes().AsEnumerable()
            .Where(type => typeof(Controller).IsAssignableFrom(type)).ToList()
            .ForEach(a =>
            {
                a.GetMethods().Where(m => m.CustomAttributes.Any()).ToList()
                .ForEach(method =>
                {
                    var rule = new Rule
                    {
                        Controller = a.Name,
                        Method = method.Name
                    };

                    method.CustomAttributes.Where(b => b.AttributeType.Name == "AuthorizeAttribute" || b.AttributeType.Name == "DescriptionAttribute").ToList()
                    .ForEach(attr =>
                    {
                        if (attr.AttributeType.Name == "AuthorizeAttribute")
                        {
                            rule.Policy = attr.NamedArguments.Select(c => c.TypedValue.Value.ToString()).FirstOrDefault();
                        }
                        else if (attr.AttributeType.Name == "DescriptionAttribute")
                        {
                            rule.Developer = attr.ConstructorArguments[0].ToString();
                            rule.Description = attr.ConstructorArguments[1].ToString();
                        }
                    });

                    if (!string.IsNullOrEmpty(rule.Policy))
                    {
                        rules.Add(rule);
                    }
                });
            });

        rules = rules.Where(a => a.Policy.Split(":").Length > 1).Distinct(new PolicyComparer()).ToList();

        var menuPolicies = await db.Menu.Where(a => !string.IsNullOrEmpty(a.Claim)).Select(a => a.Claim).ToListAsync();
        var submenuPolicies = await db.SubMenu.Where(a => !string.IsNullOrEmpty(a.Claim)).Select(a => a.Claim).ToListAsync();
        var roleClaims = await db.AspNetRoleClaims.Where(a => a.RoleId == role).Select(a => new RoleClaim { ClaimType = a.ClaimType, ClaimValue = a.ClaimValue }).ToListAsync();

        roleClaims = roleClaims.Where(a => !(menuPolicies.Any(b => b.Split(":")[0] == a.ClaimType) && menuPolicies.Any(b => b.Split(":")[1] == a.ClaimValue))).ToList();
        roleClaims = roleClaims.Where(a => !(submenuPolicies.Any(b => b.Split(":")[0] == a.ClaimType) && submenuPolicies.Any(b => b.Split(":")[1] == a.ClaimValue))).ToList();

        rules = rules.Where(a => a.Policy.Split(":")[1] != "m").ToList();

        rules.ForEach(rule => rule.HasAccess = roleClaims.Any(a => a.ClaimType == rule.Policy.Split(":")[0] && a.ClaimValue == rule.Policy.Split(":")[1]));
        return PartialView(rules);
    }

    [HttpPost, Authorize(Policy = "12:c"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to change access for methods with policies")]
    public async Task<IActionResult> ChangeMethodAccess(Claims claim)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Title = Resource.Warning, Description = Resource.InvalidData });
        }

        string claimType = claim.Policy.Split(":")[0], claimValue = claim.Policy.Split(":")[1];

        if (claim.Access && !await db.AspNetRoleClaims.AnyAsync(a => a.ClaimType == claimType && a.ClaimValue == claimValue && a.RoleId == claim.Role))
        {
            await roleManager.AddClaimAsync(await roleManager.FindByIdAsync(claim.Role), new Claim(claimType, claimValue));
        }
        else
        {
            await roleManager.RemoveClaimAsync(await roleManager.FindByIdAsync(claim.Role), new Claim(claimType, claimValue));
        }
        return Json(new ErrorVM { Status = ErrorStatus.Success, Title = Resource.Success, Description = Resource.AccessChangedSuccessfully });
    }

    #endregion
}
