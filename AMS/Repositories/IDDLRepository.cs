using AMS.Utilities;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace AMS.Repositories;

public interface IDDLRepository
{
    List<SelectListItem> Languages();

    List<SelectListItem> Genders();

    Task<List<SelectListItem>> Roles(LanguageEnum language);
}
