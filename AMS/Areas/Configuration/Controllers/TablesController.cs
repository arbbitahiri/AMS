using AMS.Areas.Configuration.Models.Tables;
using AMS.Controllers;
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

namespace AMS.Areas.Configuration.Controllers;

public class TablesController : BaseController
{
    public TablesController(AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
    }

    [Authorize(Policy = "22:m"), Description("Arb Tahiri", "Entry form.")]
    public IActionResult Index() => View();

    #region List

    [Authorize(Policy = "22:r"), Description("Arb Tahiri", "List of lookup tables.")]
    public IActionResult _LookUpTables()
    {
        var tables = new List<TableName>()
        {
            new TableName() { Table = LookUpTable.Absent, Title = Resource.AbsentType },
            new TableName() { Table = LookUpTable.City, Title = Resource.City },
            new TableName() { Table = LookUpTable.Country, Title = Resource.Country },
            new TableName() { Table = LookUpTable.Department, Title = Resource.Department },
            new TableName() { Table = LookUpTable.Document, Title = Resource.DocumentType },
            new TableName() { Table = LookUpTable.Staff, Title = Resource.StaffType },
            new TableName() { Table = LookUpTable.Status, Title = Resource.StatusType },
        };

        return PartialView(tables);
    }

    [Authorize(Policy = "22:r"), Description("Arb Tahiri", "List of data of look up tables")]
    public async Task<IActionResult> _LookUpData(LookUpTable table, string title)
    {
        var dataList = table switch
        {
            LookUpTable.Absent => await db.AbsentType.Select(a => new DataList
            {
                Ide = CryptoSecurity.Encrypt(a.AbsentTypeId),
                NameSQ = a.NameSq,
                NameEN = a.NameEn,
                Active = a.Active
            }).ToListAsync(),
            LookUpTable.City => await db.City.Select(a => new DataList
            {
                Ide = CryptoSecurity.Encrypt(a.CityId),
                NameSQ = a.NameSq,
                NameEN = a.NameEn,
                Active = a.Active
            }).ToListAsync(),
            LookUpTable.Country => await db.Country.Select(a => new DataList
            {
                Ide = CryptoSecurity.Encrypt(a.CountryId),
                NameSQ = a.NameSq,
                NameEN = a.NameEn,
                Active = a.Active
            }).ToListAsync(),
            LookUpTable.Department => await db.Department.Select(a => new DataList
            {
                Ide = CryptoSecurity.Encrypt(a.DepartmentId),
                NameSQ = a.NameSq,
                NameEN = a.NameEn,
                Active = a.Active
            }).ToListAsync(),
            LookUpTable.Document => await db.DocumentType.Select(a => new DataList
            {
                Ide = CryptoSecurity.Encrypt(a.DocumentTypeId),
                NameSQ = a.NameSq,
                NameEN = a.NameEn,
                Active = a.Active
            }).ToListAsync(),
            LookUpTable.Staff => await db.StaffType.Select(a => new DataList
            {
                Ide = CryptoSecurity.Encrypt(a.StaffTypeId),
                NameSQ = a.NameSq,
                NameEN = a.NameEn,
                Active = true
            }).ToListAsync(),
            LookUpTable.Status => await db.StatusType.Select(a => new DataList
            {
                Ide = CryptoSecurity.Encrypt(a.StatusType1),
                NameSQ = a.NameSq,
                NameEN = a.NameEn,
                Active = a.Active
            }).ToListAsync(),
            _ => await db.AbsentType.Select(a => new DataList
            {
                Ide = CryptoSecurity.Encrypt(a.AbsentTypeId),
                NameSQ = a.NameSq,
                NameEN = a.NameEn,
                Active = a.Active
            }).ToListAsync(),
        };
        return PartialView(new TableData() { DataList = dataList, Table = table, Title = title });
    }

    #endregion

    #region Create

    [Authorize(Policy = "22:c"), Description("Arb Tahiri", "Form to create data for a look up table.")]
    public IActionResult _Create(LookUpTable table, string title) => PartialView(new Create { Table = table, Title = title });

