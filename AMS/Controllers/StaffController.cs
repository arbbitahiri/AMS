using AMS.Data.Core;
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
        var firstName = string.IsNullOrEmpty(search.Firstname) ? search.Firstname : search.Firstname.ToLower();
        var lastName = string.IsNullOrEmpty(search.Lastname) ? search.Lastname : search.Lastname.ToLower();

        var staffList = await db.Staff
            .Where(a => a.StaffRegistrationStatus.Any(a => a.Active && a.StatusTypeId != (int)Status.Deleted)
                && a.StaffDepartment.Any(b => b.DepartmentId == (search.Department ?? b.DepartmentId))
                && a.StaffDepartment.Any(b => b.StaffTypeId == (search.StaffType ?? b.StaffTypeId))
                && a.StaffDepartment.Any(b => b.EndDate.Date >= DateTime.Now.Date)
                && (string.IsNullOrEmpty(search.PersonalNumber) || a.PersonalNumber == search.PersonalNumber)
                && (string.IsNullOrEmpty(search.Firstname) || a.FirstName.ToLower().Contains(firstName))
                && (string.IsNullOrEmpty(search.Lastname) || a.LastName.ToLower().Contains(lastName)))
            .AsSplitQuery()
            .Select(a => new StaffDetails
            {
                Ide = CryptoSecurity.Encrypt(a.StaffId),
                Firstname = a.FirstName,
                Lastname = a.LastName,
                PersonalNumber = a.PersonalNumber,
                ProfileImage = a.User.ProfileImage,
                Gender = user.Language == LanguageEnum.Albanian ? a.Gender.NameSq : a.Gender.NameEn,
                Department = string.Join(", ", a.StaffDepartment.Select(a => user.Language == LanguageEnum.Albanian ? a.Department.NameSq : a.Department.NameEn).ToList()),
                Email = a.Email,
                PhoneNumber = a.PhoneNumber,
                StaffType = string.Join(", ", a.StaffDepartment.Select(a => user.Language == LanguageEnum.Albanian ? a.StaffType.NameSq : a.StaffType.NameEn).ToList())
            }).ToListAsync();
        return Json(staffList);
    }

    [HttpGet, Authorize(Policy = "7:r")]
    [Description("Arb Tahiri", "Form to display list of staff that are in process of registration.")]
    public async Task<IActionResult> InProcess()
    {
        var list = await db.Staff
            .Where(a => a.StaffRegistrationStatus.Any(a => a.Active && a.StatusTypeId == (int)Status.Processing))
            .AsSplitQuery()
            .Select(a => new StaffDetails
            {
                Ide = CryptoSecurity.Encrypt(a.StaffId),
                PersonalNumber = a.PersonalNumber,
                Firstname = a.FirstName,
                Lastname = a.LastName,
                ProfileImage = a.User.ProfileImage,
                Gender = user.Language == LanguageEnum.Albanian ? a.Gender.NameSq : a.Gender.NameEn,
                Email = a.Email,
                PhoneNumber = a.PhoneNumber,
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
                    Email = a.Email,
                    PhoneNumber = a.PhoneNumber,
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
        if (await db.Staff.AnyAsync(a => a.PersonalNumber == staff.PersonalNumber))
        {
            TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Warning, Title = Resource.Warning, Description = Resource.StaffWithPersonalExists });
            return View(staff);
        }

        string userId = null;
        var firstUser = new ApplicationUser();
        if (staff.NewUser)
        {
            if (await db.AspNetUsers.AnyAsync(a => a.PersonalNumber == staff.PersonalNumber))
            {
                TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Warning, Title = Resource.Warning, Description = Resource.StaffWithPersonalExists });
                return View(staff);
            }

            firstUser = new ApplicationUser
            {
                PersonalNumber = staff.PersonalNumber,
                FirstName = staff.Firstname,
                LastName = staff.Lastname,
                Email = staff.Email,
                EmailConfirmed = true,
                PhoneNumber = staff.PhoneNumber,
                UserName = staff.Username,
                Language = LanguageEnum.Albanian,
                AppMode = TemplateMode.Light,
                InsertedDate = DateTime.Now,
                InsertedFrom = user.Id
            };

            string errors = string.Empty;

            string password = FirstTimePassword(configuration, staff.Firstname, staff.Lastname);
            var result = await userManager.CreateAsync(firstUser, password);
            if (!result.Succeeded)
            {
                foreach (var identityError in result.Errors)
                {
                    errors += $"{identityError.Description}. ";
                }
                TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Warning, Description = errors });
                return View(staff);
            }
            userId = firstUser.Id;
        }

        try
        {
            var newStaff = new Staff
            {
                UserId = userId,
                PersonalNumber = staff.PersonalNumber,
                FirstName = staff.Firstname,
                LastName = staff.Lastname,
                BirthDate = DateTime.ParseExact(staff.BirthDate, "dd/MM/yyyy", null),
                GenderId = staff.GenderId,
                CityId = staff.CityId,
                CountryId = staff.CountryId,
                Address = staff.Address,
                PostalCode = staff.PostalCode,
                Email = staff.Email,
                PhoneNumber = staff.PhoneNumber,
                InsertedDate = DateTime.Now,
                InsertedFrom = user.Id
            };
            db.Staff.Add(newStaff);
            await db.SaveChangesAsync();

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
            if (staff.NewUser)
            {
                await userManager.DeleteAsync(firstUser);
            }

            await LogError(ex);
            TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Error, Title = Resource.Error, Description = Resource.ErrorProcessingData });
            return View(staff);
        }

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

        staff.PersonalNumber = edit.PersonalNumber;
        staff.FirstName = edit.Firstname;
        staff.LastName = edit.Lastname;
        staff.BirthDate = DateTime.ParseExact(edit.BirthDate, "dd/MM/yyyy", null);
        staff.CityId = edit.CityId;
        staff.CountryId = edit.CountryId;
        staff.Address = edit.Address;
        staff.PostalCode = edit.PostalCode;
        staff.Email = edit.Email;
        staff.PhoneNumber = edit.PhoneNumber;
        staff.Email = edit.Email;
        staff.PhoneNumber = edit.PhoneNumber;
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
        var staffId = CryptoSecurity.Decrypt<int>(ide);
        var staff = await db.Staff
            .Where(a => a.StaffId == staffId)
            .Select(a => new StaffDetails
            {
                Ide = ide,
                Firstname = a.FirstName,
                Lastname = a.LastName,
                MethodType = a.StaffRegistrationStatus.Any(a => a.Active && a.StatusTypeId == (int)Status.Finished) ? (int)MethodType.Put : (int)MethodType.Post,
            }).FirstOrDefaultAsync();

        var departments = await db.StaffDepartment
            .Where(a => a.StaffId == staffId && a.EndDate >= DateTime.Now)
            .Select(a => new Departments
            {
                StaffDepartmentIde = CryptoSecurity.Encrypt(a.StaffDepartmentId),
                Department = user.Language == LanguageEnum.Albanian ? a.Department.NameSq : a.Department.NameEn,
                StaffType = user.Language == LanguageEnum.Albanian ? a.StaffType.NameSq : a.StaffType.NameEn,
                StartDate = a.StartDate.ToString("dd/MM/yyyy"),
                EndDate = a.EndDate.ToString("dd/MM/yyyy")
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

        var staffId = CryptoSecurity.Decrypt<int>(add.StaffIde);

        var getRole = GetRoleFromStaffType(add.StaffTypeId);
        if (await db.StaffDepartment.AnyAsync(a => a.StaffId == staffId && a.StaffTypeId == add.StaffTypeId && a.EndDate >= DateTime.Now))
        {
            var staffName = await db.Staff.Where(a => a.StaffId == staffId).Select(a => $"{a.FirstName} {a.LastName}").FirstOrDefaultAsync();
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = string.Format(Resource.StaffExistsWithRole, staffName) });
        }

        var userId = await db.Staff.Where(a => a.StaffId == staffId).Select(a => a.UserId).FirstOrDefaultAsync();

        var newStaffDepartment = new StaffDepartment
        {
            StaffId = staffId,
            StaffTypeId = add.StaffTypeId,
            DepartmentId = add.DepartmentId,
            StartDate = DateTime.ParseExact(add.StartDate, "dd/MM/yyyy", null),
            EndDate = DateTime.ParseExact(add.EndDate, "dd/MM/yyyy", null),
            Description = add.Description,
            InsertedDate = DateTime.Now,
            InsertedFrom = user.Id
        };

        if (!string.IsNullOrEmpty(userId))
        {
            var newUser = await userManager.FindByIdAsync(userId);
            var getRoles = await userManager.GetRolesAsync(newUser);

            if (!getRoles.Any())
            {
                var role = await db.AspNetRoles.Where(a => a.Id == getRole).Select(a => a.NormalizedName).ToListAsync();
                var result = await userManager.AddToRolesAsync(newUser, role);
                if (!result.Succeeded)
                {
                    TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Error, Title = Resource.Error, RawContent = true, Description = "<ul>" + string.Join("", result.Errors.Select(a => "<li>" + a.Description + "</li>").ToArray()) + $"<li>{Resource.RolesAddThroughList}</li>" + "</ul>" });
                }
            }

            if (!getRoles.Any(a => a == getRole))
            {
                db.RealRole.Add(new RealRole
                {
                    UserId = userId,
                    RoleId = getRole,
                    InsertedDate = DateTime.Now,
                    InsertedFrom = user.Id
                });
            }
        }

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

        var staffDepartmentId = CryptoSecurity.Decrypt<int>(edit.StaffDepartmentIde);

        var department = await db.StaffDepartment.FirstOrDefaultAsync(a => a.StaffDepartmentId == staffDepartmentId);

        if (department.StaffTypeId != edit.StaffTypeId)
        {
            var userForRoles = await userManager.FindByIdAsync(department.Staff.UserId);
            var rolesToRemove = await userManager.GetRolesAsync(userForRoles);

            var getRole = GetRoleFromStaffType(edit.StaffTypeId);
            var realRole = await db.RealRole.FirstOrDefaultAsync(a => a.UserId == department.Staff.UserId && a.RoleId == getRole);
            if (realRole != null)
            {
                db.RealRole.Remove(realRole);
                await db.SaveChangesAsync();

                var roles = await db.AspNetRoles.Where(a => rolesToRemove.Contains(a.Id)).Select(a => a.NormalizedName).ToListAsync();
                var result = await userManager.RemoveFromRolesAsync(userForRoles, roles);
                if (!result.Succeeded)
                {
                    TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Error, Title = Resource.Error, RawContent = true, Description = "<ul>" + string.Join("", result.Errors.Select(a => "<li>" + a.Description + "</li>").ToArray()) + "</ul>" });
                }

                var anotherRole = await db.RealRole.Where(a => a.UserId == department.Staff.UserId).ToListAsync();
                if (anotherRole.Any())
                {
                    var otherRole = await db.AspNetRoles.Where(a => a.Id == anotherRole.Select(a => a.RoleId).FirstOrDefault()).Select(a => a.NormalizedName).FirstOrDefaultAsync();
                    var otherresult = await userManager.AddToRoleAsync(userForRoles, otherRole);
                    if (!result.Succeeded)
                    {
                        TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Error, Title = Resource.Error, RawContent = true, Description = "<ul>" + string.Join("", result.Errors.Select(a => "<li>" + a.Description + "</li>").ToArray()) + "</ul>" });
                    }
                }
            }

            db.RealRole.Add(new RealRole
            {
                UserId = userForRoles.Id,
                RoleId = getRole,
                InsertedDate = DateTime.Now,
                InsertedFrom = user.Id
            });
        }

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
        var staffDepartmentId = CryptoSecurity.Decrypt<int>(ide);
        var department = await db.StaffDepartment.FirstOrDefaultAsync(a => a.StaffDepartmentId == staffDepartmentId);
        department.EndDate = DateTime.Now.AddDays(-1);
        department.UpdatedDate = DateTime.Now;
        department.UpdatedFrom = user.Id;
        department.UpdatedNo = UpdateNo(department.UpdatedNo);

        var userForRoles = await userManager.FindByIdAsync(department.Staff.UserId);
        var rolesToRemove = await userManager.GetRolesAsync(userForRoles);

        var getRole = GetRoleFromStaffType(department.StaffTypeId);
        var realRole = await db.RealRole.FirstOrDefaultAsync(a => a.UserId == department.Staff.UserId && a.RoleId == getRole);
        if (realRole != null)
        {
            db.RealRole.Remove(realRole);
            await db.SaveChangesAsync();

            var roles = await db.AspNetRoles.Where(a => rolesToRemove.Contains(a.Id)).Select(a => a.NormalizedName).ToListAsync();
            var result = await userManager.RemoveFromRolesAsync(userForRoles, roles);
            if (!result.Succeeded)
            {
                TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Error, Title = Resource.Error, RawContent = true, Description = "<ul>" + string.Join("", result.Errors.Select(a => "<li>" + a.Description + "</li>").ToArray()) + "</ul>" });
            }

            var anotherRole = await db.RealRole.Where(a => a.UserId == department.Staff.UserId).ToListAsync();
            if (anotherRole.Any())
            {
                var otherRole = await db.AspNetRoles.Where(a => a.Id == anotherRole.Select(a => a.RoleId).FirstOrDefault()).Select(a => a.NormalizedName).FirstOrDefaultAsync();
                var otherresult = await userManager.AddToRoleAsync(userForRoles, otherRole);
                if (!result.Succeeded)
                {
                    TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Error, Title = Resource.Error, RawContent = true, Description = "<ul>" + string.Join("", result.Errors.Select(a => "<li>" + a.Description + "</li>").ToArray()) + "</ul>" });
                }
            }
        }

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
        if (!await db.StaffDepartment.AnyAsync(a => a.EndDate >= DateTime.Now && a.StaffId == staffId))
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.StaffNotComplete });
        }

        var staffRegistrationStatus = await db.StaffRegistrationStatus.Include(a => a.Staff).FirstOrDefaultAsync(a => a.Active && a.StaffId == staffId);

        if (!await db.StaffRegistrationStatus.AnyAsync(a => a.Active && a.StatusTypeId == (int)Status.Finished) && !string.IsNullOrEmpty(staffRegistrationStatus.Staff.UserId))
        {
            var userForRoles = await userManager.FindByIdAsync(staffRegistrationStatus.Staff.UserId);
            var staffDepartments = await db.StaffDepartment.Include(a => a.Staff).Where(a => a.EndDate >= DateTime.Now && a.StaffId == staffId).ToListAsync();

            foreach (var staff in staffDepartments)
            {
                var roleId = GetRoleFromStaffType(staff.StaffTypeId);
                if (!await db.RealRole.AnyAsync(a => a.RoleId == roleId))
                {
                    db.RealRole.Add(new RealRole
                    {
                        UserId = staff.Staff.UserId,
                        RoleId = roleId,
                        InsertedDate = DateTime.Now,
                        InsertedFrom = user.Id
                    });
                }

                var otherRoleId = await db.AspNetRoles.Where(a => a.Id == roleId).Select(a => a.NormalizedName).FirstOrDefaultAsync();
                var result = await userManager.RemoveFromRoleAsync(userForRoles, otherRoleId);
                if (!result.Succeeded)
                {
                    TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Success, Title = Resource.Success, Description = Resource.CouldNotAddRole });
                }
            }
        }

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
        await db.SaveChangesAsync();

        TempData.Set("Error", new ErrorVM { Status = ErrorStatus.Success, Title = Resource.Success, Description = Resource.DataRegisteredSuccessfully });
        return Json(new ErrorVM { Status = ErrorStatus.Success });
    }

    #endregion

    #region Delete

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "7:d")]
    [Description("Arb Tahiri", "Action to add finished status in staff registration.")]
    public async Task<IActionResult> Delete(string ide)
    {
        var staffId = CryptoSecurity.Decrypt<int>(ide);
        var staffRegistrationStatus = await db.StaffRegistrationStatus.FirstOrDefaultAsync(a => a.Active && a.StaffId == staffId);
        staffRegistrationStatus.Active = false;
        staffRegistrationStatus.UpdatedDate = DateTime.Now;
        staffRegistrationStatus.UpdatedFrom = user.Id;
        staffRegistrationStatus.UpdatedNo = UpdateNo(staffRegistrationStatus.UpdatedNo);

        db.StaffRegistrationStatus.Add(new StaffRegistrationStatus
        {
            StaffId = staffId,
            StatusTypeId = (int)Status.Deleted,
            Active = true,
            InsertedDate = DateTime.Now,
            InsertedFrom = user.Id
        });
        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = Resource.DataDeletedSuccessfully });
    }

    #endregion

    #region Remote

    [Description("Arb Tahiri", "Method to check for username.")]
    public async Task<IActionResult> CheckUsername(string Username)
    {
        if (await db.AspNetUsers.AnyAsync(a => a.UserName == Username))
        {
            return Json(true);
        }
        else
        {
            return Json(false);
        }
    }

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
            .Where(a => a.Staff.StaffRegistrationStatus.Any(a => a.Active && a.StatusTypeId != (int)Status.Deleted)
                && a.DepartmentId == (search.Department ?? a.DepartmentId)
                && a.StaffTypeId == (search.Department ?? a.StaffTypeId)
                && a.EndDate >= DateTime.Now
                && (string.IsNullOrEmpty(search.PersonalNumber) || a.Staff.PersonalNumber.Contains(search.PersonalNumber))
                && (string.IsNullOrEmpty(search.Firstname) || a.Staff.FirstName.Contains(search.Firstname))
                && (string.IsNullOrEmpty(search.Lastname) || a.Staff.LastName.Contains(search.Lastname)))
            .AsSplitQuery()
            .Select(a => new ReportVM
            {
                DepartmentId = a.DepartmentId,
                Department = user.Language == LanguageEnum.Albanian ? a.Department.NameSq : a.Department.NameEn,
                PersonalNumber = a.Staff.PersonalNumber,
                FirstName = a.Staff.FirstName,
                LastName = a.Staff.LastName,
                BirthDate = a.Staff.BirthDate.ToString("dd/MM/yyyy"),
                City = user.Language == LanguageEnum.Albanian ? a.Staff.City.NameSq : a.Staff.City.NameEn,
                Gender = user.Language == LanguageEnum.Albanian ? a.Staff.Gender.NameSq : a.Staff.Gender.NameEn,
                Email = a.Staff.Email ?? "///",
                PhoneNumber = string.IsNullOrEmpty(a.Staff.PhoneNumber) ? "///" : $"+{a.Staff.PhoneNumber}"
            }).ToListAsync();

        var dataSource = new List<ReportDataSource>() { new ReportDataSource("StaffDetails", staffList) };
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

        var reportByte = RDLCReport.GenerateReport("StaffList.rdl", dataSource, parameters, reportType, ReportOrientation.Portrait);
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
