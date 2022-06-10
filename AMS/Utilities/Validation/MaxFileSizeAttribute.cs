﻿using AMS.Resources;
using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;
using System.ComponentModel.DataAnnotations;
using System.Resources;

namespace AMS.Utilities.Validation;

[AttributeUsage(AttributeTargets.Property, AllowMultiple = false, Inherited = false)]
public class MaxFileSizeAttribute : ValidationAttribute, IClientModelValidator
{
    private readonly int maxKb;

    public MaxFileSizeAttribute(int maxKb)
    {
        this.maxKb = maxKb;
    }

    public void AddValidation(ClientModelValidationContext context)
    {
        var resourceManager = new ResourceManager(typeof(Resource));
        MergeAttribute(context.Attributes, "data-val", "true");
        MergeAttribute(context.Attributes, "data-val-maxfilesize", string.Format(resourceManager.GetString(ErrorMessageResourceName), KbToMb(maxKb)));
        MergeAttribute(context.Attributes, "data-val-maxfilesize-size", maxKb.ToString());
    }

    private static string KbToMb(int kb) => $"{kb / 1024:###,###.##} Mb";

    private static bool MergeAttribute(IDictionary<string, string> attributes, string key, string value)
    {
        if (attributes.ContainsKey(key))
        {
            return false;
        }
        attributes.Add(key, value);
        return true;
    }

    protected override ValidationResult IsValid(object value, ValidationContext validationContext)
    {
        if (value is IFormFile file)
        {
            if (file.Length / 1024 > maxKb)
            {
                var resourceManager = new ResourceManager(typeof(Resource));
                return new ValidationResult(string.Format(resourceManager.GetString(ErrorMessageResourceName), KbToMb(maxKb)));
            }
        }
        return ValidationResult.Success;
    }
}