    [HttpPost, Authorize(Policy = "22:c"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to create data for a look up table.")]
    public async Task<IActionResult> Create(Create create)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM() { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
        }

        var error = new ErrorVM() { Status = ErrorStatus.Success, Description = Resource.DataRegisteredSuccessfully };

        switch (create.Table)
        {
            case LookUpTable.Absent:
                db.AbsentType.Add(new AbsentType
                {
                    NameSq = create.NameSQ,
                    NameEn = create.NameEN,
                    Active = true,
                    InsertedDate = DateTime.Now,
                    InsertedFrom = user.Id
                });
                break;
            case LookUpTable.City:
                db.City.Add(new City
                {
                    NameSq = create.NameSQ,
                    NameEn = create.NameEN,
                    Active = true,
                    InsertedDate = DateTime.Now,
                    InsertedFrom = user.Id
                });
                break;
            case LookUpTable.Country:
                db.Country.Add(new Country
                {
                    NameSq = create.NameSQ,
                    NameEn = create.NameEN,
                    Active = true,
                    InsertedDate = DateTime.Now,
                    InsertedFrom = user.Id
                });
                break;
            case LookUpTable.Department:
                db.Department.Add(new Department
                {
                    NameSq = create.NameSQ,
                    NameEn = create.NameEN,
                    Active = true,
                    InsertedDate = DateTime.Now,
                    InsertedFrom = user.Id
                });
                break;
            case LookUpTable.Document:
                db.DocumentType.Add(new DocumentType
                {
                    NameSq = create.NameSQ,
                    NameEn = create.NameEN,
                    Active = true,
                    InsertedDate = DateTime.Now,
                    InsertedFrom = user.Id
                });
                break;
            case LookUpTable.Staff:
                db.StaffType.Add(new StaffType
                {
                    NameSq = create.NameSQ,
                    NameEn = create.NameEN,
                    Active = true,
                    InsertedDate = DateTime.Now,
                    InsertedFrom = user.Id
                });
                break;
            case LookUpTable.Status:
                db.StatusType.Add(new StatusType
                {
                    NameSq = create.NameSQ,
                    NameEn = create.NameEN,
                    Active = true,
                    InsertedDate = DateTime.Now,
                    InsertedFrom = user.Id
                });
                break;
            default:
                return Json(new ErrorVM() { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
        }
        await db.SaveChangesAsync();
        return Json(error);
    }

    #endregion

    #region Edit

    [Authorize(Policy = "22:e"), Description("Arb Tahiri", "Form to edit data from look up tables.")]
    public async Task<IActionResult> _Edit(LookUpTable table, string title, string ide)
    {
        var id = CryptoSecurity.Decrypt<int>(ide);
        var editData = new Edit();

        editData = table switch
        {
            LookUpTable.Absent =>
                editData = await db.AbsentType
                    .Where(a => a.AbsentTypeId == id)
                    .Select(a => new Edit
                    {
                        Ide = CryptoSecurity.Encrypt(a.AbsentTypeId),
                        NameSQ = a.NameSq,
                        NameEN = a.NameEn,
                        Title = title,
                        Table = table
                    }).FirstOrDefaultAsync(),
            LookUpTable.City =>
                editData = await db.City
                    .Where(a => a.CityId == id)
                    .Select(a => new Edit
                    {
                        Ide = CryptoSecurity.Encrypt(a.CityId),
                        NameSQ = a.NameSq,
                        NameEN = a.NameEn,
                        Title = title,
                        Table = table
                    }).FirstOrDefaultAsync(),
            LookUpTable.Country =>
                editData = await db.Country
                    .Where(a => a.CountryId == id)
                    .Select(a => new Edit
                    {
                        Ide = CryptoSecurity.Encrypt(a.CountryId),
                        NameSQ = a.NameSq,
                        NameEN = a.NameEn,
                        Title = title,
                        Table = table
                    }).FirstOrDefaultAsync(),
            LookUpTable.Department =>
                editData = await db.Department
                    .Where(a => a.DepartmentId == id)
                    .Select(a => new Edit
                    {
                        Ide = CryptoSecurity.Encrypt(a.DepartmentId),
                        NameSQ = a.NameSq,
                        NameEN = a.NameEn,
                        Title = title,
                        Table = table
                    }).FirstOrDefaultAsync(),
            LookUpTable.Document =>
                editData = await db.DocumentType
                    .Where(a => a.DocumentTypeId == id)
                    .Select(a => new Edit
                    {
                        Ide = CryptoSecurity.Encrypt(a.DocumentTypeId),
                        NameSQ = a.NameSq,
                        NameEN = a.NameEn,
                        Title = title,
                        Table = table
                    }).FirstOrDefaultAsync(),
            LookUpTable.Staff =>
                editData = await db.StaffType
                    .Where(a => a.StaffTypeId == id)
                    .Select(a => new Edit
                    {
                        Ide = CryptoSecurity.Encrypt(a.StaffTypeId),
                        NameSQ = a.NameSq,
                        NameEN = a.NameEn,
                        Title = title,
                        Table = table
                    }).FirstOrDefaultAsync(),
            LookUpTable.Status =>
                editData = await db.StatusType
                    .Where(a => a.StatusType1 == id)
                    .Select(a => new Edit
                    {
                        Ide = CryptoSecurity.Encrypt(a.StatusType1),
                        NameSQ = a.NameSq,
                        NameEN = a.NameEn,
                        Title = title,
                        Table = table
                    }).FirstOrDefaultAsync(),
            _ => null
        };
        return PartialView(editData);
    }

    [HttpPost, Authorize(Policy = "22:e"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to edit data from a look up table.")]
    public async Task<IActionResult> Edit(Edit edit)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM() { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
        }

        var error = new ErrorVM() { Status = ErrorStatus.Success, Description = Resource.DataUpdatedSuccessfully };
        var id = CryptoSecurity.Decrypt<int>(edit.Ide);

        switch (edit.Table)
        {
            case LookUpTable.Absent:
                var educationLevelType = await db.AbsentType.FirstOrDefaultAsync(a => a.AbsentTypeId == id);
                educationLevelType.NameSq = edit.NameSQ;
                educationLevelType.NameEn = edit.NameEN;
                educationLevelType.UpdatedDate = DateTime.Now;
                educationLevelType.UpdatedFrom = user.Id;
                educationLevelType.UpdatedNo = UpdateNo(educationLevelType.UpdatedNo);
                break;
            case LookUpTable.City:
                var holidayType = await db.City.FirstOrDefaultAsync(a => a.CityId == id);
                holidayType.NameSq = edit.NameSQ;
                holidayType.NameEn = edit.NameEN;
                holidayType.UpdatedDate = DateTime.Now;
                holidayType.UpdatedFrom = user.Id;
                holidayType.UpdatedNo = UpdateNo(holidayType.UpdatedNo);
                break;
            case LookUpTable.Country:
                var evaluationType = await db.Country.FirstOrDefaultAsync(a => a.CountryId == id);
                evaluationType.NameSq = edit.NameSQ;
                evaluationType.NameEn = edit.NameEN;
                evaluationType.UpdatedDate = DateTime.Now;
                evaluationType.UpdatedFrom = user.Id;
                evaluationType.UpdatedNo = UpdateNo(evaluationType.UpdatedNo);
                break;
            case LookUpTable.Department:
                var department = await db.Department.FirstOrDefaultAsync(a => a.DepartmentId == id);
                department.NameSq = edit.NameSQ;
                department.NameEn = edit.NameEN;
                department.UpdatedDate = DateTime.Now;
                department.UpdatedFrom = user.Id;
                department.UpdatedNo = UpdateNo(department.UpdatedNo);
                break;
            case LookUpTable.Document:
                var documentType = await db.DocumentType.FirstOrDefaultAsync(a => a.DocumentTypeId == id);
                documentType.NameSq = edit.NameSQ;
                documentType.NameEn = edit.NameEN;
                documentType.UpdatedDate = DateTime.Now;
                documentType.UpdatedFrom = user.Id;
                documentType.UpdatedNo = UpdateNo(documentType.UpdatedNo);
                break;
            case LookUpTable.Staff:
                var staffType = await db.StaffType.FirstOrDefaultAsync(a => a.StaffTypeId == id);
                staffType.NameSq = edit.NameSQ;
                staffType.NameEn = edit.NameEN;
                staffType.UpdatedDate = DateTime.Now;
                staffType.UpdatedFrom = user.Id;
                staffType.UpdatedNo = UpdateNo(staffType.UpdatedNo);
                break;
            case LookUpTable.Status:
                var statusType = await db.StatusType.FirstOrDefaultAsync(a => a.StatusType1 == id);
                statusType.NameSq = edit.NameSQ;
                statusType.NameEn = edit.NameEN;
                statusType.UpdatedDate = DateTime.Now;
                statusType.UpdatedFrom = user.Id;
                statusType.UpdatedNo = UpdateNo(statusType.UpdatedNo);
                break;
            default:
                return Json(new ErrorVM() { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
        }
        await db.SaveChangesAsync();
        return Json(error);
    }

    #endregion

    #region Delete

    [HttpPost, Authorize(Policy = "22:d"), ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to delete data from a lookup table.")]
    public async Task<IActionResult> Delete(LookUpTable table, string ide, bool active)
    {
        var error = new ErrorVM() { Status = ErrorStatus.Success, Description = Resource.DataDeletedSuccessfully };

        var id = CryptoSecurity.Decrypt<int>(ide);

        switch (table)
        {
            case LookUpTable.Absent:
                var educationLevelType = await db.AbsentType.FirstOrDefaultAsync(a => a.AbsentTypeId == id);
                educationLevelType.Active = active;
                educationLevelType.UpdatedDate = DateTime.Now;
                educationLevelType.UpdatedFrom = user.Id;
                educationLevelType.UpdatedNo = UpdateNo(educationLevelType.UpdatedNo);
                break;
            case LookUpTable.City:
                var evaluationType = await db.City.FirstOrDefaultAsync(a => a.CityId == id);
                evaluationType.Active = active;
                evaluationType.UpdatedDate = DateTime.Now;
                evaluationType.UpdatedFrom = user.Id;
                evaluationType.UpdatedNo = UpdateNo(evaluationType.UpdatedNo);
                break;
            case LookUpTable.Country:
                var holidayType = await db.Country.FirstOrDefaultAsync(a => a.CountryId == id);
                holidayType.Active = active;
                holidayType.UpdatedDate = DateTime.Now;
                holidayType.UpdatedFrom = user.Id;
                holidayType.UpdatedNo = UpdateNo(holidayType.UpdatedNo);
                break;
            case LookUpTable.Department:
                var department = await db.Department.FirstOrDefaultAsync(a => a.DepartmentId == id);
                department.Active = active;
                department.UpdatedDate = DateTime.Now;
                department.UpdatedFrom = user.Id;
                department.UpdatedNo = UpdateNo(department.UpdatedNo);
                break;
            case LookUpTable.Document:
                var documentType = await db.DocumentType.FirstOrDefaultAsync(a => a.DocumentTypeId == id);
                documentType.Active = active;
                documentType.UpdatedDate = DateTime.Now;
                documentType.UpdatedFrom = user.Id;
                documentType.UpdatedNo = UpdateNo(documentType.UpdatedNo);
                break;
            case LookUpTable.Staff:
                var staffType = await db.StaffType.FirstOrDefaultAsync(a => a.StaffTypeId == id);
                staffType.Active = active;
                staffType.UpdatedDate = DateTime.Now;
                staffType.UpdatedFrom = user.Id;
                staffType.UpdatedNo = UpdateNo(staffType.UpdatedNo);
                break;
            case LookUpTable.Status:
                var statusType = await db.StatusType.FirstOrDefaultAsync(a => a.StatusType1 == id);
                statusType.Active = active;
                statusType.UpdatedDate = DateTime.Now;
                statusType.UpdatedFrom = user.Id;
                statusType.UpdatedNo = UpdateNo(statusType.UpdatedNo);
                break;
            default:
                return Json(new ErrorVM() { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
        }
        await db.SaveChangesAsync();
        return Json(error);
    }

    #endregion
}
