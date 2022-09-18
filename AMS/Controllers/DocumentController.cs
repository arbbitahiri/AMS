using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models.Document;
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

public class DocumentController : BaseController
{
    private readonly IConfiguration configuration;
    private readonly IWebHostEnvironment environment;

    public DocumentController(IConfiguration configuration, IWebHostEnvironment environment,
        AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
        this.configuration = configuration;
        this.environment = environment;
    }

    #region List

    [HttpGet, Authorize(Policy = "25:m")]
    [Description("Arb Tahiri", "Form to display list of documents.")]
    public IActionResult Index() => View();

    [HttpPost, ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to search for the list of documents.")]
    public async Task<IActionResult> Search(Search search)
    {
        var title = !string.IsNullOrEmpty(search.Title) ? search.Title.ToLower() : "";
        var documents = await db.StaffDocument
            .Where(a => (string.IsNullOrEmpty(search.Title) || a.Title.ToLower().Contains(title))
                && a.StaffId == (search.StaffId ?? a.StaffId)
                && a.DocumentTypeId == (search.DocumentTypeId ?? a.DocumentTypeId)
                && (!search.InsertDate.HasValue || a.InsertedDate.Date == search.InsertDate.Value.Date))
            .Select(a => new DocumentList
            {
                StaffDocumentIde = CryptoSecurity.Encrypt(a.StaffDocumentId),
                PersonalNumber = a.Staff.PersonalNumber,
                FirstName = a.Staff.FirstName,
                LastName = a.Staff.LastName,
                Title = a.Title,
                DocumentType = user.Language == LanguageEnum.Albanian ? a.DocumentType.NameSq : a.DocumentType.NameEn,
                FileType = Path.GetExtension(a.Path).ToLower(),
                Description = a.Description
            }).ToListAsync();
        return Json(documents);
    }

    #endregion

    #region Create

    [HttpGet, Authorize(Policy = "25:c")]
    [Description("Arb Tahiri", "Form to add documents.")]
    public IActionResult Create() => PartialView(new Create { FileSize = $"{Convert.ToDecimal(configuration["AppSettings:FileMaxKB"]) / 1024:N1}MB" });

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "25:c")]
    [Description("Arb Tahiri", "Action to add documents.")]
    public async Task<IActionResult> Create(Create create)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
        }

        string path = await SaveFile(environment, configuration, create.FormFile, "StaffDocuments", null);
        db.Add(new StaffDocument
        {
            StaffId = create.StaffId,
            DocumentTypeId = create.DocumentTypeId,
            Title = create.Title,
            Path = path,
            Description = create.Description,
            Active = true,
            InsertedDate = DateTime.Now,
            InsertedFrom = user.Id
        });

        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = Resource.DataRegisteredSuccessfully });
    }

    #endregion

    #region Edit

    [HttpGet, Authorize(Policy = "25:e")]
    [Description("Arb Tahiri", "Form to edit a document.")]
    public async Task<IActionResult> Edit(string ide)
    {
        var document = await db.StaffDocument
            .Where(a => a.StaffDocumentId == CryptoSecurity.Decrypt<int>(ide))
            .Select(a => new Edit
            {
                StaffDocumentIde = ide,
                StaffName = $"{a.Staff.FirstName} {a.Staff.LastName} - ({a.Staff.PersonalNumber})",
                DocumentTypeId = a.DocumentTypeId,
                Title = a.Title,
                Description = a.Description
            }).FirstOrDefaultAsync();

        return View(document);
    }

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "25:e")]
    [Description("Arb Tahiri", "Action to edit a document.")]
    public async Task<IActionResult> Edit(Edit edit)
    {
        if (!ModelState.IsValid)
        {
            return Json(new ErrorVM { Status = ErrorStatus.Warning, Description = Resource.InvalidData });
        }

        var staffDocumentId = CryptoSecurity.Decrypt<int>(edit.StaffDocumentIde);
        var document = await db.StaffDocument.FirstOrDefaultAsync(a => a.StaffDocumentId == staffDocumentId);
        document.DocumentTypeId = edit.DocumentTypeId;
        document.Title = edit.Title;
        document.Description = edit.Description;
        document.UpdatedDate = DateTime.Now;
        document.UpdatedFrom = user.Id;
        document.UpdatedNo = UpdateNo(document.UpdatedNo);

        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = Resource.DataUpdatedSuccessfully });
    }

    #endregion

    #region Delete

    [HttpPost, ValidateAntiForgeryToken, Authorize(Policy = "25:d")]
    [Description("Arb Tahiri", "Action to delete a document.")]
    public async Task<IActionResult> Delete(string ide)
    {
        var staffDocumentId = CryptoSecurity.Decrypt<int>(ide);
        var document = await db.StaffDocument.FirstOrDefaultAsync(a => a.StaffDocumentId == staffDocumentId);
        document.Active = false;
        document.UpdatedDate = DateTime.Now;
        document.UpdatedFrom = user.Id;
        document.UpdatedNo = UpdateNo(document.UpdatedNo);

        await db.SaveChangesAsync();
        return Json(new ErrorVM { Status = ErrorStatus.Success, Description = Resource.DataDeletedSuccessfully });
    }

    #endregion
}
