using AMS.Resources;
using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;
using System.ComponentModel.DataAnnotations;
using System.Resources;

namespace AMS.Utilities.Validation;

[AttributeUsage(AttributeTargets.Property, AllowMultiple = false, Inherited = false)]
public class FileExtensionAttribute : ValidationAttribute, IClientModelValidator
{
    private readonly string allowedFormats;

    public FileExtensionAttribute(string allowedFormats)
    {
        this.allowedFormats = allowedFormats;
    }

    public void AddValidation(ClientModelValidationContext context)
    {
        var resourceManager = new ResourceManager(typeof(Resource));
        MergeAttribute(context.Attributes, "data-val", "true");
        MergeAttribute(context.Attributes, "accept", allowedFormats);
        MergeAttribute(context.Attributes, "data-val-fileextesion", string.Format(resourceManager.GetString(ErrorMessageResourceName), allowedFormats));
        MergeAttribute(context.Attributes, "data-val-fileextesion-formats", allowedFormats);
    }

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
        string[] formats = allowedFormats.Split(",");
        if (value is IFormFile file)
        {
            string extension = Path.GetExtension(file.FileName);
            if (!formats.Contains(extension))
            {
                var resourceManager = new ResourceManager(typeof(Resource));
                return new ValidationResult(string.Format(resourceManager.GetString(ErrorMessageResourceName), allowedFormats));
            }
        }
        return ValidationResult.Success;
    }
}
