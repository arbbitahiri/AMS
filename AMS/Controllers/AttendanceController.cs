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
using System.Diagnostics.CodeAnalysis;

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
        var attendance = (await function.StaffConsecutiveDays(search.SStaffId, search.SDepartmentId, search.SStaffId, user.Language))
            .OrderByDescending(a => a.EndDate)
            .Select(a => new StaffList
            {
                StaffDepartmentIde = CryptoSecurity.Encrypt(a.StaffDepartmentId),
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

    #region Attendance

    [Authorize(Policy = "8:m"), Description("Arb Tahiri", "Form to display list of staff attendance.")]
    public IActionResult SearchAttendance() => View();

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "8:r")]
    [Description("Arb Tahiri", "Form to display list of staff attendance.")]
    public async Task<IActionResult> SearchAttendance(SearchAttendance search)
    {
        var attendance = (await function.StaffConsecutiveDays(search.AStaffId, search.ADepartmentId, search.AStaffId, user.Language))
            .OrderByDescending(a => a.EndDate)
            .Select(a => new StaffList
            {
                StaffDepartmentIde = CryptoSecurity.Encrypt(a.StaffDepartmentId),
                PersonalNumber = a.PersonalNumber,
                FirstName = a.FirstName,
                LastName = a.LastName,
                StartDate = a.StartDate,
                WorkingSince = a.WorkingSince
            }).Distinct(new DistinctComparer()).ToList();
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

        int staffDepartmentId = CryptoSecurity.Decrypt<int>(ide);
        var attendance = await db.StaffDepartmentAttendance.FirstOrDefaultAsync(a => a.Active && a.StaffDepartmentId == staffDepartmentId && a.InsertedDate.Date == DateTime.Now.Date);
        if (attendance is null)
        {
            db.StaffDepartmentAttendance.Add(new StaffDepartmentAttendance
            {
                StaffDepartmentId = staffDepartmentId,
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

            db.StaffDepartmentAttendance.Add(new StaffDepartmentAttendance
            {
                StaffDepartmentId = staffDepartmentId,
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
        var attendance = await db.StaffDepartmentAttendance
            .Where(a => a.StaffDepartmentAttendanceId == attendanceId)
            .Select(a => new StaffAttendance
            {
                AttendanceIde = ide,
                StaffName = $"{a.StaffDepartment.Staff.FirstName} {a.StaffDepartment.Staff.LastName} - ({a.StaffDepartment.Staff.PersonalNumber})",
                AttendanceDate = a.InsertedDate.ToString("dd/MM/yyyy"),
                AbsentTypeId = a.AbsentTypeId,
                Description = a.Description
            }).FirstOrDefaultAsync();
        return PartialView(attendance);
    }

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "8:e")]
    [Description("Arb Tahiri", "Action to add absent type and add description for staff.")]
    public async Task<IActionResult> StaffAttendance(StaffAttendance attendance)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Title = Resource.Warning, Description = Resource.InvalidData });
        }

        int attendanceId = CryptoSecurity.Decrypt<int>(attendance.AttendanceIde);
        var staffAttendance = await db.StaffDepartmentAttendance.FirstOrDefaultAsync(a => a.StaffDepartmentAttendanceId == attendanceId);
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

public class DistinctComparer : IEqualityComparer<StaffList>
{
    public bool Equals(StaffList x, StaffList y)
    {
        return x.StaffDepartmentIde == y.StaffDepartmentIde && x.EndDate >= y.EndDate;
    }

    public int GetHashCode([DisallowNull] StaffList obj)
    {
        return obj.StaffDepartmentIde.GetHashCode();
    }
}
