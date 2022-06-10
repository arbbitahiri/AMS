using AMS.Data;
using AMS.Data.Core;
using AMS.Data.General;
using AMS.Repositories;
using AMS.Services;
using AMS.Utilities.General;
using AMS.Utilities.NotificationUtil;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI.Services;
using Microsoft.AspNetCore.Localization;
using Microsoft.AspNetCore.Rewrite;
using Microsoft.EntityFrameworkCore;
using System.Globalization;

var builder = WebApplication.CreateBuilder(args);

var connectionString = builder.Configuration.GetConnectionString("SqlConnection");

builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(connectionString));
builder.Services.AddDbContext<AMSContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddDatabaseDeveloperPageExceptionFilter();

builder.Services.AddControllersWithViews(setupAction =>
{
    setupAction.EnableEndpointRouting = false;
});

builder.Services.AddIdentity<ApplicationUser, ApplicationRole>(options =>
{
    options.Password.RequireLowercase = bool.Parse(builder.Configuration["SecurityConfig:Password:RequireLowercase"]);
    options.Password.RequireNonAlphanumeric = bool.Parse(builder.Configuration["SecurityConfig:Password:RequireNonAlphanumeric"]);
    options.Password.RequireUppercase = bool.Parse(builder.Configuration["SecurityConfig:Password:RequireUppercase"]);
    options.Password.RequireDigit = bool.Parse(builder.Configuration["SecurityConfig:Password:RequireDigit"]);
    options.Password.RequiredLength = int.Parse(builder.Configuration["SecurityConfig:Password:RequiredLength"]);
    options.SignIn.RequireConfirmedEmail = bool.Parse(builder.Configuration["SecurityConfig:Password:RequireConfirmedEmail"]);
    options.SignIn.RequireConfirmedAccount = bool.Parse(builder.Configuration["SecurityConfig:Password:RequireConfirmedAccount"]);
    options.Lockout.MaxFailedAccessAttempts = int.Parse(builder.Configuration["SecurityConfig:Password:MaxFailedAccessAttempts"]);
}).AddRoles<ApplicationRole>()
  .AddEntityFrameworkStores<ApplicationDbContext>().
  AddErrorDescriber<IdentityErrorDescriber>().
  AddDefaultTokenProviders();

builder.Services.AddRazorPages()
    .AddRazorRuntimeCompilation();
builder.Services.AddSignalR();

builder.Services.Configure<DataProtectionTokenProviderOptions>(o =>
{
    o.TokenLifespan = TimeSpan.FromHours(1);
});

builder.Services.AddMvc(setup =>
{
    setup.EnableEndpointRouting = false;
}).AddRazorRuntimeCompilation();

builder.Services.AddTransient<IEmailSender, EmailSender>();
builder.Services.AddSingleton<IAuthorizationPolicyProvider, AuthorizationPolicyProvider>();
builder.Services.AddScoped<IDDLRepository, DDLRepository>();
builder.Services.AddScoped<IFunctionRepository, FunctionRepository>();

builder.Services.ConfigureExternalCookie(options =>
{
    options.Cookie.SameSite = SameSiteMode.None;
    options.Cookie.HttpOnly = true;
    options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
});

builder.Services.ConfigureApplicationCookie(options =>
{
    options.Cookie.SameSite = SameSiteMode.None;
    options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
    options.LoginPath = "/Identity/Account/Login";
    options.AccessDeniedPath = "/Identity/Account/AccessDenied";
});

builder.Services.Configure<PasswordHasherOptions>(options =>
{
    options.IterationCount = 15000;
});

builder.Services.Configure<IISServerOptions>(options =>
{
    options.MaxRequestBodySize = long.MaxValue;
});

builder.Services.AddResponseCaching();
builder.Services.AddResponseCompression();
builder.Services.AddMemoryCache();

var app = builder.Build();

app.Use(async (context, next) =>
{
    context.Response.Headers.Add("X-Frame-Options", "SAMEORIGIN");
    await next();
});

IList<CultureInfo> supportedCultures = new List<CultureInfo>
{
    new CultureInfo("sq-AL")
    {
        DateTimeFormat = new DateTimeFormatInfo { DateSeparator="/" },
        NumberFormat = new NumberFormatInfo { CurrencyDecimalDigits = 2, CurrencyGroupSeparator =",", CurrencyDecimalSeparator = ".", NumberGroupSeparator = ",", NumberDecimalSeparator = "." }
    },
    new CultureInfo("en-GB")
    {
        DateTimeFormat = new DateTimeFormatInfo { DateSeparator="/" },
        NumberFormat = new NumberFormatInfo { CurrencyDecimalDigits = 2, CurrencyGroupSeparator =",", CurrencyDecimalSeparator = ".", NumberGroupSeparator = ",", NumberDecimalSeparator = "." }
    },
};

var culture = new CultureInfo("sq_AL");
culture.NumberFormat.NumberDecimalSeparator = ".";
culture.NumberFormat.NumberGroupSeparator = ",";
culture.DateTimeFormat.DateSeparator = "/";

app.UseRequestLocalization(new RequestLocalizationOptions
{
    DefaultRequestCulture = new RequestCulture(culture),
    SupportedCultures = supportedCultures,
    SupportedUICultures = supportedCultures
});

if (app.Environment.IsDevelopment())
{
    app.UseMigrationsEndPoint();
}
else
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseExceptionHandlerMiddleware();

app.UseStaticFiles(new StaticFileOptions()
{
    OnPrepareResponse = r =>
    {
        string path = r.File.PhysicalPath;
        if (path.EndsWith(".jpeg") || path.EndsWith(".jpg") || path.EndsWith(".png") || path.EndsWith(".svg") || path.EndsWith(".css") || path.EndsWith(".js"))
        {
            var maxAge = new TimeSpan(7, 0, 0, 0);
            r.Context.Response.Headers.Append("Cache-Control", "max-age=" + maxAge.TotalSeconds.ToString("0"));
        }
    }
});

app.UseStaticFiles();
app.UseRouting();

app.UseResponseCaching();
app.UseCookiePolicy();
app.UseResponseCompression();

app.Use(async (context, next) =>
{
    context.Response.GetTypedHeaders().CacheControl =
      new Microsoft.Net.Http.Headers.CacheControlHeaderValue()
      {
          Public = true,
          MaxAge = TimeSpan.FromHours(24)
      };
    context.Response.Headers[Microsoft.Net.Http.Headers.HeaderNames.Vary] =
      new string[] { "Accept-Encoding" };
    await next();
});

//app.UseRewriter(new RewriteOptions().AddRedirectToWww().AddRedirectToHttps());

///app.UseMigrationsEndPoint();

app.UseAuthentication();
app.UseAuthorization();
//app.UseSession();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{ide?}");
app.MapRazorPages();
app.MapHub<NotificationHub>("/notificationHub");

app.Run();