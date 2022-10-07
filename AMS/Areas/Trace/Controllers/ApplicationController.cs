using AMS.Areas.Trace.Models.Application;
using AMS.Controllers;
using AMS.Data.Core;
using AMS.Data.General;
using AMS.Repositories;
using AMS.Resources;
using AMS.Utilities;
using AMS.Utilities.General;
using AMS.Utilities.RDLC;
using AMS.Utilities.Security;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Reporting.NETCore;
using Newtonsoft.Json;
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
    public async Task<IActionResult> Search(Search search)
    {
        string[] dates = search.Date.Split(" - ");
        DateTime startDate = DateTime.ParseExact(dates[0], "dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture, DateTimeStyles.None);
        DateTime endDate = DateTime.ParseExact(dates[1], "dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture);

        var list = (await function.Logs(search.Role, search.User, startDate, endDate, search.Ip, search.Controller, search.Action, search.HttpMethod, search.Error, search.AdvancedSearch))
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

    #region Details

    [HttpGet, Description("Arb Tahiri", "Form to view log details.")]
    public async Task<IActionResult> Details(string ide)
    {
        var logId = CryptoSecurity.Decrypt<int>(ide);
        var logs = await db.Log
            .Where(a => a.LogId == logId)
            .Select(a => new Details
            {
                Ip = a.Ip ?? "///",
                Url = a.Url ?? "///",
                InsertedDate = a.InsertedDate.ToString("dd/MM/yyyy H:mm:ss"),
                Controller = a.Controller,
                Action = a.Action,
                Title = a.Description ?? "///",
                HttpMethod = a.HttpMethod,
                Username = a.User != null ? $"{a.User.FirstName} {a.User.LastName}" : "///",
                Error = a.Error ? Resource.Yes : Resource.No,
                Exception = a.Exception,
                FormContent = a.FormContent
            }).FirstOrDefaultAsync();
        return PartialView(logs);
    }

    #endregion

    #region Report

    [HttpPost, ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to generate report for given search result.")]
    public async Task<IActionResult> Report(Search search, ReportType type)
    {
        string[] dates = search.Date.Split(" - ");
        DateTime startDate = DateTime.ParseExact(dates[0], "dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture, DateTimeStyles.None);
        DateTime endDate = DateTime.ParseExact(dates[1], "dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture);

        var list = (await function.Logs(search.Role, search.User, startDate, endDate, search.Ip, search.Controller, search.Action, search.HttpMethod, search.Error, search.AdvancedSearch))
            .Select(a => new LogVM
            {
                Ip = a.Ip,
                Controller = a.Controller,
                Action = a.Action,
                FormContent = !string.IsNullOrEmpty(a.FormContent) ? JsonConvert.SerializeObject(JsonConvert.DeserializeObject<FormContent[]>(a.FormContent).Where(a => a.Key != "__RequestVerificationToken").ToArray()) : "///",
                HttpMethod = a.HttpMethod,
                Username = a.Username,
                InsertedDate = a.InsertDate.ToString("dd/MM/yyyy")
            }).ToList();

        var dataSource = new List<ReportDataSource>() { new ReportDataSource("Logs", list) };
        var parameters = new List<ReportParameter>()
        {
            new ReportParameter("PrintedFrom", $"{user.FirstName} {user.LastName}"),
            new ReportParameter("IP", Resource.IPAddress),
            new ReportParameter("Controller", Resource.Controller),
            new ReportParameter("Action", Resource.Action),
            new ReportParameter("Description", Resource.Description),
            new ReportParameter("Username", Resource.Username),
            new ReportParameter("Exception", Resource.Exception),
            new ReportParameter("FormContent", Resource.FormContent),
            new ReportParameter("HttpMethod", Resource.HttpMethod),
            new ReportParameter("InsertDate", Resource.InsertedDate),
            new ReportParameter("Role", Resource.Role),
            new ReportParameter("User", Resource.User),
            new ReportParameter("Date", Resource.Date),
            new ReportParameter("Error", Resource.IsError),
            new ReportParameter("SearchRole", await db.AspNetRoles.Where(a => a.Id == search.Role).Select(a => user.Language == LanguageEnum.Albanian ? a.NameSq : a.NameEn).FirstOrDefaultAsync()),
            new ReportParameter("SearchUser", await db.AspNetUsers.Where(a => a.Id == search.User).Select(a => $"{a.FirstName} {a.LastName}").FirstOrDefaultAsync()),
            new ReportParameter("SearchDate", $"{startDate:dd/MM/yyyy HH:mm:ss} - {endDate:dd/MM/yyyy HH:mm:ss}"),
            new ReportParameter("SearchIP", search.Ip),
            new ReportParameter("SearchController", search.Controller),
            new ReportParameter("SearchAction", search.Action),
            new ReportParameter("SearchHttpMethod", search.HttpMethod),
            new ReportParameter("SearchError", search.Error.HasValue ? (search.Error == 1 ? Resource.Yes : Resource.No) : "///"),
            new ReportParameter("ListOfLogs", Resource.ListOfLogs),
            new ReportParameter("AMS", Resource.AMSTitle)
        };

        var reportByte = RDLCReport.GenerateReport("Logs.rdl", dataSource, parameters, type, ReportOrientation.Landscape);
        string contentType = type switch
        {
            ReportType.PDF => "application/pdf",
            ReportType.Excel => "application/ms-excel",
            ReportType.Word => "application/msword",
            _ => "application/pdf"
        };
        string fileName = type switch
        {
            ReportType.PDF => Resource.ListOfLogs,
            ReportType.Excel => $"{Resource.ListOfLogs}.xlsx",
            ReportType.Word => $"{Resource.ListOfLogs}.docx",
            _ => Resource.StaffList
        };
        return type == ReportType.PDF ?
            File(reportByte, contentType) :
            File(reportByte, contentType, fileName);
    }

    #endregion
}
