using AMS.Data.General;
using AMS.Models.Shared;
using AMS.Utilities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AMS.Areas.Identity.Pages.Account;
[AllowAnonymous]
public class MessageModel : BaseOModel
{
    public MessageModel(AMSContext db) : base(db)
    {

    }

    [BindProperty]
    public ErrorVM Error { get; set; }

    public void OnGet(ErrorStatus status, string description)
    {
        Error = new ErrorVM { Status = status, Description = description };
    }

    public IActionResult OnPostFilter()
    {
        return Page();
    }
}
