using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models.Attendance;
using AMS.Models.Shared;
using AMS.Repositories;
using AMS.Resources;
using AMS.Utilities;
using AMS.Utilities.General;
using AMS.Utilities.RDLC;
using AMS.Utilities.Security;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Reporting.NETCore;

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
        var staffList = (await function.StaffConsecutiveDays(search.SStaffId, search.SDepartmentId, search.SStaffTypeId, user.Language))
            .Select(a => new StaffList
            {
                StaffIde = CryptoSecurity.Encrypt(a.StaffId),
                PersonalNumber = a.PersonalNumber,
                FirstName = a.FirstName,
                LastName = a.LastName,
                BirthDate = a.BirthDate,
                Department = a.Department,
                WorkingSince = a.WorkingSince,
                Attended = a.Attended
            }).ToList();
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
        var attendance = (await function.AttendanceConsecutiveDays(search.AStaffId, search.ADepartmentId, search.AStaffTypeId, search.AStartDate, search.AEndDate, user.Language))
            .OrderByDescending(a => a.EndDate)
            .Select(a => new StaffList
            {
                StaffIde = CryptoSecurity.Encrypt(a.StaffId),
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
                Absent = !attended,
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
                Absent = !attended,
                Active = true,
                InsertedDate = DateTime.Now,
                InsertedFrom = user.Id,
            });
        }
        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Title = Resource.Success, Description = Resource.AttendanceChangedSuccessfully });
    }

    #endregion

    #region Attendance details

    [HttpGet, Authorize(Policy = "8:h")]
    [Description("Arb Tahiri", "Form to display staff attendance details.")]
    public async Task<IActionResult> History(string ide, DateTime startDate, DateTime endDate)
    {
        var staffId = CryptoSecurity.Decrypt<int>(ide);

        var attendance = await db.StaffAttendance
            .Where(a => a.StaffId == staffId && startDate.Date <= a.InsertedDate && a.InsertedDate <= endDate.Date)
            .GroupBy(a => a.StaffId)
            .Select(a => new AttendanceDetails
            {
                Name = $"{a.Select(b => b.Staff.FirstName).FirstOrDefault()} {a.Select(b => b.Staff.LastName).FirstOrDefault()} - ({a.Select(b => b.Staff.PersonalNumber).FirstOrDefault()})",
                AttendanceList = a.Select(b => new AttendanceList
                {
                    StaffAttendanceIde = CryptoSecurity.Encrypt(b.StaffAttendanceId),
                    Date = b.InsertedDate,
                    Absent = b.Absent ? Resource.Yes : Resource.No
                }).ToList()
            }).FirstOrDefaultAsync();
        return PartialView(attendance);
    }

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
            .Select(a => new AbsentDetails
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
    public async Task<IActionResult> StaffAttendance(AbsentDetails attendance)
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

    #region Reports

    [HttpPost, ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Report for list of staff depending of the search.")]
    public async Task<IActionResult> ReportStaff(SearchStaff search, ReportType stype)
    {
        var staffList = await db.Staff
            .Where(a => a.StaffDepartment.Any(b => b.EndDate.Date >= DateTime.Now.Date)
                && a.StaffId == (search.SStaffId ?? a.StaffId)
                && a.StaffDepartment.Any(b => b.DepartmentId == (search.SDepartmentId ?? b.DepartmentId))
                && a.StaffDepartment.Any(b => b.StaffTypeId == (search.SStaffTypeId ?? b.StaffTypeId)))
            .OrderBy(a => a.FirstName)
            .Select(a => new ReportStaff
            {
                PersonalNumber = a.PersonalNumber,
                FirstName = a.FirstName,
                LastName = a.LastName,
                BirthDate = a.BirthDate.ToString("dd/MM/yyyy"),
                Department = string.Join(", ", a.StaffDepartment.Select(a => user.Language == LanguageEnum.Albanian ? a.Department.NameSq : a.Department.NameEn).ToList()),
                Attended = a.StaffAttendance.Any(a => a.Active && a.InsertedDate.Date == DateTime.Now.Date) ? Resource.Yes : Resource.No
            }).ToListAsync();

        var dataSource = new List<ReportDataSource>() { new ReportDataSource("StaffDetails", staffList) };
        var parameters = new List<ReportParameter>()
        {
            new ReportParameter("PrintedFrom", $"{user.FirstName} {user.LastName}"),
            new ReportParameter("Today", DateTime.Now.ToString("dd/MM/yyyy")),
            new ReportParameter("PersonalNumber", Resource.PersonalNumber),
            new ReportParameter("FirstName", Resource.Firstname),
            new ReportParameter("LastName", Resource.Lastname),
            new ReportParameter("BirthDate", Resource.Birthdate),
            new ReportParameter("Department", Resource.Department),
            new ReportParameter("Attended", Resource.Attendance),
            new ReportParameter("ListOfStaff", Resource.StaffList),
            new ReportParameter("AMS", Resource.AMSTitle)
        };

        var reportByte = RDLCReport.GenerateReport("StaffAttended.rdl", dataSource, parameters, stype, ReportOrientation.Portrait);
        string contentType = stype switch
        {
            ReportType.PDF => "application/pdf",
            ReportType.Excel => "application/ms-excel",
            ReportType.Word => "application/msword",
            _ => "application/pdf"
        };
        string fileName = stype switch
        {
            ReportType.PDF => Resource.StaffList,
            ReportType.Excel => $"{Resource.StaffList}.xlsx",
            ReportType.Word => $"{Resource.StaffList}.docx",
            _ => Resource.StaffList
        };
        return stype == ReportType.PDF ?
            File(reportByte, contentType) :
            File(reportByte, contentType, fileName);
    }

    [HttpPost, ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Report for list of staff depending of the search.")]
    public async Task<IActionResult> ReportAttendance(SearchAttendance search, ReportType atype)
    {
        var attendance = (await function.AttendanceConsecutiveDays(search.AStaffId, search.ADepartmentId, search.AStaffTypeId, search.AStartDate, search.AEndDate, user.Language))
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

        var dataSource = new List<ReportDataSource>() { new ReportDataSource("StaffDetails", attendance) };
        var parameters = new List<ReportParameter>()
        {
            new ReportParameter("PrintedFrom", $"{user.FirstName} {user.LastName}"),
            new ReportParameter("PersonalNumber", Resource.PersonalNumber),
            new ReportParameter("FirstName", Resource.Firstname),
            new ReportParameter("LastName", Resource.Lastname),
            new ReportParameter("BirthDate", Resource.Birthdate),
            new ReportParameter("Gender", Resource.Gender),
            new ReportParameter("Email", Resource.Email),
            new ReportParameter("PhoneNumber", Resource.PhoneNumber),
            new ReportParameter("ListOfStaff", Resource.StaffList),
            new ReportParameter("AMS", Resource.AMSTitle),
            new ReportParameter("City", Resource.City)
        };

        var reportByte = RDLCReport.GenerateReport("StaffAttendance.rdl", dataSource, parameters, atype, ReportOrientation.Portrait);
        string contentType = atype switch
        {
            ReportType.PDF => "application/pdf",
            ReportType.Excel => "application/ms-excel",
            ReportType.Word => "application/msword",
            _ => "application/pdf"
        };
        string fileName = atype switch
        {
            ReportType.PDF => Resource.AttendanceList,
            ReportType.Excel => $"{Resource.AttendanceList}.xlsx",
            ReportType.Word => $"{Resource.AttendanceList}.docx",
            _ => Resource.AttendanceList
        };
        return atype == ReportType.PDF ?
            File(reportByte, contentType) :
            File(reportByte, contentType, fileName);
    }

    #endregion
}
