using AMS.Areas.Identity.Pages.Account.Manage;
using AMS.Data.Core;
using AMS.Data.General;
using Microsoft.AspNetCore.Identity;

namespace AMS.Areas.Identity.Pages.Account;
public class AccessDeniedModel : BaseIModel
{
    public AccessDeniedModel(SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager, AMSContext db)
        : base(signInManager, userManager, db)
    {
    }

    public void OnGet()
    {

    }
}


