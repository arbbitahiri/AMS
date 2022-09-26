using AMS.Areas.Administration.Models.Email;
using AMS.Controllers;
using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models.Shared;
using AMS.Resources;
using AMS.Utilities;
using AMS.Utilities.General;
using AMS.Utilities.Security;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;

namespace AMS.Areas.Administration.Controllers;

[Route("/{area}/{controller}/{action}")]
public class EmailController : BaseController
{
    public EmailController(AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
    }

    [HttpGet, Authorize(Policy = "33:m"), Description("Arb Tahiri", "Form to display email.")]
    public IActionResult Index() => View();

    #region DataBase email

    [HttpGet, Authorize(Policy = "33:m"), Description("Arb Tahiri", "Form to display email.")]
    public async Task<IActionResult> DBIndex()
    {
        var dbEmail = await db.Email.Where(a => a.Active)
            .Select(a => new DataBaseEmail
            {
                EmailIde = CryptoSecurity.Encrypt(a.EmailId),
                DBEmail = a.EmailAddress,
                DBPassword = CryptoSecurity.Decrypt<string>(a.Password),
                DBHost = a.Smtphost,
                DBCC = a.Cc,
                DBPort = a.Port,
                DBSSLEnable = a.Sslprotocol
            }).FirstOrDefaultAsync();
        return View(dbEmail);
    }

    [HttpPost, Authorize(Policy = "33:c"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Method to change email on appsettings.")]
    public async Task<IActionResult> DBEmail(DataBaseEmail em)
    {
        if (!ModelState.IsValid)
        {
            TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
            return RedirectToAction(nameof(Index));
        }

        var emailId = !string.IsNullOrEmpty(em.EmailIde) ? CryptoSecurity.Decrypt<int>(em.EmailIde) : 0;
        var currentEmail = await db.Email.FirstOrDefaultAsync(a => a.EmailId == emailId);
        if (currentEmail != null)
        {
            currentEmail.Active = false;
            currentEmail.UpdatedDate = DateTime.Now;
            currentEmail.UpdatedFrom = user.Id;
            currentEmail.UpdatedNo = UpdateNo(currentEmail.UpdatedNo);
        }

        db.Email.Add(new Email
        {
            EmailAddress = em.DBEmail,
            Password = CryptoSecurity.Encrypt(em.DBPassword),
            Smtphost = em.DBHost,
            Cc = em.DBCC,
            Port = em.DBPort,
            Sslprotocol = em.DBSSLEnable,
            Active = true,
            InsertedDate = DateTime.Now,
            InsertedFrom = user.Id
        });
        await db.SaveChangesAsync();

        TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Success, Description = Resource.DataRegisteredSuccessfully });
        return RedirectToAction(nameof(Index));
    }

    #endregion

    #region AppSettings email

    [HttpGet, Authorize(Policy = "33:m"), Description("Arb Tahiri", "Form to display email.")]
    public async Task<IActionResult> AppIndex()
    {
        var streamReader = new StreamReader("appsettings.json");
        string json = await streamReader.ReadToEndAsync();
        streamReader.Close();
        dynamic data = JsonConvert.DeserializeObject(json);
        var appEmail = new AppSettingsEmail
        {
            AEmail = data["EmailConfiguration"]["Email"],
            APassword = data["EmailConfiguration"]["Password"],
            ACC = data["EmailConfiguration"]["CC"],
            AHost = data["EmailConfiguration"]["Host"],
            APort = data["EmailConfiguration"]["Port"],
            ASSLEnable = data["EmailConfiguration"]["EnableSsl"]
        };
        return View(appEmail);
    }

    [HttpPost, Authorize(Policy = "33:c"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Method to change email on appsettings.")]
    public async Task<IActionResult> AppEmail(AppSettingsEmail em)
    {
        if (!ModelState.IsValid)
        {
            TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
            return RedirectToAction(nameof(AppEmail));
        }

        using (var streamReader = new StreamReader("appsettings.json"))
        {
            string json = await streamReader.ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(json);

            var appSettings = new AppSettings
            {
                InsertedDate = DateTime.Now,
                InsertedFrom = user.Id,
                OldVersion = json
            };

            data["EmailConfiguration"]["Email"] = em.AEmail;
            data["EmailConfiguration"]["Password"] = em.APassword;
            data["EmailConfiguration"]["CC"] = em.ACC;
            data["EmailConfiguration"]["Host"] = em.AHost;
            data["EmailConfiguration"]["Port"] = em.APort;
            data["EmailConfiguration"]["EnableSsl"] = em.ASSLEnable;

            using (var streamWriter = new StreamWriter("appsettings.json", false))
            {
                await streamWriter.WriteAsync(JsonConvert.SerializeObject(data));
                await streamWriter.FlushAsync();
                streamWriter.Close();
            }

            appSettings.NewVersion = JsonConvert.SerializeObject(data);
            db.AppSettings.Add(appSettings);
            await db.SaveChangesAsync();
        }

        TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Success, Description = Resource.DataRegisteredSuccessfully });
        return RedirectToAction(nameof(Index));
    }

    #endregion
}
