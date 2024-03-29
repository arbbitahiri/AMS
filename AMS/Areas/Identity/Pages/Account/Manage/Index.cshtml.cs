﻿using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models.Shared;
using AMS.Resources;
using AMS.Utilities;
using AMS.Utilities.General;
using AMS.Utilities.AttributeValidations;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Versioning;

namespace AMS.Areas.Identity.Pages.Account.Manage;
public partial class IndexModel : BaseIModel
{
    private readonly IWebHostEnvironment hostEnvironment;
    private readonly IConfiguration configuration;

    public IndexModel(IWebHostEnvironment hostEnvironment, IConfiguration configuration,
        UserManager<ApplicationUser> userManager, SignInManager<ApplicationUser> signInManager, AMSContext db)
        : base(signInManager, userManager, db)
    {
        this.hostEnvironment = hostEnvironment;
        this.configuration = configuration;
    }

    public string Username { get; set; }

    public string Email { get; set; }

    [TempData]
    public string StatusMessage { get; set; }

    [BindProperty]
    public InputModel Input { get; set; }

    public class InputModel
    {
        [Display(Name = "Firstname", ResourceType = typeof(Resource))]
        [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
        public string FirstName { get; set; }

        [Display(Name = "Lastname", ResourceType = typeof(Resource))]
        [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
        public string LastName { get; set; }

        [Phone]
        [Display(Name = "PhoneNumber", ResourceType = typeof(Resource))]
        [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
        public string PhoneNumber { get; set; }

        [FileExtension(Constants.FileExtension, ErrorMessageResourceName = "AllowedFileFormats", ErrorMessageResourceType = typeof(Resource))]
        [MaxFileSize(Constants.MaxFileSize, ErrorMessageResourceName = "MaximumAllowedFileSize", ErrorMessageResourceType = typeof(Resource))]
        public IFormFile ProfileImage { get; set; }

        public string ImagePath { get; set; }
        public string Email { get; set; }
    }

    private void LoadAsync(ApplicationUser user)
    {
        Input = new InputModel
        {
            PhoneNumber = string.IsNullOrEmpty(user.PhoneNumber) ? "///" : $"+{user.PhoneNumber}",
            ImagePath = user.ProfileImage,
            FirstName = user.FirstName,
            LastName = user.LastName
        };
    }

    public async Task<IActionResult> OnGetAsync()
    {
        var user = await userManager.GetUserAsync(User);
        if (user == null)
        {
            TempData.Set("ErrorIdentity", new ErrorVM { Status = ErrorStatus.Error, Title = Resource.Error, Description = Resource.UnableToLoadUser });
            LoadAsync(user);
            return Page();
        }

        LoadAsync(user);
        return Page();
    }

    [SupportedOSPlatform("windows")]
    public async Task<IActionResult> OnPostAsync()
    {
        var user = await userManager.GetUserAsync(User);
        if (user == null)
        {
            TempData.Set("ErrorIdentity", new ErrorVM { Status = ErrorStatus.Error, Title = Resource.Error, Description = Resource.UnableToLoadUser });
            LoadAsync(user);
            return Page();
        }

        if (!ModelState.IsValid)
        {
            LoadAsync(user);
            TempData.Set("ErrorIdentity", new ErrorVM { Status = ErrorStatus.Success, Title = Resource.Success, Description = Resource.InvalidData });
            return Page();
        }

        await SendToHistory(user, "Ndryshim i të dhënave personale.");

        user.FirstName = Input.FirstName;
        user.LastName = Input.LastName;
        user.PhoneNumber = Input.PhoneNumber;
        if (Input.ProfileImage != null)
        {
            user.ProfileImage = await SaveFile(hostEnvironment, configuration, Input.ProfileImage, "Users");
        }

        await userManager.UpdateAsync(user);
        await signInManager.RefreshSignInAsync(user);

        TempData.Set("ErrorIdentity", new ErrorVM { Status = ErrorStatus.Success, Title = Resource.Success, Description = Resource.UpdatedProfile });
        return RedirectToPage();
    }
}
