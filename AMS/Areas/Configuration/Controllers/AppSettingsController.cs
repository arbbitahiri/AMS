using AMS.Areas.Configuration.Models.AppSettings;
using AMS.Controllers;
using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models.Shared;
using AMS.Repositories;
using AMS.Resources;
using AMS.Utilities;
using AMS.Utilities.General;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace AMS.Areas.Configuration.Controllers;

[Route("/{area}/{controller}/{action}")]
public class AppSettingsController : BaseController
{
    private readonly RoleManager<ApplicationRole> roleManager;
    private readonly IFunctionRepository function;

    public AppSettingsController(RoleManager<ApplicationRole> roleManager, IFunctionRepository function,
        AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
        this.roleManager = roleManager;
        this.function = function;
    }

    [HttpGet, Authorize(Policy = "21:m")]
    [Description("Arb Tahiri", "Form to display list of application settings.")]
    public IActionResult Index()
    {
        ViewData["Title"] = Resource.ApplicationSetings;

        var appSettings = new List<ApplicationSettings>();

        string json = string.Empty;
        using (var streamReader = new StreamReader("appsettings.json"))
        {
            json = streamReader.ReadToEnd();
        }

        dynamic data = JsonConvert.DeserializeObject(json);

        foreach (var item in data.ConnectionStrings)
        {
            appSettings.Add(new ApplicationSettings { Key = item.Name, Region = "ConnectionString", Value = item.Value });
        }

        foreach (var item in data.AppSettings)
        {
            appSettings.Add(new ApplicationSettings { Key = item.Name, Region = "AppSettings", Value = item.Value });
        }


        foreach (var item in data.EmailConfiguration)
        {
            appSettings.Add(new ApplicationSettings { Key = item.Name, Region = "EmailConfiguration", Value = item.Value });
        }

        return View(appSettings);
    }

    [HttpPost, Authorize(Policy = "15:r")]
    [Description("Arb Tahiri", "Form to edit application settings.")]
    public async Task<IActionResult> _Edit(ApplicationSettings edit)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Title = Resource.Warning, Description = Resource.InvalidData });
        }

        string json = string.Empty;
        using (var streamReader = new StreamReader("appsettings.json"))
        {
            json = streamReader.ReadToEnd();
        }
        dynamic data = JsonConvert.DeserializeObject(json);

        db.AppSettings.Add(new AppSettings
        {
            OldVersion = data[edit.Region][edit.Key],
            NewVersion = edit.Value
        });

        await db.SaveChangesAsync();
        data[edit.Region][edit.Key] = edit.Value;

        using (var streamWriter = new StreamWriter("appsettings.json", false))
        {
            await streamWriter.WriteAsync(JsonConvert.SerializeObject(data));
        }

        return Json(new ErrorVM { Status = ErrorStatus.Success, Title = Resource.Success, Description = Resource.DataRegisteredSuccessfully });
    }
}
