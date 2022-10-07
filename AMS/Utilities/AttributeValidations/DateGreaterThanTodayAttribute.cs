using AMS.Resources;
using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;
using System.ComponentModel.DataAnnotations;
using System.Resources;

namespace AMS.Utilities.AttributeValidations;

[AttributeUsage(AttributeTargets.Property, AllowMultiple = false, Inherited = false)]
public class DateGreaterThanTodayAttribute : ValidationAttribute, IClientModelValidator
{
    public DateGreaterThanTodayAttribute()
    {
    }

    public void AddValidation(ClientModelValidationContext context)
    {
        var resourceManager = new ResourceManager(typeof(Resource));
        var localisedError = resourceManager.GetString(ErrorMessageResourceName);
        MergeAttribute(context.Attributes, "data-val", "true");
        MergeAttribute(context.Attributes, "data-val-dategreaterthantoday", localisedError);
    }

    static bool MergeAttribute(IDictionary<string, string> attributes, string key, string value)
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
        var selectedDate = value as DateTime?;
        var dateValue = selectedDate.Value;
        var today = DateTime.Now.Date - new DateTime(1970, 1, 1, 0, 0, 0, 0).ToLocalTime();
        var selectedValue = dateValue - new DateTime(1970, 1, 1, 0, 0, 0, 0).ToLocalTime();

        if (selectedDate is null)
        {
            return ValidationResult.Success;
        }
        if (selectedValue.TotalMilliseconds >= today.TotalMilliseconds)
        {
            return ValidationResult.Success;
        }
        var rm = new ResourceManager(typeof(Resource));
        string localizedError = rm.GetString(ErrorMessageResourceName);
        return new ValidationResult(localizedError);
    }
}
