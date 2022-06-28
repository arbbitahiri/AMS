using AMS.Areas.Trace.Models.Application;
using AMS.Controllers;
using AMS.Data.Core;
using AMS.Data.General;
using AMS.Repositories;
using AMS.Utilities.General;
using AMS.Utilities.Security;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.Globalization;

namespace AMS.Areas.Trace.Controllers;

[Route("/{area}/{controller}/{action}")]
public class ApplicationController : BaseController
{
    private readonly IFunctionRepository function;

    public ApplicationController(IFunctionRepository function,
        AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
        this.function = function;
    }

    #region Search

    [Authorize(Policy = "61:m"), Description("Arb Tahiri", "Entry form to search for application logs.")]
    public IActionResult Index() => View();

    [HttpPost, Authorize(Policy = "61:r"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to search for logs.")]
    public async Task<IActionResult> SearchLogs(Search search)
    {
        string[] dates = search.Date.Split(" - ");
        DateTime startDate = DateTime.ParseExact(dates[0], "dd/MM/yyyy H:mm", CultureInfo.InvariantCulture, DateTimeStyles.None);
        DateTime endDate = DateTime.ParseExact(dates[1], "dd/MM/yyyy H:mm", CultureInfo.InvariantCulture);

        var list = (await function.Logs(search.Role, search.User, startDate, endDate, search.Ip, search.Controller, search.Action, search.HttpMethod, search.Error))
            .Select(a => new LogVM
            {
                LogIde = CryptoSecurity.Encrypt(a.LogId),
                Ip = a.Ip,
                Controller = a.Controller,
                Action = a.Action,
                Description = a.Description,
                Exception = a.Exception,
                FormContent = a.FormContent,
                HttpMethod = a.HttpMethod,
                Username = a.Username,
                InsertDate = a.InsertDate
            }).ToList();
        return Json(list.OrderByDescending(a => a.InsertDate));
    }

    #endregion

    #region Report

    #endregion
}
