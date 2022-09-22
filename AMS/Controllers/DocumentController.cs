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
using Microsoft.AspNetCore.StaticFiles;
using Microsoft.EntityFrameworkCore;
using System.Net.Mime;

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
                && (!search.InsertDate.HasValue || a.InsertedDate.Date == search.InsertDate.Value.Date)
                && (!search.ExpireId.HasValue || (search.ExpireId.Value == 1 ? a.ExpirationDate.HasValue : !a.ExpirationDate.HasValue)))
            .Select(a => new DocumentList
            {
                StaffDocumentIde = CryptoSecurity.Encrypt(a.StaffDocumentId),
                PersonalNumber = a.Staff.PersonalNumber,
                FirstName = a.Staff.FirstName,
                LastName = a.Staff.LastName,
                Title = a.Title,
                DocumentType = user.Language == LanguageEnum.Albanian ? a.DocumentType.NameSq : a.DocumentType.NameEn,
                FileType = Path.GetExtension(a.Path).ToLower(),
                Expires = a.ExpirationDate.HasValue,
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

        DateTime? expirationDate = create.Expires ? DateTime.ParseExact(create.ExpireDate, "dd/MM/yyyy", null) : null;

        string path = await SaveFile(configuration, create.FormFile, "StaffDocuments", null);
        db.Add(new StaffDocument
        {
            StaffId = create.AStaffId,
            DocumentTypeId = create.ADocumentTypeId,
            Title = create.ATitle,
            Path = path,
            Description = create.Description,
            ExpirationDate = expirationDate,
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
                EDocumentTypeId = a.DocumentTypeId,
                ETitle = a.Title,
                Description = a.Description,
                Expires = a.ExpirationDate.HasValue,
                ExpireDate = a.ExpirationDate.HasValue ? a.ExpirationDate.Value.ToString("dd/MM/yyyy") : null
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

        DateTime? expirationDate = edit.Expires ? DateTime.ParseExact(edit.ExpireDate, "dd/MM/yyyy", null) : null;

        var staffDocumentId = CryptoSecurity.Decrypt<int>(edit.StaffDocumentIde);
        var document = await db.StaffDocument.FirstOrDefaultAsync(a => a.StaffDocumentId == staffDocumentId);
        document.DocumentTypeId = edit.EDocumentTypeId;
        document.Title = edit.ETitle;
        document.Description = edit.Description;
        document.ExpirationDate = expirationDate;
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

    #region Download

    [HttpGet, Description("Arb Tahiri", "Action to download document.")]
    public async Task<IActionResult> Download(string ide)
    {
        var documentId = CryptoSecurity.Decrypt<int>(ide);
        var document = await db.StaffDocument.FirstOrDefaultAsync(a => a.Active && a.StaffDocumentId == documentId);

        string extension = Path.GetExtension(document.Path);
        var fileStream = new FileStream(configuration["AppSettings:FilePath"] + document.Path, FileMode.Open, FileAccess.Read);
        var contentDisposition = new ContentDisposition
        {
            FileName = document.Title + extension,
            Inline = true
        };

        Response.Headers.Add("Content-Disposition", contentDisposition.ToString());

        var fileProvider = new FileExtensionContentTypeProvider();
        if (!fileProvider.TryGetContentType(contentDisposition.FileName, out string contentType))
        {
            throw new ArgumentOutOfRangeException($"Unable to find Content Type for file name {contentDisposition.FileName}.");
        }
        return File(fileStream, contentType);
    }

    #endregion
}
