﻿using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models;
using AMS.Models.Notification;
using AMS.Models.Shared;
using AMS.Resources;
using AMS.Utilities;
using AMS.Utilities.General;
using AMS.Utilities.NotificationUtil;
using AMS.Utilities.Security;
using ImageMagick;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.Extensions;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Localization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Controllers;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System.Diagnostics;
using System.Drawing;
using System.Globalization;
using System.Net;
using System.Net.Mail;
using System.Reflection;
using System.Runtime.Versioning;

namespace AMS.Controllers;

[Authorize]
public class BaseController : Controller
{
    protected readonly SignInManager<ApplicationUser> signInManager;
    protected readonly UserManager<ApplicationUser> userManager;
    protected AMSContext db;
    protected ApplicationUser user;

    public BaseController(AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
    {
        this.db = db;
        this.signInManager = signInManager;
        this.userManager = userManager;
    }

    public override async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
    {
        user = await userManager.GetUserAsync(context.HttpContext.User);
        await signInManager.RefreshSignInAsync(user);

        ViewData["InternalUser"] = user;
        ViewData["User"] = new UserModel
        {
            Id = user.Id,
            Email = user.Email,
            Username = user.UserName,
            PhoneNumber = user.PhoneNumber,
            FirstName = user.FirstName,
            LastName = user.LastName,
            ImageProfile = user.ProfileImage,
            Mode = user.AppMode,
            Language = user.Language,
            Notification = user.AllowNotification,
            PersonalNumber = user.PersonalNumber,
        };

        var con = context.ActionDescriptor as ControllerActionDescriptor;
        DescriptionAttribute description = ((DescriptionAttribute[])con.MethodInfo.GetCustomAttributes(typeof(DescriptionAttribute), true))
            .FirstOrDefault();

        var log = new Log
        {
            UserId = (User.Identity.IsAuthenticated ? user.Id : null),
            Ip = context.HttpContext.Connection.RemoteIpAddress.ToString(),
            Controller = context.HttpContext.Request.RouteValues["controller"].ToString(),
            Action = context.HttpContext.Request.RouteValues["action"].ToString(),
            Developer = description.Developer,
            Description = description.Description,
            HttpMethod = context.HttpContext.Request.Method,
            Url = context.HttpContext.Request.GetDisplayUrl(),
            Error = false,
            InsertedDate = DateTime.Now
        };

        if (context.HttpContext.Request.HasFormContentType)
        {
            IFormCollection form = await context.HttpContext.Request.ReadFormAsync();
            log.FormContent = JsonConvert.SerializeObject(form);
        }

        db.Log.Add(log);
        await db.SaveChangesAsync();

        await next();

        ViewData["Error"] = TempData.Get<ErrorVM>("Error");
    }

    protected async Task LogError(Exception ex)
    {
        var log = new Log
        {
            Error = false,
            UserId = user.Id,
            Ip = HttpContext.Connection.RemoteIpAddress.ToString(),
            Controller = HttpContext.Request.RouteValues["controller"].ToString(),
            Action = HttpContext.Request.RouteValues["action"].ToString(),
            HttpMethod = HttpContext.Request.Method,
            Url = HttpContext.Request.GetDisplayUrl(),
            InsertedDate = DateTime.Now
        };

        if (HttpContext.Request.HasFormContentType)
        {
            IFormCollection form = await HttpContext.Request.ReadFormAsync();
            log.FormContent = JsonConvert.SerializeObject(form);
        }

        log.Exception = JsonConvert.SerializeObject(ex);
        log.Error = true;
        db.Log.Add(log);
        await db.SaveChangesAsync();
    }

    #region Role

    protected string GetRoleFromStaffType(int staffType) =>
        staffType switch
        {
            (int)StaffTypeEnum.Administrator => "6dce687e-0a9c-4bcf-aa79-65c13a8b8db0",
            _ => ""
        };

    [HttpPost, Description("Arb Tahiri", "Action to change actual role.")]
    public async Task<IActionResult> ChangeRole(string ide)
    {
        string roleId = CryptoSecurity.Decrypt<string>(ide.Replace("\\", ""));
        var realRoles = await db.RealRole.Include(t => t.Role).Where(t => t.UserId == user.Id).ToListAsync();

        if (!realRoles.Any(t => t.RoleId == roleId))
        {
            return Unauthorized();
        }

        var currentRole = User.Claims.Where(t => t.Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/role").FirstOrDefault();
        string role = realRoles.Where(t => t.RoleId == roleId).Select(t => t.Role.Name).FirstOrDefault();

        var error = new ErrorVM { Status = ErrorStatus.Success, Description = string.Format(Resource.RoleChangedSuccess, role) };

        var result = await userManager.RemoveFromRoleAsync(user, currentRole.Value);
        if (!result.Succeeded)
        {
            error = new ErrorVM { Status = ErrorStatus.Error, Description = Resource.ThereWasAnError };
        }
        else
        {
            result = await userManager.AddToRoleAsync(user, role);
            if (!result.Succeeded)
            {
                await userManager.AddToRoleAsync(user, currentRole.Value);
                error = new ErrorVM { Status = ErrorStatus.Error, Description = Resource.ThereWasAnError };
            }
        }
        return Json(error);
    }

    #endregion

    #region Application mode

    [HttpPost, Description("Arb Tahiri", "Action to change actual role.")]
    public async Task<IActionResult> ChangeMode(bool mode)
    {
        var currentUser = await db.AspNetUsers.FindAsync(user.Id);
        currentUser.AppMode = (int)(mode ? TemplateMode.Dark : TemplateMode.Light);
        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success });
    }

