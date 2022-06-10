﻿using AMS.Data.General;
using Microsoft.AspNetCore.Http.Extensions;
using Newtonsoft.Json;
using System.Security.Claims;

namespace AMS.Utilities.General;

public class ExceptionHandlerMiddleware
{
    private readonly RequestDelegate next;

    public ExceptionHandlerMiddleware(RequestDelegate next)
    {
        this.next = next;
    }

    public async Task Invoke(HttpContext context, AMSContext db)
    {
        try
        {
            await next.Invoke(context);
        }
        catch (Exception ex)
        {
            await HandleExceptionMessageAsync(context, ex, db);
        }
    }

    private static async Task HandleExceptionMessageAsync(HttpContext context, Exception exception, AMSContext db)
    {
        db.ChangeTracker.Clear();
        var log = new Log
        {
            UserId = context.User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "",
            Ip = context.Connection.RemoteIpAddress.ToString() ?? "",
            Controller = context.Request.RouteValues["controller"].ToString() ?? "",
            Action = context.Request.RouteValues["action"].ToString() ?? "",
            HttpMethod = context.Request.Method ?? "",
            Url = context.Request.GetDisplayUrl() ?? "",
            Exception = JsonConvert.SerializeObject(exception) ?? "",
            InsertedDate = DateTime.Now,
            Error = true
        };

        if (context.Request.HasFormContentType)
        {
            IFormCollection form = await context.Request.ReadFormAsync();
            log.FormContent = JsonConvert.SerializeObject(form);
        }
        db.Log.Add(log);
        await db.SaveChangesAsync();

        if (context.Request.Headers["x-requested-with"] == "XMLHttpRequest")
        {
            context.Response.StatusCode = StatusCodes.Status400BadRequest;
            var result = JsonConvert.SerializeObject(new
            {
                StatusCode = StatusCodes.Status400BadRequest,
                ErrorMessage = exception.Message
            });
            await context.Response.WriteAsync(result);
        }
        else
        {
            context.Response.Redirect("/Home/Error");
        }
    }
}
