using AMS.Data.General;
using Microsoft.AspNetCore.Authorization;

namespace AMS.Areas.Identity.Pages.Account;

[AllowAnonymous]
public class LockoutModel : BaseOModel
{
    public LockoutModel(AMSContext db) : base(db)
    {

    }

    public void OnGet()
    {

    }
}
