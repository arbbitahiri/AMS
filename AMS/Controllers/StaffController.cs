﻿using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models.Shared;
using AMS.Models.Staff;
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

public class StaffController : BaseController
{
    private readonly IWebHostEnvironment environment;
    private readonly IConfiguration configuration;
    private readonly RoleManager<ApplicationRole> roleManager;

    public StaffController(IWebHostEnvironment environment, IConfiguration configuration, RoleManager<ApplicationRole> roleManager,
        AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
        this.environment = environment;
        this.configuration = configuration;
        this.roleManager = roleManager;
    }

    #region List

    [HttpGet, Authorize(Policy = "7:m")]
    [Description("Arb Tahiri", "Entry home. Search for staff.")]
    public IActionResult Index() => View();

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "7:r")]
    [Description("Arb Tahiri", "Form to list searched list of staff.")]
    public async Task<IActionResult> Search(Search search)
    {
        var staffList = await db.StaffDepartment
            .Where(a => a.DepartmentId == (search.Department ?? a.DepartmentId)
                && a.StaffTypeId == (search.StaffType ?? a.StaffTypeId)
                && a.EndDate >= DateTime.Now
                && (string.IsNullOrEmpty(search.PersonalNumber) || a.Staff.PersonalNumber == search.PersonalNumber)
                && (string.IsNullOrEmpty(search.Firstname) || a.Staff.FirstName.Contains(search.Firstname))
                && (string.IsNullOrEmpty(search.Lastname) || a.Staff.LastName.Contains(search.Lastname)))
            .AsSplitQuery()
            .Select(a => new StaffDetails
            {
                Ide = CryptoSecurity.Encrypt(a.StaffId),
                Firstname = a.Staff.FirstName,
                Lastname = a.Staff.LastName,
                PersonalNumber = a.Staff.PersonalNumber,
                ProfileImage = a.Staff.User.ProfileImage,
                Gender = user.Language == LanguageEnum.Albanian ? a.Staff.Gender.NameSq : a.Staff.Gender.NameEn,
                Department = user.Language == LanguageEnum.Albanian ? a.Department.NameSq : a.Department.NameEn,
                Email = a.Staff.User.Email,
                PhoneNumber = a.Staff.User.PhoneNumber,
                StaffType = string.Join(", ", user.Language == LanguageEnum.Albanian ? a.StaffType.NameSq : a.StaffType.NameEn)
            }).ToListAsync();
        return Json(staffList);
    }

    [HttpGet, Authorize(Policy = "7:r")]
    [Description("Arb Tahiri", "Form to display list of staff that are in process of registration.")]
    public async Task<IActionResult> InProcess()
    {
        var list = await db.Staff
            .AsSplitQuery()
            .Select(a => new StaffDetails
            {
                Ide = CryptoSecurity.Encrypt(a.StaffId),
                PersonalNumber = a.PersonalNumber,
                Firstname = a.FirstName,
                Lastname = a.LastName,
                ProfileImage = a.User.ProfileImage,
                Gender = user.Language == LanguageEnum.Albanian ? a.Gender.NameSq : a.Gender.NameEn,
                Email = a.User.Email,
                PhoneNumber = a.User.PhoneNumber,
                InsertedDate = a.InsertedDate
            }).ToListAsync();
        return PartialView(list);
    }

    #endregion

    #region 1. Register and edit

    [HttpGet, Authorize(Policy = "71:m")]
    [Description("Arb Tahiri", "Form to register or update staff. First step of registration/edition of staff.")]
    public async Task<IActionResult> Register(string ide)
    {
        if (string.IsNullOrEmpty(ide))
        {
            return View(new StaffPost() { MethodType = (int)MethodType.Post });
        }
        else
        {
            var staff = await db.Staff
                .Where(a => a.StaffId == CryptoSecurity.Decrypt<int>(ide))
                .Select(a => new StaffPost
                {
                    MethodType = (int)MethodType.Put,
                    StaffIde = ide,
                    PersonalNumber = a.PersonalNumber,
                    Firstname = a.FirstName,
                    Lastname = a.LastName,
                    BirthDate = a.BirthDate.ToString("dd/MM/yyyy"),
                    GenderId = a.GenderId,
                    Email = a.User.Email,
                    PhoneNumber = a.User.PhoneNumber,
                    CityId = a.CityId,
                    CountryId = a.CountryId,
                    Address = a.Address,
                    PostalCode = a.PostalCode
                }).FirstOrDefaultAsync();
            return View(staff);
        }
    }

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "71:c")]
    [Description("Arb Tahiri", "Action to register staff.")]
    public async Task<IActionResult> Register(StaffPost staff)
    {
        if (!ModelState.IsValid)
        {
            TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
            return View(staff);
        }

        string staffIde = string.Empty;
        //if (await db.AspNetUsers.AnyAsync(a => a.PersonalNumber == staff.PersonalNumber))
        //{
            if (await db.Staff.AnyAsync(a => a.PersonalNumber == staff.PersonalNumber))
            {
                TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Warning, Title = Resource.Warning, Description = Resource.StaffWithPersonalExists });
                return View(staff);
            }

            try
            {
                var newStaff = new Staff
                {
                    UserId = await db.AspNetUsers.Where(a => a.PersonalNumber == staff.PersonalNumber).Select(a => a.Id).FirstOrDefaultAsync(),
                    PersonalNumber = staff.PersonalNumber,
                    FirstName = staff.Firstname,
                    LastName = staff.Lastname,
                    BirthDate = DateTime.ParseExact(staff.BirthDate, "dd/MM/yyyy", null),
                    GenderId = staff.GenderId,
                    CityId = staff.CityId,
                    CountryId = staff.CountryId,
                    Address = staff.Address,
                    PostalCode = staff.PostalCode,
                    InsertedDate = DateTime.Now,
                    InsertedFrom = user.Id
                };

                db.Staff.Add(newStaff);
                db.StaffRegistrationStatus.Add(new StaffRegistrationStatus
                {
                    StaffId = newStaff.StaffId,
                    StatusTypeId = (int)Status.Processing,
                    Active = true,
                    InsertedDate = DateTime.Now,
                    InsertedFrom = user.Id
                });

                await db.SaveChangesAsync();

                staffIde = CryptoSecurity.Encrypt(newStaff.StaffId);
            }
            catch (Exception ex)
            {
                await LogError(ex);
                TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Error, Title = Resource.Error, Description = Resource.ErrorProcessingData });
                return View(staff);
            }
        //}
        //else
        //{
        //    var firstUser = new ApplicationUser
        //    {
        //        PersonalNumber = staff.PersonalNumber,
        //        FirstName = staff.Firstname,
        //        LastName = staff.Lastname,
        //        Email = staff.Email,
        //        EmailConfirmed = true,
        //        PhoneNumber = staff.PhoneNumber,
        //        UserName = staff.Email,
        //        Language = LanguageEnum.Albanian,
        //        AppMode = TemplateMode.Light,
        //        InsertedDate = DateTime.Now,
        //        InsertedFrom = user.Id
        //    };

        //    string errors = string.Empty;
        //    var error = new ErrorVM { Status = ErrorStatus.Success, Description = Resource.AccountCreatedSuccessfully };

        //    string password = FirstTimePassword(configuration, staff.Firstname, staff.Lastname);
        //    var result = await userManager.CreateAsync(firstUser, password);
        //    if (!result.Succeeded)
        //    {
        //        foreach (var identityError in result.Errors)
        //        {
        //            errors += $"{identityError.Description}. ";
        //        }
        //        error = new ErrorVM { Status = ErrorStatus.Warning, Description = errors };
        //    }

        //    try
        //    {
        //        var newStaff = new Staff
        //        {
        //            UserId = firstUser.Id,
        //            PersonalNumber = staff.PersonalNumber,
        //            FirstName = staff.Firstname,
        //            LastName = staff.Lastname,
        //            BirthDate = DateTime.ParseExact(staff.BirthDate, "dd/MM/yyyy", null),
        //            GenderId = staff.GenderId,
        //            CityId = staff.CityId,
        //            CountryId = staff.CountryId,
        //            Address = staff.Address,
        //            PostalCode = staff.PostalCode,
        //            InsertedDate = DateTime.Now,
        //            InsertedFrom = user.Id
        //        };

        //        db.Staff.Add(newStaff);
        //        await db.SaveChangesAsync();

        //        db.StaffRegistrationStatus.Add(new StaffRegistrationStatus
        //        {
        //            StaffId = newStaff.StaffId,
        //            StatusTypeId = (int)Status.Processing,
        //            Active = true,
        //            InsertedDate = DateTime.Now,
        //            InsertedFrom = user.Id
        //        });
        //        await db.SaveChangesAsync();

        //        staffIde = CryptoSecurity.Encrypt(newStaff.StaffId);
        //    }
        //    catch (Exception ex)
        //    {
        //        await userManager.DeleteAsync(firstUser);
        //        await LogError(ex);
        //        TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Error, Title = Resource.Error, Description = Resource.ErrorProcessingData });
        //        return View(staff);
        //    }
        //}

        return RedirectToAction(nameof(Documents), new { ide = staffIde });
    }

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "71:c")]
    [Description("Arb Tahiri", "Action to edit staff data.")]
    public async Task<IActionResult> Edit(StaffPost edit)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
        }

        var staff = await db.Staff.Where(a => a.StaffId == CryptoSecurity.Decrypt<int>(edit.StaffIde)).FirstOrDefaultAsync();
        var userStaff = await db.AspNetUsers.FindAsync(staff.UserId);

        staff.PersonalNumber = edit.PersonalNumber;
        staff.FirstName = edit.Firstname;
        staff.LastName = edit.Lastname;
        staff.BirthDate = DateTime.ParseExact(edit.BirthDate, "dd/MM/yyyy", null);
        staff.CityId = edit.CityId;
        staff.CountryId = edit.CountryId;
        staff.Address = edit.Address;
        staff.PostalCode = edit.PostalCode;
        userStaff.Email = edit.Email;
        userStaff.PhoneNumber = edit.PhoneNumber;
        staff.UpdatedDate = DateTime.Now;
        staff.UpdatedFrom = user.Id;
        staff.UpdatedNo = UpdateNo(staff.UpdatedNo);

        await db.SaveChangesAsync();
        return RedirectToAction(nameof(Documents), new { ide = edit.StaffIde });
    }

    #endregion

    #region 2. Documents

    #region => List

    [HttpGet, Authorize(Policy = "7d:r")]
    [Description("Arb Tahiri", "Entry form for documents. Third step of registration/editation of staff.")]
    public async Task<IActionResult> Documents(string ide)
    {
        var staff = await db.Staff.Where(a => a.StaffId == CryptoSecurity.Decrypt<int>(ide))
            .Select(a => new StaffDetails
            {
                Ide = ide,
                Firstname = a.FirstName,
                Lastname = a.LastName,
                MethodType = a.StaffRegistrationStatus.Any(a => a.Active && a.StatusTypeId == (int)Status.Finished) ? (int)MethodType.Put : (int)MethodType.Post
            }).FirstOrDefaultAsync();

        var documents = await db.StaffDocument
            .Include(a => a.DocumentType)
            .Where(a => a.StaffId == CryptoSecurity.Decrypt<int>(ide))
            .Select(a => new Documents
            {
                StaffDocumentIde = CryptoSecurity.Encrypt(a.StaffDocumentId),
                Title = a.Title,
                Path = a.Path,
                PathExtension = Path.GetExtension(a.Path),
                DocumentType = user.Language == LanguageEnum.Albanian ? a.DocumentType.NameSq : a.DocumentType.NameEn,
                Description = a.Description,
                Active = a.Active
            }).ToListAsync();

        var documentVM = new DocumentsVM
        {
            StaffDetails = staff,
            Documents = documents,
            DocumentCount = documents.Count
        };
        return View(documentVM);
    }

    #endregion

    #region => Create

    [HttpGet, Authorize(Policy = "7d:c")]
    [Description("Arb Tahiri", "Form to add documents.")]
    public IActionResult _AddDocument(string ide) => PartialView(new AddDocument { StaffIde = ide, FileSize = $"{Convert.ToDecimal(configuration["AppSettings:FileMaxKB"]) / 1024:N1}MB" });

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "7d:c")]
    [Description("Arb Tahiri", "Action to add documents.")]
    public async Task<IActionResult> AddDocument(AddDocument add)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
        }

        string path = await SaveFile(environment, configuration, add.FormFile, "StaffDocuments", null);

        db.Add(new StaffDocument
        {
            StaffId = CryptoSecurity.Decrypt<int>(add.StaffIde),
            DocumentTypeId = add.DocumentTypeId,
            Title = add.Title,
            Path = path,
            Description = add.Description,
            Active = true,
            InsertedDate = DateTime.Now,
            InsertedFrom = user.Id
        });

        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = Resource.DataRegisteredSuccessfully });
    }

    #endregion

    #region => Edit

    [HttpGet, Authorize(Policy = "7d:e")]
    [Description("Arb Tahiri", "Form to edit a document.")]
    public async Task<IActionResult> _EditDocument(string ide)
    {
        var document = await db.StaffDocument
            .Where(a => a.StaffDocumentId == CryptoSecurity.Decrypt<int>(ide))
            .Select(a => new EditDocument
            {
                StaffDocumentIde = ide,
                DocumentTypeId = a.DocumentTypeId,
                Title = a.Title,
                Description = a.Description,
                Active = a.Active
            }).FirstOrDefaultAsync();

        return View(document);
    }

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "7d:e")]
    [Description("Arb Tahiri", "Action to edit a document.")]
    public async Task<IActionResult> EditDocument(EditDocument edit)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
        }

        var document = await db.StaffDocument.FirstOrDefaultAsync(a => a.StaffDocumentId == CryptoSecurity.Decrypt<int>(edit.StaffDocumentIde));
        document.DocumentTypeId = edit.DocumentTypeId;
        document.Title = edit.Title;
        document.Description = edit.Description;
        document.Active = edit.Active;
        document.UpdatedDate = DateTime.Now;
        document.UpdatedFrom = user.Id;
        document.UpdatedNo = UpdateNo(document.UpdatedNo);

        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = Resource.DataUpdatedSuccessfully });
    }

    #endregion

    #region => Delete

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "7d:d")]
    [Description("Arb Tahiri", "Action to delete a document.")]
    public async Task<IActionResult> DeleteDocument(string ide)
    {
        var document = await db.StaffDocument.FirstOrDefaultAsync(a => a.StaffDocumentId == CryptoSecurity.Decrypt<int>(ide));
        document.Active = false;
        document.UpdatedDate = DateTime.Now;
        document.UpdatedFrom = user.Id;
        document.UpdatedNo = UpdateNo(document.UpdatedNo);

        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = Resource.DataDeletedSuccessfully });
    }

    #endregion

    #endregion

    #region 3. Department

    #region => List

    [HttpGet, Authorize(Policy = "7dp:r")]
    [Description("Arb Tahiri", "Entry form for department. Fourth step of registration/editation of staff.")]
    public async Task<IActionResult> Departments(string ide)
    {
        var staff = await db.Staff
            .Where(a => a.StaffId == CryptoSecurity.Decrypt<int>(ide))
            .Select(a => new StaffDetails
            {
                Ide = ide,
                Firstname = a.FirstName,
                Lastname = a.LastName,
                MethodType = a.StaffRegistrationStatus.Any(a => a.Active && a.StatusTypeId == (int)Status.Finished) ? (int)MethodType.Put : (int)MethodType.Post,
            }).FirstOrDefaultAsync();

        var departments = await db.StaffDepartment
            .Where(a => a.StaffId == CryptoSecurity.Decrypt<int>(ide) && a.EndDate >= DateTime.Now)
            .Select(a => new Departments
            {
                StaffDepartmentIde = CryptoSecurity.Encrypt(a.StaffDepartmentId),
                Department = user.Language == LanguageEnum.Albanian ? a.Department.NameSq : a.Department.NameEn,
                StartDate = a.StartDate.ToString("dd/MM/yyyy"),
                EndDate = a.EndDate.ToString("dd/MM/yyyy"),
            }).ToListAsync();

        var departmentVM = new DepartmentVM
        {
            StaffDetails = staff,
            Departments = departments,
            DepartmentCount = departments.Count
        };
        return View(departmentVM);
    }

    #endregion

    #region ==> Create

    [HttpGet, Authorize(Policy = "7dp:c")]
    [Description("Arb Tahiri", "Form to add department.")]
    public async Task<IActionResult> _AddDepartment(string ide)
    {
        var staffDetails = await db.Staff.Where(a => a.StaffId == CryptoSecurity.Decrypt<int>(ide))
            .Select(a => new AddDepartment
            {
                StaffIde = ide,
                Outsider = a.CountryId != (int)CountryEnum.Kosova
            }).FirstOrDefaultAsync();
        return PartialView(staffDetails);
    }

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "7dp:c")]
    [Description("Arb Tahiri", "Action to add new department.")]
    public async Task<IActionResult> AddDepartment(AddDepartment add)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
        }

        var getRole = GetRoleFromStaffType(add.StaffTypeId);
        var staffDepartment = await db.StaffDepartment.Include(a => a.Staff).Where(a => a.StaffId == CryptoSecurity.Decrypt<int>(add.StaffIde)).ToListAsync();

        foreach (var item in staffDepartment)
        {
            if (await db.StaffDepartment.AnyAsync(a => a.StaffId == item.StaffId && a.StaffTypeId == item.StaffTypeId && a.EndDate >= DateTime.Now))
            {
                var role = GetRoleFromStaffType(item.StaffTypeId);
                var staffRoleName = await db.AspNetRoles.Where(a => a.Id == role).Select(a => user.Language == LanguageEnum.Albanian ? a.NameSq : a.NameEn).FirstOrDefaultAsync();
                return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = string.Format(Resource.ExistsStaffRole, item.Staff.FirstName, item.Staff.LastName, staffRoleName) }); //$"{item.Staff.FirstName} {item.Staff.LastName} ekziston si {staffRoleName}. Duhet të pasivizoni këtë për të regjistruar pastaj!"
            }
        }

        //var userId = await db.Staff.Where(a => a.StaffId == CryptoSecurity.Decrypt<int>(add.StaffIde)).Select(a => a.UserId).FirstOrDefaultAsync();
        //var newUser = await userManager.FindByIdAsync(userId);
        //var getRoles = await userManager.GetRolesAsync(newUser);

        var newStaffDepartment = new StaffDepartment
        {
            StaffId = CryptoSecurity.Decrypt<int>(add.StaffIde),
            StaffTypeId = add.StaffTypeId,
            DepartmentId = add.DepartmentId,
            StartDate = DateTime.ParseExact(add.StartDate, "dd/MM/yyyy", null),
            EndDate = DateTime.ParseExact(add.EndDate, "dd/MM/yyyy", null),
            Description = add.Description,
            InsertedDate = DateTime.Now,
            InsertedFrom = user.Id
        };

        //// TODO: try catch, if error, delete roles
        //if (!getRoles.Any())
        //{
        //    var role = await db.AspNetRoles.Where(a => a.Id == getRole).Select(a => a.NormalizedName).ToListAsync();
        //    var result = await userManager.AddToRolesAsync(newUser, role);
        //    if (!result.Succeeded)
        //    {
        //        TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Error, Title = Resource.Error, RawContent = true, Description = "<ul>" + string.Join("", result.Errors.Select(a => "<li>" + a.Description + "</li>").ToArray()) + $"<li>{Resource.RolesAddThroughList}</li>" + "</ul>" });
        //    }
        //}

        //if (!getRoles.Any(a => a == getRole))
        //{
        //    db.RealRole.Add(new RealRole
        //    {
        //        UserId = userId,
        //        RoleId = getRole,
        //        InsertedDate = DateTime.Now,
        //        InsertedFrom = user.Id
        //    });
        //}

        db.StaffDepartment.Add(newStaffDepartment);
        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = Resource.DataRegisteredSuccessfully });
    }

    #endregion

    #region ==> Edit

    [HttpGet, Authorize(Policy = "7dp:e")]
    [Description("Arb Tahiri", "Form to edit department.")]
    public async Task<IActionResult> _EditDepartment(string ide)
    {
        var department = await db.StaffDepartment
            .Where(a => a.StaffDepartmentId == CryptoSecurity.Decrypt<int>(ide))
            .Select(a => new AddDepartment
            {
                StaffDepartmentIde = ide,
                DepartmentId = a.DepartmentId,
                StaffTypeId = a.StaffTypeId,
                StartDate = a.StartDate.ToString("dd/MM/yyyy"),
                EndDate = a.EndDate.ToString("dd/MM/yyyy"),
                Description = a.Description,
                Outsider = a.Staff.CountryId != (int)CountryEnum.Kosova
            }).FirstOrDefaultAsync();

        return PartialView(department);
    }

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "7dp:e")]
    [Description("Arb Tahiri", "Action to edit department.")]
    public async Task<IActionResult> EditDepartment(AddDepartment edit)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
        }

        var department = await db.StaffDepartment.Where(a => a.StaffDepartmentId == CryptoSecurity.Decrypt<int>(edit.StaffDepartmentIde)).FirstOrDefaultAsync();
        department.DepartmentId = edit.DepartmentId;
        department.StaffTypeId = edit.StaffTypeId;
        department.StartDate = DateTime.ParseExact(edit.StartDate, "dd/MM/yyyy", null);
        department.EndDate = DateTime.ParseExact(edit.EndDate, "dd/MM/yyyy", null);
        department.UpdatedDate = DateTime.Now;
        department.UpdatedFrom = user.Id;
        department.UpdatedNo = UpdateNo(department.UpdatedNo);

        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = Resource.DataUpdatedSuccessfully });
    }

    #endregion

    #region ==> Delete

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "7dp:d")]
    [Description("Arb Tahiri", "Action to delete a department.")]
    public async Task<IActionResult> DeleteDepartment(string ide)
    {
        var department = await db.StaffDepartment.Include(a => a.Staff).FirstOrDefaultAsync(a => a.StaffDepartmentId == CryptoSecurity.Decrypt<int>(ide));
        department.EndDate = DateTime.Now.AddDays(-1);
        department.UpdatedDate = DateTime.Now;
        department.UpdatedFrom = user.Id;
        department.UpdatedNo = UpdateNo(department.UpdatedNo);

        //var userToRemove = await userManager.FindByIdAsync(department.Staff.UserId);
        //var rolesToRemove = await userManager.GetRolesAsync(userToRemove);

        //var realRoles = await db.RealRole.FirstOrDefaultAsync(a => a.UserId == department.Staff.UserId);
        //if (realRoles != null)
        //{
        //    db.RealRole.Remove(realRoles);
        //    await db.SaveChangesAsync();

        //    var anotherRealRoles = await db.RealRole.Where(a => a.UserId == department.Staff.UserId).ToListAsync();
        //    if (anotherRealRoles.Count == 0)
        //    {
        //        var result = await userManager.RemoveFromRolesAsync(userToRemove, db.AspNetRoles.Where(a => rolesToRemove.Contains(a.Id)).Select(a => a.NormalizedName).ToList());
        //        if (!result.Succeeded)
        //        {
        //            TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Error, Title = Resource.Error, RawContent = true, Description = "<ul>" + string.Join("", result.Errors.Select(a => "<li>" + a.Description + "</li>").ToArray()) + "</ul>" });
        //        }
        //    }
        //    else
        //    {
        //        var result = await userManager.AddToRoleAsync(userToRemove, db.AspNetRoles.Where(a => a.Id == anotherRealRoles.Select(a => a.RoleId).FirstOrDefault()).Select(a => a.NormalizedName).FirstOrDefault());
        //        if (!result.Succeeded)
        //        {
        //            TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Error, Title = Resource.Error, RawContent = true, Description = "<ul>" + string.Join("", result.Errors.Select(a => "<li>" + a.Description + "</li>").ToArray()) + "</ul>" });
        //        }
        //    }
        //}

        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = Resource.DataDeletedSuccessfully });
    }

    #endregion

    #endregion

    #region Finish

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "7:c")]
    [Description("Arb Tahiri", "Action to add finished status in staff registration.")]
    public async Task<IActionResult> Finish(string ide)
    {
        if (string.IsNullOrEmpty(ide))
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
        }

        var staffId = CryptoSecurity.Decrypt<int>(ide);
        var registeredInDepartment = await db.StaffDepartment.AnyAsync(a => a.EndDate >= DateTime.Now && a.StaffId == staffId);
        if (!registeredInDepartment)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.StaffNotComplete });
        }

        var staffRegistrationStatus = await db.StaffRegistrationStatus.FirstOrDefaultAsync(a => a.Active && a.StaffId == staffId);
        staffRegistrationStatus.Active = false;
        staffRegistrationStatus.UpdatedDate = DateTime.Now;
        staffRegistrationStatus.UpdatedFrom = user.Id;
        staffRegistrationStatus.UpdatedNo = UpdateNo(staffRegistrationStatus.UpdatedNo);

        db.StaffRegistrationStatus.Add(new StaffRegistrationStatus
        {
            StaffId = CryptoSecurity.Decrypt<int>(ide),
            StatusTypeId = (int)Status.Finished,
            Active = true,
            InsertedDate = DateTime.Now,
            InsertedFrom = user.Id
        });
        await db.SaveChangesAsync();

        TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Success, Title = Resource.Success, Description = Resource.DataRegisteredSuccessfully });
        return Json(new ErrorVM { Status = ErrorStatus.Success });
    }

    #endregion

    #region Remote

    //[Description("Arb Tahiri", "Method to check birthday.")]
    //public IActionResult CheckBirthdate(string BirthDate)
    //{
    //    var birthdate = DateTime.ParseExact(BirthDate, "dd/MM/yyyy", null);

    //    if (birthdate >= DateTime.Now)
    //    {
    //        return Json(Resource.NotAllowedGreaterDate);
    //    }

    //    if (birthdate <= DateTime.Now.AddYears(-18))
    //    {
    //        return Json(true);
    //    }
    //    else
    //    {
    //        return Json(false);
    //    }
    //}

    [Description("Arb Tahiri", "Method to check end date of subject.")]
    public IActionResult CheckEndDate(DateTime DepartmentEndDate, string EndDate, string StartDate)
    {
        var startDate = DateTime.ParseExact(StartDate ?? DateTime.Now.ToString(), "dd/MM/yyyy", null);
        var endDate = DateTime.ParseExact(EndDate, "dd/MM/yyyy", null);

        if (endDate <= DepartmentEndDate)
        {
            return Json(true);
        }
        else if (startDate >= endDate)
        {
            return Json(Resource.StartDateVSEndDate);
        }
        else
        {
            return Json(false);
        }
    }

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

    [Description("Arb Tahiri", "Method to check end date and start date.")]
    public IActionResult CheckDatesQualification(string From, string To)
    {
        var startDate = DateTime.ParseExact(From, "dd/MM/yyyy", null);
        var endDate = DateTime.ParseExact(To, "dd/MM/yyyy", null);

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

    #region Open document

    [HttpGet, Description("Arb Tahiri", "Action to open documents.")]
    public async Task<IActionResult> OpenDocument(string ide)
    {
        var getDocument = await db.StaffDocument.FirstOrDefaultAsync(a => a.StaffDocumentId == CryptoSecurity.Decrypt<int>(ide));
        var openDocument = new OpenDocument
        {
            Path = getDocument.Path,
            Name = getDocument.Title
        };

        return View(openDocument);
    }

    #endregion

    #region Report

    [HttpPost, ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Report for list of staff depending of the search.")]
    public async Task<IActionResult> Report(Search search, ReportType reportType)
    {
        var staffList = await db.StaffDepartment
            .Where(a => a.DepartmentId == (search.Department ?? a.DepartmentId)
                && a.StaffTypeId == (search.Department ?? a.StaffTypeId)
                && a.EndDate >= DateTime.Now
                && (string.IsNullOrEmpty(search.PersonalNumber) || a.Staff.PersonalNumber.Contains(search.PersonalNumber))
                && (string.IsNullOrEmpty(search.Firstname) || a.Staff.FirstName.Contains(search.Firstname))
                && (string.IsNullOrEmpty(search.Lastname) || a.Staff.LastName.Contains(search.Lastname)))
            .AsSplitQuery()
            .Select(a => new ReportVM
            {
                StaffId = a.StaffId,
                DepartmentId = a.DepartmentId,
                Department = user.Language == LanguageEnum.Albanian ? a.Department.NameSq : a.Department.NameEn,
                PersonalNumber = a.Staff.PersonalNumber,
                FirstName = a.Staff.FirstName,
                LastName = a.Staff.LastName,
                BirthDate = a.Staff.BirthDate.ToString("dd/MM/yyyy"),
                Gender = user.Language == LanguageEnum.Albanian ? a.Staff.Gender.NameSq : a.Staff.Gender.NameEn,
                Email = a.Staff.User.Email,
                PhoneNumber = a.Staff.User.PhoneNumber,
                User = $"{user.FirstName} {user.LastName}"
            }).ToListAsync();

        var dataSource = new List<ReportDataSource>() { new ReportDataSource("StaffDetails", staffList) };
        var parameters = new List<ReportParameter>()
        {
            new ReportParameter("Department",search.Department.HasValue ? await db.Department.Where(a => a.DepartmentId == search.Department.Value).Select(a => user.Language == LanguageEnum.Albanian ? a.NameSq : a.NameEn).FirstOrDefaultAsync() : "///"),
            new ReportParameter("StaffType", search.StaffType.HasValue ? await db.StaffType.Where(a => a.StaffTypeId == search.StaffType.Value).Select(a => user.Language == LanguageEnum.Albanian ? a.NameSq : a.NameEn).FirstOrDefaultAsync() : "///"),
            new ReportParameter("PersonalNumber", search.PersonalNumber ?? "///"),
            new ReportParameter("Firstname", search.Firstname ?? "///"),
            new ReportParameter("Lastname", search.Lastname ?? "///")
        };

        var reportByte = RDLCReport.GenerateReport("StaffList.rdlc", dataSource, parameters, reportType, ReportOrientation.Portrait);
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
}