using AMS.Resources;
using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;
using System.ComponentModel.DataAnnotations;
using System.Resources;

namespace AMS.Utilities.AttributeValidations;

[AttributeUsage(AttributeTargets.Property, AllowMultiple = false, Inherited = false)]
public class DateCompareAttribute : ValidationAttribute, IClientModelValidator
{
    private readonly string DependsOn;
    private readonly string ValueOn;

    public DateCompareAttribute(string dependsOn, string valueOn)
    {
        DependsOn = dependsOn;
        ValueOn = valueOn;
    }

    public void AddValidation(ClientModelValidationContext context)
    {
        var resourceManager = new ResourceManager(typeof(Resource));
        var localisedError = resourceManager.GetString(ErrorMessageResourceName);

        MergeAttribute(context.Attributes, "data-val", "true");
        MergeAttribute(context.Attributes, "data-val-datecompare", localisedError);
        MergeAttribute(context.Attributes, "data-val-datecompare-value", DependsOn);
        MergeAttribute(context.Attributes, "data-val-datecompare-valueon", ValueOn);
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
        if (value is null)
        {
            return ValidationResult.Success;
        }

        var dependValue = value as DateTime?;
        object instance = validationContext.ObjectInstance;
        var type = instance.GetType();

        _ = bool.TryParse(type.GetProperty(DependsOn).GetValue(instance)?.ToString(), out bool propertyValue);
        var propertyDependValue = type.GetProperty(DependsOn).GetValue(instance, null) as DateTime?;

        if (propertyDependValue > dependValue)
        {
            var resourceManager = new ResourceManager(typeof(Resource));
            var localisedError = resourceManager.GetString(ErrorMessageResourceName);
            return new ValidationResult(localisedError);
        }
        return ValidationResult.Success;
    }
}
