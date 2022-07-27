using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models.Attendance;
using AMS.Models.Shared;
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

    [Authorize(Policy = "8:m"), Description("Arb Tahiri", "Form to display list of staff attendance.")]
    public IActionResult Index() => View();

    #region List

    [Authorize(Policy = "8:m"), Description("Arb Tahiri", "Form to display list of staff attendance.")]
    public IActionResult SearchStaff() => View();

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "8:r")]
    [Description("Arb Tahiri", "Form to display list of staff attendance.")]
    public async Task<IActionResult> SearchStaff(SearchStaff search)
    {
        var attendance = await db.StaffDepartment
            .Where(a => a.EndDate >= DateTime.Now
                && a.StaffId == (search.SStaffId ?? a.StaffId)
                && a.DepartmentId == (search.SDepartmentId ?? a.DepartmentId)
                && a.StaffTypeId == (search.SStaffTypeId ?? a.StaffTypeId))
            .Select(a => new StaffList
            {
                StaffDepartmentIde = CryptoSecurity.Encrypt(a.StaffDepartmentId),
                PersonalNumber = a.Staff.PersonalNumber,
                FirstName = a.Staff.FirstName,
                LastName = a.Staff.LastName,
                Department = user.Language == LanguageEnum.Albanian ? a.Department.NameSq : a.Department.NameEn,
                StaffType = user.Language == LanguageEnum.Albanian ? a.StaffType.NameSq : a.StaffType.NameEn,
                Absent = a.StaffDepartmentAttendance.Any(a => a.Active && a.InsertedDate.Date == DateTime.Now.Date),
                WorkingSince = !a.StaffDepartmentAttendance.Any() ? 0 : 14
            }).ToListAsync();
        return Json(attendance);
    }

    [Authorize(Policy = "8:m"), Description("Arb Tahiri", "Form to display list of staff attendance.")]
    public IActionResult SearchAttendance() => View();

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "8:r")]
    [Description("Arb Tahiri", "Form to display list of staff attendance.")]
    public async Task<IActionResult> SearchAttendance(SearchAttendance search)
    {
        var attendance = await db.StaffDepartmentAttendance
            .Where(a => a.Active
                && a.StaffDepartment.StaffId == (search.AStaffId ?? a.StaffDepartment.StaffId)
                && a.StaffDepartment.DepartmentId == (search.ADepartmentId ?? a.StaffDepartment.DepartmentId)
                && a.StaffDepartment.StaffTypeId == (search.AStaffTypeId ?? a.StaffDepartment.StaffTypeId)
                && (!search.AStartDate.HasValue ? DateTime.Now.Date : search.AStartDate.Value.Date) <= a.InsertedDate.Date && a.InsertedDate.Date <= (!search.AEndDate.HasValue ? DateTime.Now.Date : search.AEndDate.Value.Date))
            .Select(a => new AttendanceList
            {
                StaffAttendanceIde = CryptoSecurity.Encrypt(a.StaffDepartmentAttendanceId),
                PersonalNumber = a.StaffDepartment.Staff.PersonalNumber,
                FirstName = a.StaffDepartment.Staff.FirstName,
                LastName = a.StaffDepartment.Staff.LastName,
                Date = a.InsertedDate,
                Absent = !a.Absent ? Resource.Yes : Resource.No,
            }).ToListAsync();
        return Json(attendance);
    }

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

    #region Staff attendance

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
