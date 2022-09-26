﻿using AMS.Resources;
using System.ComponentModel.DataAnnotations;

namespace AMS.Areas.Authorization.Models.Menu;

public class Create
{
    [Display(Name = "NameSq", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string NameSq { get; set; }

    [Display(Name = "NameEn", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public string NameEn { get; set; }

    [Display(Name = "Controller", ResourceType = typeof(Resource))]
    public string Controller { get; set; }

    [Display(Name = "Action", ResourceType = typeof(Resource))]
    public string Action { get; set; }

    [Display(Name = "OrdinalNumber", ResourceType = typeof(Resource))]
    [Required(ErrorMessageResourceName = "RequiredField", ErrorMessageResourceType = typeof(Resource))]
    public int OrdinalNumber { get; set; }

    [Display(Name = "ClaimPolicy", ResourceType = typeof(Resource))]
    public string ClaimPolicy { get; set; }

    public bool HasSubMenu { get; set; }

    [Display(Name = "Icon", ResourceType = typeof(Resource))]
    public string Icon { get; set; }

    [Display(Name = "TagsSQ", ResourceType = typeof(Resource))]
    public string TagsSQ { get; set; }

    [Display(Name = "TagsEN", ResourceType = typeof(Resource))]
    public string TagsEN { get; set; }

    [Display(Name = "OpenFor", ResourceType = typeof(Resource))]
    public string OpenFor { get; set; }
}
