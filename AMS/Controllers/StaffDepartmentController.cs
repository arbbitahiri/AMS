using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models.Shared;
using AMS.Models.StaffDepartment;
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

public class StaffDepartmentController : BaseController
{
    private readonly IFunctionRepository function;

    public StaffDepartmentController(IFunctionRepository function,
        AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
        this.function = function;
    }

    #region List

    [Authorize(Policy = "4:m"), Description("Arb Tahiri", "Form to search for history of staff.")]
    public IActionResult Index() => View();

    [HttpPost, Authorize(Policy = "4:m"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to search for history of staff.")]
    public async Task<IActionResult> Search(Search search)
    {
        var staffList = (await function.StaffListHistory(search.StaffId, search.DepartmentId, search.StaffTypeId, search.StartDate, search.EndDate, search.PersonalNumber, search.FirstName, search.LastName, search.BirthDate, search.StatusTypeId, search.AdvancedSearch, user.Language))
            .Select(a => new StaffList
            {
                StaffDepartmentIde = CryptoSecurity.Encrypt(a.StaffDepartmentId),
                StaffIde = CryptoSecurity.Encrypt(a.StaffId),
                PersonalNumber = a.PersonalNumber,
                FirstName = a.FirstName,
                LastName = a.LastName,
                DateOfBirth = a.DateOfBirth,
                Department = a.Department,
                StaffType = a.StaffType,
                StartDate = a.StartDate,
                EndDate = a.EndDate,
                Status = a.StatusType
            }).ToList();
        return Json(staffList);
    }

    #endregion

    #region Add staff

    [Authorize(Policy = "4:c"), Description("Arb Tahiri", "Form to add staff again to department.")]
    public async Task<IActionResult> _AddStaff(string ide)
    {
        var staffDepartmentId = CryptoSecurity.Decrypt<int>(ide);
        var staff = await db.StaffDepartment
            .Where(a => a.StaffDepartmentId == staffDepartmentId)
            .Select(a => new AddStaff
            {
                StaffIde = ide,
                StaffName = $"{a.Staff.FirstName} {a.Staff.LastName} - ({a.Staff.PersonalNumber})",
                DepartmentId = a.DepartmentId,
                StaffTypeId = a.StaffTypeId,
                StartDate = a.StartDate,
                EndDate= a.EndDate,
                Description = a.Description
            }).FirstOrDefaultAsync();
        return PartialView(staff);
    }

    [Authorize(Policy = "4:c"), Description("Arb Tahiri", "Form to add staff again to department.")]
    public async Task<IActionResult> AddStaff(AddStaff addStaff)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
        }

        var staffId = CryptoSecurity.Decrypt<int>(addStaff.StaffIde);

        var staffRegistrationStatus = await db.StaffRegistrationStatus.FirstOrDefaultAsync(a => a.Active && a.StaffId == staffId);
        staffRegistrationStatus.Active = false;
        staffRegistrationStatus.UpdatedDate = DateTime.Now;
        staffRegistrationStatus.UpdatedFrom = user.Id;
        staffRegistrationStatus.UpdatedNo = UpdateNo(staffRegistrationStatus.UpdatedNo);

        db.StaffRegistrationStatus.Add(new StaffRegistrationStatus
        {
            StaffId = staffId,
            StatusTypeId = (int)Status.Finished,
            Active = true,
            InsertedDate = DateTime.Now,
            InsertedFrom = user.Id
        });

        db.StaffDepartment.Add(new StaffDepartment
        {
            StaffId = staffId,
            DepartmentId = addStaff.DepartmentId,
            StaffTypeId = addStaff.StaffTypeId,
            StartDate = addStaff.StartDate,
            EndDate = addStaff.EndDate,
            Description = addStaff.Description,
            InsertedDate = DateTime.Now,
            InsertedFrom = user.Id
        });

        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = Resource.DataRegisteredSuccessfully });
    }

    #endregion

    #region Report

    [HttpPost, ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Report for list of staff depending of the search.")]
    public async Task<IActionResult> Report(Search search, ReportType reportType)
    {
        var staffList = await db.StaffDepartment
            .Where(a => a.EndDate.Date <= DateTime.Now.Date
                && a.StaffId == (search.StaffId ?? a.StaffId)
                && a.DepartmentId == (search.DepartmentId ?? a.DepartmentId)
                && a.StaffTypeId == (search.StaffTypeId ?? a.StaffTypeId)
                && (!search.StartDate.HasValue || a.StartDate.Date == search.StartDate.Value.Date)
                && (!search.EndDate.HasValue || a.EndDate.Date == search.EndDate.Value.Date)
                && a.Staff.StaffRegistrationStatus.Any(b => b.Active && b.StatusTypeId != (int)Status.Processing && b.StatusTypeId == (search.StatusTypeId ?? b.StatusTypeId)))
            .AsSplitQuery()
            .OrderByDescending(a => a.EndDate.Date)
            .Select(a => new ReportVM
            {
                PersonalNumber = a.Staff.PersonalNumber,
                FirstName = a.Staff.FirstName,
                LastName = a.Staff.LastName,
                DateOfBirth = a.Staff.BirthDate.ToString("dd/MM/yyyy"),
                Department = user.Language == LanguageEnum.Albanian ? a.Department.NameSq : a.Department.NameEn,
                StaffType = user.Language == LanguageEnum.Albanian ? a.StaffType.NameSq : a.StaffType.NameEn,
                StartDate = a.StartDate.ToString("dd/MM/yyyy"),
                EndDate = a.EndDate.ToString("dd/MM/yyyy"),
                Status = a.Staff.StaffRegistrationStatus.Where(a => a.Active).Select(a => user.Language == LanguageEnum.Albanian ? a.StatusType.NameSq : a.StatusType.NameEn).FirstOrDefault()
            }).ToListAsync();

        var dataSource = new List<ReportDataSource>() { new ReportDataSource("StaffDetails", staffList.OrderBy(a => a.FirstName).ThenBy(a => a.LastName).ToList()) };
        var parameters = new List<ReportParameter>()
        {
            new ReportParameter("PrintedFrom", $"{user.FirstName} {user.LastName}"),
            new ReportParameter("PersonalNumber", Resource.PersonalNumber),
            new ReportParameter("FirstName", Resource.Firstname),
            new ReportParameter("LastName", Resource.Lastname),
            new ReportParameter("BirthDate", Resource.Birthdate),
            new ReportParameter("Department", Resource.Department),
            new ReportParameter("StaffType", Resource.StaffType),
            new ReportParameter("StartDate", Resource.StartDate),
            new ReportParameter("EndDate", Resource.EndDate),
            new ReportParameter("Status", Resource.StatusType),
            new ReportParameter("ListOfStaff", Resource.StaffList),
            new ReportParameter("AMS", Resource.AMSTitle)
        };

        var reportByte = RDLCReport.GenerateReport("StaffDepartmentList.rdl", dataSource, parameters, reportType, ReportOrientation.Landscape);
        string contentType = reportType switch
        {
            ReportType.PDF => "application/pdf",
            ReportType.Excel => "application/ms-excel",
            ReportType.Word => "application/msword",
            _ => "application/pdf"
        };
        string fileName = reportType switch
        {
            ReportType.PDF => Resource.StaffList,
            ReportType.Excel => $"{Resource.StaffList}.xlsx",
            ReportType.Word => $"{Resource.StaffList}.docx",
            _ => Resource.StaffList
        };
        return reportType == ReportType.PDF ?
            File(reportByte, contentType) :
            File(reportByte, contentType, fileName);
    }

    #endregion

    #region Remote

    [Description("Arb Tahiri", "Method to check end date and start date.")]
    public IActionResult CheckDates(string StartDate, string EndDate)
    {
        var startDate = !string.IsNullOrEmpty(StartDate) ? DateTime.ParseExact(StartDate, "dd/MM/yyyy", null) : new DateTime();
        var endDate = !string.IsNullOrEmpty(EndDate) ? DateTime.ParseExact(EndDate, "dd/MM/yyyy", null) : new DateTime();

        if (startDate <= endDate)
        {
            return Json(true);
        }
        else
        {
            return Json(false);
        }
    }

    #endregion
}
