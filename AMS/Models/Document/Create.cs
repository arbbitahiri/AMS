﻿using AMS.Resources;
using AMS.Utilities.AttributeValidations;
using AMS.Utilities.General;
using System.ComponentModel.DataAnnotations;

namespace AMS.Models.Document;

public class Create
{
    [Display(Name = "Staff", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public int AStaffId { get; set; }

    [Display(Name = "DocumentType", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public int ADocumentTypeId { get; set; }

    [Display(Name = "Title", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string ATitle { get; set; }

    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public bool Expires { get; set; }

    [Display(Name = "ExpireDate", ResourceType = typeof(Resource))]
    [RequiredIfChecked(nameof(Expires), true, ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public DateTime? ExpireDate { get; set; }

    [Display(Name = "Document", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    [FileExtension(Constants.FileExtension, ErrorMessageResourceName = "AllowedFileFormats", ErrorMessageResourceType = typeof(Resource))]
    [MaxFileSize(Constants.MaxFileSize, ErrorMessageResourceName = "MaximumAllowedFileSize", ErrorMessageResourceType = typeof(Resource))]
    public IFormFile FormFile { get; set; }

    [Display(Name = "Description", ResourceType = typeof(Resource))]
    public string Description { get; set; }

    public string FileSize { get; set; }
}
