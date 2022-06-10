using AMS.Areas.Trace.Models.Server;
using AMS.Controllers;
using AMS.Data.Core;
using AMS.Data.General;
using AMS.Utilities.General;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using System.Globalization;
using System.Runtime.Versioning;
using System.Security;

namespace AMS.Areas.Trace.Controllers;

public class ServerController : BaseController
{
    public ServerController(AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
    }

    #region Search

    [Authorize(Policy = "62:m"), Description("Arb Tahiri", "Entry form for security logs.")]
    public IActionResult Security() => View();

    [SupportedOSPlatform("windows")]
    [HttpPost, Authorize(Policy = "62:r"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to search for security logs.")]
    public async Task<IActionResult> Search(Search search)
    {
        string[] dates = search.LogTime.Split(" - ");
        DateTime startDate = DateTime.ParseExact(dates[0], "dd/MM/yyyy H:mm", CultureInfo.InvariantCulture, DateTimeStyles.None);
        DateTime endDate = DateTime.ParseExact(dates[1], "dd/MM/yyyy H:mm", CultureInfo.InvariantCulture);

        var eventLogs = EventLog.GetEventLogs();
        var logs = new List<ServerLog>();

        try
        {
            foreach (var log in eventLogs)
            {
                foreach (EventLogEntry entry in log.Entries)
                {
                    if (entry.TimeGenerated >= startDate && entry.TimeGenerated <= endDate)
                    {
                        if (search.EventLogEntryType != null)
                        {
                            if (entry.EntryType == search.EventLogEntryType)
                            {
                                logs.Add(new ServerLog
                                {
                                    EntryType = entry.EntryType.ToString(),
                                    EventLogEntryType = entry.EntryType,
                                    Machine = entry.MachineName,
                                    Message = entry.Message,
                                    Source = entry.Source,
                                    Time = entry.TimeGenerated,
                                    Username = entry.UserName
                                });
                            }
                        }
                        else
                        {
                            logs.Add(new ServerLog
                            {
                                EntryType = entry.EntryType.ToString(),
                                EventLogEntryType = entry.EntryType,
                                Machine = entry.MachineName,
                                Message = entry.Message,
                                Source = entry.Source,
                                Time = entry.TimeGenerated,
                                Username = entry.UserName
                            });
                        }
                    }
                }
            }
        }
        catch (SecurityException ex)
        {
            await LogError(ex);
        }
        return PartialView(logs);
    }

    #endregion

    #region Report

    #endregion
}
