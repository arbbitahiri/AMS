using AMS.Areas.Administration.Models.Email;
using AMS.Controllers;
using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models.Shared;
using AMS.Resources;
using AMS.Utilities;
using AMS.Utilities.General;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace AMS.Areas.Administration.Controllers;

public class EmailController : BaseController
{
    public EmailController(AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
    }

    [HttpGet, Authorize(Policy = "33:m"), Description("Arb Tahiri", "Form to display email.")]
    public async Task<IActionResult> Index()
    {
        ViewData["Title"] = Resource.EmailConfiguration;
        var streamReader = new StreamReader("appsettings.json");
        string json = await streamReader.ReadToEndAsync();
        streamReader.Close();
        dynamic data = JsonConvert.DeserializeObject(json);
        var email = new EmailVM
        {
            Email = data["EmailConfiguration"]["Email"],
            Password = data["EmailConfiguration"]["Password"],
            CC = data["EmailConfiguration"]["CC"],
            Host = data["EmailConfiguration"]["Host"],
            Port = data["EmailConfiguration"]["Port"],
            SSLEnable = data["EmailConfiguration"]["EnableSsl"]
        };
        return View(email);
    }

    [HttpPost, Authorize(Policy = "33:c"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Method to change email on appsettings.")]
    public async Task<IActionResult> Email(EmailVM em)
    {
        if (!ModelState.IsValid)
        {
            TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
            return RedirectToAction(nameof(Email));
        }

        var appSettings = new AppSettings
        {
            InsertedDate = DateTime.Now,
            InsertedFrom = user.Id
        };

        var streamReader = new StreamReader("appsettings.json");
        string json = await streamReader.ReadToEndAsync();
        dynamic data = JsonConvert.DeserializeObject(json);
        appSettings.OldVersion = json;

        data["EmailConfiguration"]["Email"] = em.Email;
        data["EmailConfiguration"]["Password"] = em.Password;
        data["EmailConfiguration"]["CC"] = em.CC;
        data["EmailConfiguration"]["Host"] = em.Host;
        data["EmailConfiguration"]["Port"] = em.Port;
        data["EmailConfiguration"]["EnableSsl"] = em.SSLEnable;

        var streamWriter = new StreamWriter("appsettings.json", false);
        await streamWriter.WriteAsync(JsonConvert.SerializeObject(data));
        await streamWriter.FlushAsync();
        streamWriter.Close();

        appSettings.NewVersion = JsonConvert.SerializeObject(data);
        db.AppSettings.Add(appSettings);
        await db.SaveChangesAsync();

        TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Success, Description = Resource.DataRegisteredSuccessfully });
        return RedirectToAction(nameof(Index));
    }
}
