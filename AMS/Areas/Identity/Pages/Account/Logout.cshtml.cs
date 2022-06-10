using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models.Shared;
using AMS.Utilities.General;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace AMS.Areas.Identity.Pages.Account;
[Authorize]
public class LogoutModel : BaseOModel
{
    private readonly SignInManager<ApplicationUser> _signInManager;

    public LogoutModel(SignInManager<ApplicationUser> signInManager, AMSContext db)
        : base(db)
    {
        _signInManager = signInManager;
    }

    public void OnGet()
    {
    }

    public async Task<IActionResult> OnPost(string returnUrl = null)
    {
        await _signInManager.SignOutAsync();
        TempData.Set("ErrorI", new ErrorVM { Status = Utilities.ErrorStatus.Success, Description = "You are logged out." });
        return RedirectToPage("Login");
    }
}
