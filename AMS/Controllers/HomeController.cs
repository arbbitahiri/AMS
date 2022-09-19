using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models.Home;
using AMS.Repositories;
using AMS.Resources;
using AMS.Utilities;
using AMS.Utilities.General;
using AMS.Utilities.Security;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AMS.Controllers;

[Authorize]
public class HomeController : BaseController
{
    private readonly IFunctionRepository function;

    public HomeController(IFunctionRepository function,
        AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
        this.function = function;
    }

    [Description("Arb Tahiri", "Entry home.")]
    public IActionResult Index()
    {
        ViewData["Title"] = Resource.HomePage;

        var getRole = User.Claims.FirstOrDefault(a => a.Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/role");
        return getRole.Value switch
        {
            "Administrator" => RedirectToAction(nameof(Administrator)),
            "IT" => RedirectToAction(nameof(Developer)),
            _ => View()
        };
    }

    #region Dashboard

    [HttpGet, Description("Arb Tahiri", "Home page for administrator.")]
    public async Task<IActionResult> Administrator()
    {
        ViewData["Title"] = Resource.HomePage;

        int? staffId = await db.Staff.Where(a => a.UserId == user.Id).Select(a => a.StaffId).FirstOrDefaultAsync();
        var administrator = new AdministratorVM
        {
            StaffCount = await db.Staff.CountAsync(a => a.StaffDepartment.Any(a => a.EndDate.Date >= DateTime.Now.Date)),
            DocumentsCount = await db.StaffDocument.CountAsync(),
            AttendanceCount = await db.StaffAttendance.CountAsync(a => a.InsertedDate.Date == DateTime.Now.Date),
            WorkingSince = (await function.AttendanceConsecutiveDays(staffId, null, null, null, null, user.Language)).Select(a => a.WorkingSince).FirstOrDefault(),
            WeekAttandance = (await function.AttendanceConsecutiveDays(null, null, null, DateTime.Now.AddDays(-7), DateTime.Now, user.Language))
                .GroupBy(a => a.EndDate.Date)
                .Select(a => new AttendanceVM
                {
                    Count = a.Count(),
                    Date = a.Key.ToString("dd/MM/yyyy")
                }).ToList(),
            Logs = await db.Log
                .OrderByDescending(a => a.InsertedDate)
                .Take(25)
                .Select(a => new LogVM
                {
                    Action = a.Action,
                    Description = a.Description,
                    InsertedDate = a.InsertedDate
                }).ToListAsync()
        };
        return View(administrator);
    }

    [HttpGet, Description("Arb Tahiri", "Home page for developer.")]
    public async Task<IActionResult> Developer()
    {
        ViewData["Title"] = Resource.HomePage;

        int? staffId = await db.Staff.Where(a => a.UserId == user.Id).Select(a => a.StaffId).FirstOrDefaultAsync();
        var developer = new DeveloperVM
        {
            UsersCount = await db.AspNetUser.CountAsync(),
            LogsCount = await db.Log.CountAsync(a => a.InsertedDate.Date == DateTime.Now.Date),
            WorkingSince = (await function.AttendanceConsecutiveDays(staffId, null, null, null, null, user.Language)).Select(a => a.WorkingSince).FirstOrDefault(),
            UserRoles = await db.AspNetRoles
                .Select(a => new UserRolesVM
                {
                    Count = a.User.Count,
                    Role = user.Language == LanguageEnum.Albanian ? a.NameSq : a.NameEn
                }).ToListAsync(),
            Logs = await db.Log
                .OrderByDescending(a => a.InsertedDate)
                .Take(25)
                .Select(a => new LogVM
                {
                    Action = a.Action,
                    Description = a.Description,
                    InsertedDate = a.InsertedDate
                }).ToListAsync()
        };
        return View(developer);
    }

    #endregion

    #region Notifications

    [HttpPost, Description("Arb Tahiri", "Action to mark as read a notification.")]
    public async Task<IActionResult> MarkAsReadNotification(string ide)
    {
        int id = CryptoSecurity.Decrypt<int>(ide);
        var notification = await db.Notification.FirstOrDefaultAsync(a => a.NotificationId == id);
        notification.Read = !notification.Read;
        await db.SaveChangesAsync();
        return Json(true);
    }

    [HttpPost, Description("Arb Tahiri", "Action to delete a notification.")]
    public async Task<IActionResult> DeleteNotification(string ide)
    {
        int id = CryptoSecurity.Decrypt<int>(ide);
        var notification = await db.Notification.FirstOrDefaultAsync(a => a.NotificationId == id);
        notification.Deleted = true;
        await db.SaveChangesAsync();
        return Json(true);
    }

    [HttpPost, Description("Arb Tahiri", "Action to mark as read all notifications.")]
    public async Task<IActionResult> MarkAsReadAllNotification()
    {
        await db.Notification.Where(a => a.Receiver == user.Id && !a.Read).ForEachAsync(a => a.Read = true);
        await db.SaveChangesAsync();
        return Json(true);
    }

    [HttpPost, Description("Arb Tahiri", "Action to delete all notifications.")]
    public async Task<IActionResult> DeleteAllNotification()
    {
        await db.Notification.Where(a => a.Receiver == user.Id && !a.Deleted).ForEachAsync(a => a.Deleted = true);
        await db.SaveChangesAsync();
        return Json(true);
    }

    #endregion
}