    #endregion

    #region Error

    [AllowAnonymous, Description("Arb Tahiri", "Error status message.")]
    public IActionResult _AlertMessage(ErrorVM error) => PartialView(error);

    [Route("404"), Description("Arb Tahiri", "When page is not found.")]
    public IActionResult PageNotFound()
    {
        if (HttpContext.Items.ContainsKey("originalPath"))
        {
            _ = HttpContext.Items["originalPath"] as string;
        }
        return View();
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    [Description("Arb Tahiri", "Error view")]
    public IActionResult Error() => View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });

    #endregion

    #region Language

    [Description("Arb Tahiri", "Change language.")]
    public async Task<ActionResult> ChangeLanguage(string culture, string returnUrl = "/")
    {
        var cultureInfo = new CultureInfo(culture);
        cultureInfo.NumberFormat.NumberDecimalSeparator = ".";
        cultureInfo.NumberFormat.NumberGroupSeparator = ",";
        Thread.CurrentThread.CurrentUICulture = cultureInfo;
        Response.Cookies.Append(
            CookieRequestCultureProvider.DefaultCookieName,
            CookieRequestCultureProvider.MakeCookieValue(new RequestCulture(culture)),
            new CookieOptions
            {
                Expires = DateTimeOffset.UtcNow.AddYears(1),
                HttpOnly = true,
                Secure = true
            });

        if (User.Identity.IsAuthenticated)
        {
            user.Language = GetLanguage(culture);
            await userManager.UpdateAsync(user);
        }
        return LocalRedirect(returnUrl);
    }

    protected LanguageEnum GetLanguage(string culture) =>
        culture switch
        {
            "sq-AL" => LanguageEnum.Albanian,
            "en-GB" => LanguageEnum.English,
            _ => LanguageEnum.Albanian,
        };

    #endregion

    #region Notification

    [HttpPost, Description("Arb Tahiri", "Change notification mode.")]
    public async Task<IActionResult> ChangeNotificationMode(bool mode)
    {
        var currentUser = await db.AspNetUsers.FindAsync(user.Id);
        currentUser.AllowNotification = mode;
        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = "Notification mode changed successfully!" });
    }

    protected string GetNotificationType(NotificationTypeEnum notificationType) =>
        notificationType switch
        {
            NotificationTypeEnum.Success => "success",
            NotificationTypeEnum.Info => "info",
            NotificationTypeEnum.Warning => "warning",
            NotificationTypeEnum.Error => "error",
            NotificationTypeEnum.Question => "question",
            _ => "info",
        };

    public async Task SendNotification(string title, string description, string target, string url, List<string> users, NotificationUtility notification, NotificationTypeEnum notificationType, string background, string icon) =>
        await notification.SendNotification(user.Id, users, new NotificationSend
        {
            title = title,
            description = description,
            icon = icon,
            url = url,
            target = target,
            background = background,
            notificationType = GetNotificationType(notificationType),
            NotificationType = notificationType
        });

    #endregion

    #region Technical

    public async Task<List<string>> GetUsers(string role) =>
        await db.AspNetUsers.Where(a => a.Role.Any(a => a.Name == role)).Select(a => a.Id).ToListAsync();

    protected int? UpdateNo(int? updateNo) =>
        updateNo.HasValue ? ++updateNo : 1;

    protected double WorkingDays(DateTime startDate, DateTime endDate)
    {
        double workingDays = 1 + ((endDate - startDate).TotalDays * 5 - (startDate.DayOfWeek - endDate.DayOfWeek) * 2) / 7;
        //if (endDate.DayOfWeek == DayOfWeek.Saturday)
        //{
        //    workingDays--;
        //}
        //if (startDate.DayOfWeek == DayOfWeek.Sunday)
        //{
        //    workingDays--;
        //}
        return workingDays;
    }

    protected string FirstTimePassword(IConfiguration configuration, string firstName, string lastName)
    {
        string password = "@1234";
        if (bool.Parse(configuration["SecurityConfiguration:Password:RequireUppercase"]))
        {
            password += firstName[..1].ToUpper();
        }
        if (bool.Parse(configuration["SecurityConfiguration:Password:RequireLowercase"]))
        {
            password += lastName[..1].ToLower();
        }
        password += "#";
        return password;
    }

    protected static string GetMonthName(int month) =>
        month switch
        {
            1 => Resource.January,
            2 => Resource.February,
            3 => Resource.March,
            4 => Resource.April,
            5 => Resource.May,
            6 => Resource.June,
            7 => Resource.July,
            8 => Resource.August,
            9 => Resource.September,
            10 => Resource.October,
            11 => Resource.November,
            12 => Resource.December,
            _ => Resource.January,
        };

    protected static string GetDayName(DayOfWeek day) =>
        day switch
        {
            DayOfWeek.Monday => Resource.Monday,
            DayOfWeek.Tuesday => Resource.Tuesday,
            DayOfWeek.Wednesday => Resource.Wednesday,
            DayOfWeek.Thursday => Resource.Thursday,
            DayOfWeek.Friday => Resource.Friday,
            DayOfWeek.Saturday => Resource.Saturday,
            DayOfWeek.Sunday => Resource.Sunday,
            _ => Resource.Monday,
        };

    #endregion

    #region Save file

    [SupportedOSPlatform("windows")]
    protected async Task<string> SaveFile(IConfiguration configuration, IFormFile file, string folder, string fileTitle, int type = 512)
    {
        int maxKB = int.Parse(configuration["AppSettings:FileMaxKB"]);
        string[] imageFormats = configuration["AppSettings:ImagesFormat"].Split(",");

        if (file != null && file.Length > 0 && maxKB * 1024 >= file.Length)
        {
            string fileName = string.IsNullOrEmpty(fileTitle) ? (Guid.NewGuid().ToString() + Path.GetExtension(file.FileName)) : fileTitle;
            string uploads = Path.Combine(configuration["AppSettings:FilePath"], $"{folder}");
            if (!Directory.Exists(uploads))
            {
                Directory.CreateDirectory(uploads);
            }

            string filePath = Path.Combine(uploads, fileName);
            if (imageFormats.Contains(Path.GetExtension(file.FileName).ToUpper()))
            {
                await ResizeImage(file, filePath, type);
            }
            else
            {
                using var fileStream = new FileStream(filePath, FileMode.Create);
                await file.CopyToAsync(fileStream);
            }
            return $"/{folder}/{fileName}";
        }
        else return null;
    }

    [SupportedOSPlatform("windows")]
    protected async Task ResizeImage(IFormFile file, string filePath, int size)
    {
        var stream = new MemoryStream();
        await file.CopyToAsync(stream);
        stream.Position = 0;

        int width, height;
        var image = Image.FromStream(stream);
        if (image.Width > image.Height)
        {
            width = size;
            height = Convert.ToInt32(image.Height * size / (double)image.Width);
        }
        else
        {
            width = Convert.ToInt32(image.Width * size / (double)image.Height);
            height = size;
        }

        stream.Position = 0;
        var resizer = new MagickImage(stream) { Orientation = OrientationType.TopLeft };
        resizer.Resize(width, height);
        resizer.Write(filePath);
    }

    [SupportedOSPlatform("windows")]
    protected async Task<string> SaveImage(IWebHostEnvironment environment, IFormFile file, string folder, int type = 512)
    {
        //string fileName = Path.GetFileNameWithoutExtension(file.FileName);
        string extension = Path.GetExtension(file.FileName);

        string uploads = Path.Combine(environment.WebRootPath, $"Uploads/{folder}");
        if (!Directory.Exists(uploads))
        {
            Directory.CreateDirectory(uploads);
        }

        string fileName = Guid.NewGuid().ToString() + extension;
        string filePath = Path.Combine(uploads, fileName);
        await ResizeImage(file, filePath, type);

        using (var fileStream = new FileStream(filePath, FileMode.Create))
        {
            await file.CopyToAsync(fileStream);
        }
        return $"/Uploads/{folder}/{fileName}";
    }

    #endregion

    #region Email

    protected void SendEmailAsync(IConfiguration configuration, string email, string subject, string htmlMessage, string name, bool addHeader = true)
    {
        var smtpClient = new SmtpClient();
        var networkCredential = new NetworkCredential(configuration["EmailConfiguration:Email"], configuration["EmailConfiguration:Password"]);
        var mailMessage = new MailMessage();
        var mailAddress = new MailAddress(configuration["EmailConfiguration:Email"]);

        smtpClient.Host = configuration["EmailConfiguration:Host"];
        smtpClient.UseDefaultCredentials = false;
        smtpClient.Credentials = networkCredential;
        smtpClient.EnableSsl = bool.Parse(configuration["EmailConfig:SSL"]);
        smtpClient.Port = int.Parse(configuration["EmailConfiguration:Port"].ToString());
        mailMessage.From = mailAddress;
        mailMessage.Subject = subject;
        mailMessage.IsBodyHtml = true;
        mailMessage.Body = BodyContent(htmlMessage, name, null, null, addHeader);
        mailMessage.To.Add(email);
        Thread thread = new(async t =>
        {
            try
            {
                await smtpClient.SendMailAsync(mailMessage);
            }
            catch (Exception ex)
            {
                await LogError(ex);
            }
        });
        thread.Start();
    }

    private string BodyContent(string content, string name = "", string title = null, string description = null, bool addHeader = true)
    {
        string email = $"<div>{content}</div>";
        return email;
    }

    #endregion

    #region Select list items

    [HttpPost, ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "List of users for select list")]
    public async Task<IActionResult> AspUsers(string name, string role = "")
    {
        string search = string.IsNullOrEmpty(name) ? "" : name;
        var list = await db.AspNetUsers
            .Where(a => (a.FirstName.ToLower().Contains(search.ToLower()) || a.LastName.ToLower().Contains(search.ToLower()))
                && (string.IsNullOrEmpty(role) || a.Role.Any(b => b.Id == role)))
            .Take(10)
            .Select(a => new Select2
            {
                id = a.Id,
                text = $"{a.FirstName} {a.LastName}",
                image = a.ProfileImage,
                initials = $"{a.FirstName.Substring(0, 1)} {a.LastName.Substring(0, 1)}"
            }).ToListAsync();
        list.Add(new Select2 { id = "", text = Resource.Choose });
        return Json(list.OrderBy(a => a.id));
    }

    [HttpPost, ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "List of staff for select list")]
    public async Task<IActionResult> GetStaff(string name, string userId)
    {
        string search = string.IsNullOrEmpty(name) ? "" : name;
        var list = await db.Staff
            .Include(a => a.User)
            .Where(a => (a.FirstName.ToLower().Contains(search.ToLower()) || a.LastName.ToLower().Contains(search.ToLower()))
                && (string.IsNullOrEmpty(userId) || a.UserId != userId)
                && (a.StaffDepartment.Any(a => a.EndDate.Date >= DateTime.Now.Date)))
            .Take(10)
            .Select(a => new Select2
            {
                id = a.StaffId.ToString(),
                text = $"{a.FirstName} {a.LastName}",
                image = a.User.ProfileImage,
                initials = $"{a.FirstName.Substring(0, 1)} {a.LastName.Substring(0, 1)}"
            }).ToListAsync();
        list.Add(new Select2 { id = "", text = Resource.Choose });
        return Json(list.OrderBy(a => a.id));
    }

    [HttpGet, Description("Arb Tahiri", "List of staff for select list")]
    public async Task<IActionResult> GetCurrentStaff(int staffId) =>
        Json(await db.Staff
            .Include(a => a.User)
            .Where(a => a.StaffId == staffId)
            .Select(a => new Select2
            {
                id = a.StaffId.ToString(),
                text = $"{a.FirstName} {a.LastName}",
                image = a.User.ProfileImage,
                initials = $"{a.FirstName.Substring(0, 1)} {a.LastName.Substring(0, 1)}"
            }).ToListAsync());

    #endregion
}
