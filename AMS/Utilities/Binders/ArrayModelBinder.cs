using Microsoft.AspNetCore.Mvc.ModelBinding;
using System.ComponentModel;

namespace AMS.Utilities.Binders;

public class ArrayModelBinderProvider : IModelBinderProvider
{
    public IModelBinder GetBinder(ModelBinderProviderContext context) =>
        ArrayModelBinder.IsSupportedModelType(context.Metadata.ModelType) ? new ArrayModelBinder() : null;
}

public class ArrayModelBinder : IModelBinder
{
    private static readonly Type[] supportedTypes = { typeof(string), typeof(int), typeof(long), typeof(short), typeof(byte), typeof(uint), typeof(ulong), typeof(ushort), typeof(Guid) };

    internal static bool IsSupportedModelType(Type modelType) =>
        modelType.IsArray && modelType.GetArrayRank() == 1 && modelType.HasElementType && supportedTypes.Contains(modelType.GetElementType());

    private static Array CopyAndConvertArray<T>(IReadOnlyList<T> sourceArray, Type elementType)
    {
        var targetArray = Array.CreateInstance(elementType, sourceArray.Count);
        if (sourceArray.Any())
        {
            if (!string.IsNullOrEmpty(sourceArray[0].ToString()))
            {
                var converter = TypeDescriptor.GetConverter(elementType);
                for (int i = 0; i < sourceArray.Count; i++)
                {
                    targetArray.SetValue(converter.ConvertFromString(sourceArray[0].ToString()), i);
                }
            }
        }
        return targetArray;
    }

    public Task BindModelAsync(ModelBindingContext bindingContext)
    {
        if (!IsSupportedModelType(bindingContext.ModelType))
        {
            return Task.CompletedTask;
        }

        var valueProviderResult = bindingContext.ValueProvider.GetValue(bindingContext.ModelName);

        var stringArray = valueProviderResult.Values.ToArray();
        if (stringArray is null)
        {
            return Task.CompletedTask;
        }

        var elementType = bindingContext.ModelType.GetElementType();
        if (elementType is null)
        {
            return Task.CompletedTask;
        }

        if (stringArray.Any())
        {
            bindingContext.Result = ModelBindingResult.Success(CopyAndConvertArray(stringArray[0].Split(","), elementType));
        }
        return Task.CompletedTask;
    }
}
