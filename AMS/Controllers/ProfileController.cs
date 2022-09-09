using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models.Profile;
using AMS.Repositories;
using AMS.Utilities;
using AMS.Utilities.General;
using AMS.Utilities.Security;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AMS.Controllers;

public class ProfileController : BaseController
{
    private readonly IFunctionRepository function;

    public ProfileController(IFunctionRepository function,
        AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
        this.function = function;
    }

    [HttpGet, Authorize(Policy = "9:m")]
    [Description("Arb Tahiri", "Form to display staff profile.")]
    public async Task<IActionResult> Index(string ide)
    {
        var staffId = !string.IsNullOrEmpty(ide) ? CryptoSecurity.Decrypt<int>(ide) : await db.Staff.Where(a => a.UserId == user.Id).Select(a => a.StaffId).FirstOrDefaultAsync();

        var profile = await db.Staff.Where(a => a.StaffId == staffId)
            .Select(a => new ProfileVM
            {
                StaffIde = CryptoSecurity.Encrypt(a.StaffId),
                PersonalNumber = a.PersonalNumber,
                FirstName = a.FirstName,
                LastName = a.LastName,
                ProfileImage = a.User.ProfileImage,
                Role = string.Join(", ", a.User.Role.Select(a => user.Language == LanguageEnum.Albanian ? a.NameSq : a.NameEn).ToList()),
                StaffType = string.Join(", ", a.StaffDepartment.Select(a => user.Language == LanguageEnum.Albanian ? a.StaffType.NameSq : a.StaffType.NameEn).ToList()),
                Department = string.Join(", ", a.StaffDepartment.Select(a => user.Language == LanguageEnum.Albanian ? a.Department.NameSq : a.Department.NameEn).ToList()),
                Email = a.Email,
                PhoneNumber = string.IsNullOrEmpty(a.PhoneNumber) ? "///" : $"+{a.PhoneNumber}",
                Address = a.Address,
                City = user.Language == LanguageEnum.Albanian ? a.City.NameSq : a.City.NameEn,
                Country = user.Language == LanguageEnum.Albanian ? a.Country.NameSq : a.Country.NameEn,
                PostalCode = a.PostalCode
            }).FirstOrDefaultAsync();
        return View(profile);
    }

    [HttpGet, Description("Arb Tahiri", "Form to display list of attendance for staff.")]
    public async Task<IActionResult> _Attendance(string ide)
    {
        int staffId = CryptoSecurity.Decrypt<int>(ide);
        var attendances = (await function.StaffConsecutiveDays(staffId, null, null, user.Language))
            .Select(a => new AttendanceDetails
            {
                StartDate = a.StartDate,
                EndDate = a.EndDate,
                WorkingSince = a.WorkingSince
            }).ToList();

        var attendance = new AttendanceVM
        {
            StaffIde = ide,
            Attendances = attendances.OrderByDescending(a => a.EndDate).ToList()
        };
        return PartialView(attendance);
    }

    [HttpGet, Description("Arb Tahiri", "Form to display list of departments for staff.")]
    public async Task<IActionResult> _Department(string ide)
    {
        int staffId = CryptoSecurity.Decrypt<int>(ide);
        var departments = await db.StaffDepartment
            .Where(a => a.StaffId == staffId)
            .OrderByDescending(a => a.EndDate)
            .Select(a => new DepartmentDetails
            {
                StaffDepartmentIde = CryptoSecurity.Encrypt(a.StaffDepartmentId),
                Department = user.Language == LanguageEnum.Albanian ? a.Department.NameSq : a.Department.NameEn,
                StaffType = user.Language == LanguageEnum.Albanian ? a.StaffType.NameSq : a.StaffType.NameEn,
                StartDate = a.StartDate,
                EndDate = a.EndDate
            }).ToListAsync();

        var department = new DepartmentVM
        {
            StaffIde = ide,
            Departments = departments
        };
        return PartialView(department);
    }

    [HttpGet, Description("Arb Tahiri", "Form to display list of documents for staff.")]
    public async Task<IActionResult> _Document(string ide)
    {
        int staffId = CryptoSecurity.Decrypt<int>(ide);
        var documents = await db.StaffDocument
            .Where(a => a.Active && a.StaffId == staffId)
            .Select(a => new DocumentDetails
            {
                StaffDocumentIde = CryptoSecurity.Encrypt(a.StaffDocumentId),
                Title = a.Title,
                Path = a.Path,
                PathExtension = Path.GetExtension(a.Path),
                DocumentType = user.Language == LanguageEnum.Albanian ? a.DocumentType.NameSq : a.DocumentType.NameEn,
                Description = a.Description
            }).ToListAsync();

        var document = new DocumentVM
        {
            StaffIde = ide,
            Documents = documents
        };
        return PartialView(document);
    }
}
