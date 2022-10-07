using AMS.Resources;
using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;
using System.ComponentModel.DataAnnotations;
using System.Resources;

namespace AMS.Utilities.AttributeValidations;

[AttributeUsage(AttributeTargets.Property, AllowMultiple = false, Inherited = false)]
public class RequiredIfCheckedAttribute : ValidationAttribute, IClientModelValidator
{
    private readonly string dependsOn;
    private readonly bool valueOn;

    public RequiredIfCheckedAttribute(string dependsOn, bool valueOn)
    {
        this.dependsOn = dependsOn;
        this.valueOn = valueOn;
    }

    public void AddValidation(ClientModelValidationContext context)
    {
        var resourceManager = new ResourceManager(typeof(Resource));
        var localisedError = resourceManager.GetString(ErrorMessageResourceName);

        MergeAttribute(context.Attributes, "data-val", "true");
        MergeAttribute(context.Attributes, "data-val-requiredifchecked", localisedError);
        MergeAttribute(context.Attributes, "data-val-requiredifchecked-depend", dependsOn);
        MergeAttribute(context.Attributes, "data-val-requiredifchecked-value", valueOn.ToString());
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
        var dependedValue = value as decimal?;
        var instance = validationContext.ObjectInstance;
        var type = instance.GetType();

        var propertyDependedValue = (bool)type.GetProperty(dependsOn).GetValue(instance, null);
        if (valueOn == propertyDependedValue)
        {
            if (dependedValue is null)
            {
                var rm = new ResourceManager(typeof(Resource));
                string localisedError = rm.GetString(ErrorMessageResourceName);
                return new ValidationResult(localisedError);
            }
        }

        return ValidationResult.Success;
    }
}
