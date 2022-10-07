using AMS.Utilities;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace AMS.Repositories;

public interface IDDLRepository
{
    List<SelectListItem> Languages();

    List<SelectListItem> Controllers();

    List<SelectListItem> HttpMethods();

    Task<List<SelectListItem>> Genders(LanguageEnum language);

    Task<List<SelectListItem>> Roles(LanguageEnum language);

    Task<List<SelectListItem>> Cities(LanguageEnum language);

    Task<List<SelectListItem>> Countries(LanguageEnum language);

    Task<List<SelectListItem>> Departments(LanguageEnum language);

    Task<List<SelectListItem>> StaffTypes(LanguageEnum language);

    Task<List<SelectListItem>> DocumentTypes(LanguageEnum language);

    Task<List<SelectListItem>> AbsentTypes(LanguageEnum language);

    Task<List<SelectListItem>> StatusTypes(LanguageEnum language, bool staff = false);
}
