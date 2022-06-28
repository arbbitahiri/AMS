using AMS.Areas.Administration.Models.Users;
using AMS.Controllers;
using AMS.Data;
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

namespace AMS.Areas.Administration.Controllers;

[Route("/{area}/{controller}/{action}")]
public class UsersController : BaseController
{
    private readonly IWebHostEnvironment environment;
    private readonly IConfiguration configuration;
    private readonly ApplicationDbContext application;

    public UsersController(IWebHostEnvironment environment, IConfiguration configuration,
        ApplicationDbContext application, RoleManager<ApplicationRole> roleManager,
        AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
        this.environment = environment;
        this.configuration = configuration;
        this.application = application;
    }

    #region Search

    [HttpGet, Authorize(Policy = "31:m"), Description("Arb Tahiri", "Entry home to display users.")]
    public IActionResult Index() => View();

    [HttpPost, Authorize(Policy = "31:m"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to search for users.")]
    public async Task<IActionResult> Search(Search search)
    {
        var users = await db.AspNetUsers
            .Where(a => a.Role.Any(a => a.Id == (search.Role ?? a.Id))
                && (string.IsNullOrEmpty(search.PersonalNumber) || search.PersonalNumber.Contains(a.PersonalNumber))
                && (string.IsNullOrEmpty(search.Firstname) || search.Firstname.Contains(a.FirstName))
                && (string.IsNullOrEmpty(search.Lastname) || search.Lastname.Contains(a.LastName))
                && (string.IsNullOrEmpty(search.Email) || search.Email.Contains(a.Email)))
            .AsSplitQuery()
            .Select(a => new UserVM
            {
                UserId = CryptoSecurity.Encrypt(a.Id),
                ProfileImage = a.ProfileImage,
                PersonalNumber = a.PersonalNumber,
                Firstname = a.FirstName,
                Lastname = a.LastName,
                Name = $"{a.FirstName} {a.LastName}",
                Email = a.Email,
                PhoneNumber = a.PhoneNumber,
                Roles = string.Join(", ", a.Role.Select(a => user.Language == LanguageEnum.Albanian ? a.NameSq : a.NameEn).ToArray()),
                LockoutEnd = a.LockoutEnd
            }).ToListAsync();
        return Json(users);
    }

    #endregion

    #region Create

    [HttpGet, Authorize(Policy = "31:c"), Description("Arb Tahiri", "Form to create a user.")]
    public IActionResult Create() => View();

    [HttpPost, Authorize(Policy = "31:c"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to create a user.")]
    public async Task<IActionResult> Create(Create create)
    {
        if (!ModelState.IsValid)
        {
            TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Warning, Title = Resource.Warning, Description = Resource.InvalidData, Dismissible = true });
            return View(create);
        }

        if (await application.Users.AnyAsync(a => a.Email == create.Email || a.UserName == create.Username))
        {
            TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Warning, Title = Resource.Warning, Description = Resource.UserHasAccount, Dismissible = true });
            return View(create);
        }

        string filePath = create.ProfileImage != null ? await SaveImage(environment, create.ProfileImage, "Users") : null;

        var firstUser = new ApplicationUser
        {
            PersonalNumber = create.PersonalNumber,
            FirstName = create.Firstname,
            LastName = create.Lastname,
            Email = create.Email,
            EmailConfirmed = true,
            PhoneNumber = create.PhoneNumber,
            UserName = create.Email,
            ProfileImage = filePath,
            Language = create.Language,
            AppMode = TemplateMode.Light,
            LockoutEnd = DateTime.Now.AddYears(99),
            LockoutEnabled = true,
            InsertedDate = DateTime.Now,
            InsertedFrom = user.Id
        };

        string errors = string.Empty;

        var result = await userManager.CreateAsync(firstUser, create.Password);
        if (!result.Succeeded)
        {
            foreach (var identityError in result.Errors)
            {
                errors += $"· {identityError.Description} ";
            }
            TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Warning, Title = Resource.Warning, Description = errors });
            return View(create);
        }

        if (create.Roles != null)
        {
            result = await userManager.AddToRolesAsync(firstUser, db.AspNetRoles.Where(a => create.Roles.Contains(a.Id)).Select(a => a.Name).ToList());
            if (!result.Succeeded)
            {
                TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Error, Title = Resource.Error, RawContent = true, Description = "<ul>" + string.Join("", result.Errors.Select(a => "<li>" + a.Description + "</li>").ToArray()) + $"<li>{Resource.RolesAddThroughList}</li>" + "</ul>" });
                return RedirectToAction(nameof(Index));
            }
        }

        TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Success, Title = Resource.Success, Description = Resource.AccountCreatedSuccessfully, Dismissible = true });
        return RedirectToAction(nameof(Index));
    }

    #endregion

    #region Edit

    [HttpGet, Authorize(Policy = "31:e"), Description("Arb Tahiri", "Form to edit a user.")]
    public async Task<IActionResult> Edit(string uIde)
    {
        var userId = CryptoSecurity.Decrypt<string>(uIde);
        var user = await userManager.FindByIdAsync(userId);
        var edit = new Edit
        {
            UserIde = CryptoSecurity.Encrypt(user.Id),
            ImagePath = user.ProfileImage,
            PersonalNumber = user.PersonalNumber,
            Username = user.UserName,
            Firstname = user.FirstName,
            Lastname = user.LastName,
            PhoneNumber = user.PhoneNumber,
            Email = user.Email
        };
        return View(edit);
    }

    [HttpPost, Authorize(Policy = "31:e"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to edit a user.")]
    public async Task<IActionResult> Edit(Edit edit)
    {
        if (!ModelState.IsValid)
        {
            TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Warning, Title = Resource.Warning, Description = Resource.InvalidData, Dismissible = true });
        }

        var userId = CryptoSecurity.Decrypt<string>(edit.UserIde);
        var user = await userManager.FindByIdAsync(userId);
        user.PhoneNumber = edit.PhoneNumber;
        user.ProfileImage = edit.ProfileImage != null ? await SaveImage(environment, edit.ProfileImage, "Users") : null;

        if (user.UserName != edit.Username)
        {
            if (await application.Users.AnyAsync(a => a.UserName == edit.Username))
            {
                TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Error, Description = Resource.UsernameExists });
                return View(edit);
            }

            var userResult = await userManager.SetUserNameAsync(user, edit.Username);
            if (!userResult.Succeeded)
            {
                TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Error, Description = "<ul>" + string.Join("", userResult.Errors.Select(t => "<li>" + t.Description + "</li>").ToArray()) + "</ul>" });
                return View(edit);
            }
        }

        if (user.Email != edit.Email)
        {
            if (await application.Users.AnyAsync(a => a.Email == edit.Email))
            {
                TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Error, Description = Resource.EmailExists });
                return View(edit);
            }

            var emailResult = await userManager.SetEmailAsync(user, edit.Email);
            if (!emailResult.Succeeded)
            {
                TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Error, Description = "<ul>" + string.Join("", emailResult.Errors.Select(t => "<li>" + t.Description + "</li>").ToArray()) + "</ul>" });
                return View(edit);
            }
        }

        var updateResult = await userManager.UpdateAsync(user);
        if (!updateResult.Succeeded)
        {
            TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Error, Title = Resource.Error, RawContent = true, Description = "<ul>" + string.Join("", updateResult.Errors.Select(a => "<li>" + a.Description + "</li>").ToArray()) + "</ul>" });
        }

        TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Success, Title = Resource.Success, Description = Resource.DataUpdatedSuccessfully, Dismissible = true });
        return RedirectToAction(nameof(Index));
    }

    #endregion

    #region Delete

    [HttpPost, Authorize(Policy = "31:d"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to delete a user.")]
    public async Task<IActionResult> Delete(string uIde)
    {
        var userId = CryptoSecurity.Decrypt<string>(uIde);
        var user = await userManager.FindByIdAsync(userId);

        await userManager.SetLockoutEndDateAsync(user, DateTime.Now.AddYears(99));
        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = Resource.DataDeletedSuccessfully });
    }

    #endregion

    #region Check for users

    [Description("Arb Tahiri", "Check if email already exists.")]
    public async Task<IActionResult> CheckEmail(string Email, string UserId)
    {
        if (await db.AspNetUsers.AnyAsync(a => a.Email == Email && (string.IsNullOrEmpty(UserId) || a.Id != CryptoSecurity.Decrypt<string>(UserId))))
        {
            return Json(Resource.EmailExists);
        }
        return Json(true);
    }

    [HttpPost, Description("Arb Tahiri", "Check if username already exists.")]
    public async Task<IActionResult> CheckUsername(string uIde, string Username)
    {
        if (await db.AspNetUsers.AnyAsync(a => a.Id != CryptoSecurity.Decrypt<string>(uIde) && a.UserName == Username))
        {
            return Json(Resource.UsernameExists);
        }
        return Json(true);
    }

    #endregion

    #region Manage users

    #region => Set password

    [HttpGet, Authorize(Policy = "31sp:c"), Description("Arb Tahiri", "Form to set password for user.")]
    public async Task<IActionResult> _SetPassword(string uIde)
    {
        var user = await application.Users.Where(a => a.Id == CryptoSecurity.Decrypt<string>(uIde))
            .Select(a => new SetPassword
            {
                UserIde = uIde,
                Name = $"{a.FirstName} {a.LastName} ({a.Email})"
            }).FirstOrDefaultAsync();
        return PartialView(user);
    }

    [HttpPost, Authorize(Policy = "31sp:c"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to set password for user.")]
    public async Task<IActionResult> SetPassword(SetPassword set)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
        }

        var userId = CryptoSecurity.Decrypt<string>(set.UserIde);
        var user = await userManager.FindByIdAsync(userId);
        await userManager.RemovePasswordAsync(user);
        var result = await userManager.AddPasswordAsync(user, set.NewPassword);
        if (!result.Succeeded)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = $"{Resource.PasswordNotAdded}: " + string.Join(", ", result.Errors.Select(t => t.Description).ToArray()) });
        }
        await userManager.UpdateAsync(user);
        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = $"{Resource.PasswordUpdatedSuccess}" });
    }

    #endregion

    #region => Lock, unlock

    [HttpPost, Authorize(Policy = "31l:c"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to lock the account.")]
    public async Task<IActionResult> Lock(string uIde)
    {
        var userId = CryptoSecurity.Decrypt<string>(uIde);
        var result = await userManager.SetLockoutEndDateAsync(await userManager.FindByIdAsync(userId), DateTime.Now.AddYears(99));
        if (!result.Succeeded)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = $"{Resource.AccountNotLocked}: " + string.Join(", ", result.Errors.Select(t => t.Description).ToArray()).ToLower() });
        }
        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = Resource.AccountLockedSuccess });
    }

    [HttpPost, Authorize(Policy = "31ul:c"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to unlock the account.")]
    public async Task<IActionResult> Unlock(string uIde)
    {
        var userId = CryptoSecurity.Decrypt<string>(uIde);
        var result = await userManager.SetLockoutEndDateAsync(await userManager.FindByIdAsync(userId), DateTime.Now);
        if (!result.Succeeded)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = $"{Resource.AccountNotUnlocked}: " + string.Join(", ", result.Errors.Select(t => t.Description).ToArray()).ToLower() });
        }
        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = Resource.AccountUnlockedSuccess });
    }

    #endregion

    #region => Roles

    [HttpGet, Authorize(Policy = "41r:c"), Description("Arb Tahiri", "Form to add roles to user.")]
    public async Task<IActionResult> _AddRole(string uIde)
    {
        var userId = CryptoSecurity.Decrypt<string>(uIde);
        var user = await db.AspNetUsers.Where(a => a.Id == userId)
            .Select(a => new AddRole
            {
                UserIde = uIde,
                Name = $"{a.FirstName} {a.LastName} ({a.Email})"
            }).FirstOrDefaultAsync();
        return PartialView(user);
    }

    [HttpPost, Authorize(Policy = "41r:c"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to add roles to user.")]
    public async Task<IActionResult> AddRole(AddRole addRole)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
        }

        var currentUser = await userManager.GetUserAsync(HttpContext.User);
        if (!await userManager.CheckPasswordAsync(currentUser, addRole.Password))
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.IncorrectPassword });
        }

        var userToAdd = await userManager.FindByIdAsync(CryptoSecurity.Decrypt<string>(addRole.UserIde));
        var roleToAdd = await db.AspNetRoles.Where(a => addRole.Roles.Contains(a.Id)).Select(a => a.NormalizedName).ToListAsync();

        foreach (var role in addRole.Roles)
        {
            db.RealRole.Add(new RealRole
            {
                UserId = userToAdd.Id,
                RoleId = role,
                InsertedDate = DateTime.Now,
                InsertedFrom = user.Id
            });
        }

        if (!(await userManager.GetRolesAsync(userToAdd)).Any())
        {
            var result = await userManager.AddToRolesAsync(userToAdd, roleToAdd);
            if (!result.Succeeded)
            {
                return Json(new ErrorVM { Status = ErrorStatus.Error, Description = "<ul>" + string.Join("", result.Errors.Select(t => "<li>" + t.Description + "</li>").ToArray()) + $"<li>{Resource.RolesAddThroughList}!</li>" + "</ul>" });
            }
        }

        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = Resource.RoleAddedSuccess });
    }

    #endregion

    #endregion
}
