using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models.Shared;
using AMS.Utilities;
using AMS.Utilities.Security;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AMS.ViewComponents;

public class ProfileViewComponent : ViewComponent
{
    private readonly AMSContext db;

    public ProfileViewComponent(AMSContext db)
    {
        this.db = db;
    }

    public async Task<IViewComponentResult> InvokeAsync()
    {
        var user = (ApplicationUser)ViewData["InternalUser"];
        var sideProfile = await db.AspNetUsers
            .Where(a => a.Id == user.Id)
            .Select(a => new SideProfile
            {
                Name = $"{a.FirstName} {a.LastName}",
                ProfileImage = a.ProfileImage ?? null,
                Username = a.UserName,
                Email = a.Email,
                Mode = (TemplateMode)a.AppMode,
                Roles = a.RealRoleUser.Select(a => new ProfileRoles
                {
                    RoleIde = CryptoSecurity.Encrypt(a.RoleId),
                    Name = a.Role.Name,
                    Title = user.Language == LanguageEnum.Albanian ? a.Role.NameSq : a.Role.NameEn
                }).ToList()
            }).FirstOrDefaultAsync();

        return View(sideProfile);
    }
}
