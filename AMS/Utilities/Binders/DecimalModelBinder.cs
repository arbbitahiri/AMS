using Microsoft.AspNetCore.Mvc.ModelBinding;
using System.Globalization;

namespace AMS.Utilities.Binders;

public class DecimalModelBinderProvider : IModelBinderProvider
{
    public IModelBinder GetBinder(ModelBinderProviderContext context)
    {
        if (context is null)
        {
            throw new ArgumentNullException(nameof(context));
        }

        if (context.Metadata.ModelType == typeof(decimal) || context.Metadata.ModelType == typeof(decimal?))
        {
            return new DecimalModelBinder();
        }

        return null;
    }
}

public class DecimalModelBinder : IModelBinder
{
    public Task BindModelAsync(ModelBindingContext bindingContext)
    {
        var valueProviderResult = bindingContext.ValueProvider.GetValue(bindingContext.ModelName);

        var value = valueProviderResult.FirstValue;
        if (string.IsNullOrEmpty(value))
        {
            return Task.CompletedTask;
        }

        value = value.Replace(",", string.Empty).Trim();

        if (!decimal.TryParse(value, NumberStyles.Any, new CultureInfo("en-GB"), out decimal myValue))
        {
            bindingContext.ModelState.TryAddModelError(bindingContext.ModelName, "Could not parse MyValue.");
            return Task.CompletedTask;
        }

        bindingContext.Result = ModelBindingResult.Success(myValue);
        return Task.CompletedTask;
    }
}
