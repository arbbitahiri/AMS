using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models.Attendance;
using AMS.Resources;
using AMS.Utilities;
using AMS.Utilities.General;
using AMS.Utilities.Security;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AMS.Controllers;

public class AttendanceController : BaseController
{
    public AttendanceController(AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
    }

    [Authorize("8:m"), Description("Arb Tahiri", "Form to display list of staff attendance.")]
    public IActionResult Index() => View();

    [Authorize("8:m"), Description("Arb Tahiri", "Form to display list of staff attendance.")]
    public IActionResult SearchStaff() => View();

    [HttpPost, ValidateAntiForgeryToken, Authorize("8:r")]
    [Description("Arb Tahiri", "Form to display list of staff attendance.")]
    public async Task<IActionResult> StaffList(SearchStaff search)
    {
        var attendance = await db.StaffDepartment
            .Where(a => a.EndDate >= DateTime.Now
                && a.StaffId == search.SStaffId
                && a.DepartmentId == search.SDepartmentId
                && a.StaffTypeId == search.SStaffTypeId)
            .Select(a => new StaffList
            {
                StaffDepartmentIde = CryptoSecurity.Encrypt(a.StaffDepartmentId),
                PersonalNumber = a.Staff.PersonalNumber,
                FirstName = a.Staff.FirstName,
                LastName = a.Staff.LastName,
                Department = user.Language == LanguageEnum.Albanian ? a.Department.NameSq : a.Department.NameEn,
                StaffType = user.Language == LanguageEnum.Albanian ? a.StaffType.NameSq : a.StaffType.NameEn,
                Absent = a.StaffDepartmentAttendance.Any(a => a.Active && a.Date.Date == DateTime.Now)
            }).ToListAsync();
        return Json(attendance);
    }

    [Authorize("8:m"), Description("Arb Tahiri", "Form to display list of staff attendance.")]
    public IActionResult SearchAttendance() => View();

    [HttpPost, ValidateAntiForgeryToken, Authorize("8:r")]
    [Description("Arb Tahiri", "Form to display list of staff attendance.")]
    public async Task<IActionResult> StaffAttendance(SearchAttendance search)
    {
        var attendance = await db.StaffDepartmentAttendance
            .Where(a => a.Active
                && a.StaffDepartment.StaffId == search.AStaffId
                && a.StaffDepartment.DepartmentId == search.ADepartmentId
                && a.StaffDepartment.StaffTypeId == search.AStaffTypeId
                && search.AStartDate <= a.InsertedDate && a.InsertedDate <= search.AEndDate)
            .Select(a => new AttendanceList
            {
                StaffAttendanceIde = CryptoSecurity.Encrypt(a.StaffDepartmentAttendanceId),
                PersonalNumber = a.StaffDepartment.Staff.PersonalNumber,
                FirstName = a.StaffDepartment.Staff.FirstName,
                LastName = a.StaffDepartment.Staff.LastName,
                Department = user.Language == LanguageEnum.Albanian ? a.StaffDepartment.Department.NameSq : a.StaffDepartment.Department.NameEn,
                StaffType = user.Language == LanguageEnum.Albanian ? a.StaffDepartment.StaffType.NameSq : a.StaffDepartment.StaffType.NameEn,
                Date = a.Date,
                Absent = !a.Absent ? Resource.Yes : Resource.No,
                AbsentType = user.Language == LanguageEnum.Albanian ? a.AbsentType.NameSq : a.AbsentType.NameEn
            }).ToListAsync();
        return Json(attendance);
    }
}
