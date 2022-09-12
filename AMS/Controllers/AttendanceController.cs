using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models.Attendance;
using AMS.Models.Shared;
using AMS.Repositories;
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
    private readonly IFunctionRepository function;

    public AttendanceController(IFunctionRepository function,
        AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
        this.function = function;
    }

    [Authorize(Policy = "8:m"), Description("Arb Tahiri", "Form to display list of staff attendance.")]
    public IActionResult Index() => View();

    #region List

    #region Staff

    [Authorize(Policy = "8:m"), Description("Arb Tahiri", "Form to display list of staff attendance.")]
    public IActionResult SearchStaff() => View();

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "8:r")]
    [Description("Arb Tahiri", "Form to display list of staff attendance.")]
    public async Task<IActionResult> SearchStaff(SearchStaff search)
    {
        var staffList = await db.Staff
            .Where(a => a.StaffDepartment.Any(b => b.EndDate.Date >= DateTime.Now.Date)
                && a.StaffId == (search.SStaffId ?? a.StaffId)
                && a.StaffDepartment.Any(b => b.DepartmentId == (search.SDepartmentId ?? b.DepartmentId))
                && a.StaffDepartment.Any(b => b.StaffTypeId == (search.SStaffTypeId ?? b.StaffTypeId)))
            .OrderBy(a => a.FirstName)
            .Select(a => new StaffList
            {
                StaffIde = CryptoSecurity.Encrypt(a.StaffId),
                PersonalNumber = a.PersonalNumber,
                FirstName = a.FirstName,
                LastName = a.LastName,
                BirthDate = a.BirthDate,
                Department = string.Join(", ", a.StaffDepartment.Select(a => user.Language == LanguageEnum.Albanian ? a.Department.NameSq : a.Department.NameEn).ToList()),
                Attended = a.StaffAttendance.Any(a => a.Active && a.InsertedDate.Date == DateTime.Now.Date)
            }).ToListAsync();
        return Json(staffList);
    }

    #endregion

    #region Attendance

    [Authorize(Policy = "8:m"), Description("Arb Tahiri", "Form to display list of staff attendance.")]
    public IActionResult SearchAttendance() => View();

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "8:r")]
    [Description("Arb Tahiri", "Form to display list of staff attendance.")]
    public async Task<IActionResult> SearchAttendance(SearchAttendance search)
    {
        var attendance = (await function.StaffConsecutiveDays(search.AStaffId, search.ADepartmentId, search.AStaffTypeId, search.AStartDate, search.AEndDate, user.Language))
            .OrderByDescending(a => a.EndDate)
            .Select(a => new StaffList
            {
                PersonalNumber = a.PersonalNumber,
                FirstName = a.FirstName,
                LastName = a.LastName,
                Department = a.Department,
                StaffType = a.StaffType,
                StartDate = a.StartDate,
                EndDate = a.EndDate,
                WorkingSince = a.WorkingSince
            }).ToList();

        return Json(attendance);
    }

    #endregion

    #endregion

    #region Change attendance

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "8:c")]
    [Description("Arb Tahiri", "Action to change attendance of staff.")]
    public async Task<IActionResult> ChangeAttendance(string ide, bool attended)
    {
        if (string.IsNullOrEmpty(ide))
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Title = Resource.Warning, Description = Resource.InvalidData });
        }

        int staffId = CryptoSecurity.Decrypt<int>(ide);
        var attendance = await db.StaffAttendance.FirstOrDefaultAsync(a => a.Active && a.StaffId == staffId && a.InsertedDate.Date == DateTime.Now.Date);
        if (attendance is null)
        {
            db.StaffAttendance.Add(new StaffAttendance
            {
                StaffId = staffId,
                Absent = attended,
                Active = true,
                InsertedDate = DateTime.Now,
                InsertedFrom = user.Id,
            });
        }
        else
        {
            attendance.Active = false;
            attendance.UpdatedDate = DateTime.Now;
            attendance.UpdatedFrom = user.Id;
            attendance.UpdatedNo = UpdateNo(attendance.UpdatedNo);

            db.StaffAttendance.Add(new StaffAttendance
            {
                StaffId = staffId,
                Absent = attended,
                Active = true,
                InsertedDate = DateTime.Now,
                InsertedFrom = user.Id,
            });
        }
        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Title = Resource.Success, Description = Resource.AttendanceChangedSuccessfully });
    }

    #endregion

    #region Staff attendance reason

    [HttpGet, Authorize(Policy = "8:e")]
    [Description("Arb Tahiri", "Form to add absent type and add description for staff.")]
    public async Task<IActionResult> StaffAttendance(string ide)
    {
        if (string.IsNullOrEmpty(ide))
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Title = Resource.Warning, Description = Resource.InvalidData });
        }

        int attendanceId = CryptoSecurity.Decrypt<int>(ide);
        var attendance = await db.StaffAttendance
            .Where(a => a.StaffAttendanceId == attendanceId)
            .Select(a => new AttendanceDetails
            {
                AttendanceIde = ide,
                StaffName = $"{a.Staff.FirstName} {a.Staff.LastName} - ({a.Staff.PersonalNumber})",
                AttendanceDate = a.InsertedDate.ToString("dd/MM/yyyy"),
                AbsentTypeId = a.AbsentTypeId,
                Description = a.Description
            }).FirstOrDefaultAsync();
        return PartialView(attendance);
    }

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "8:e")]
    [Description("Arb Tahiri", "Action to add absent type and add description for staff.")]
    public async Task<IActionResult> StaffAttendance(AttendanceDetails attendance)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Title = Resource.Warning, Description = Resource.InvalidData });
        }

        int attendanceId = CryptoSecurity.Decrypt<int>(attendance.AttendanceIde);
        var staffAttendance = await db.StaffAttendance.FirstOrDefaultAsync(a => a.StaffAttendanceId == attendanceId);
        staffAttendance.AbsentTypeId = attendance.AbsentTypeId;
        staffAttendance.Description = attendance.Description;
        staffAttendance.UpdatedDate = DateTime.Now;
        staffAttendance.UpdatedFrom = user.Id;
        staffAttendance.UpdatedNo = UpdateNo(staffAttendance.UpdatedNo);

        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Title = Resource.Success, Description = Resource.DataUpdatedSuccessfully });
    }

    #endregion
}
