using AMS.Data.General;
using AMS.Resources;
using AMS.Utilities;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace AMS.Repositories;

public class DDLRepository : IDDLRepository
{
    private readonly AMSContext db;

    public DDLRepository(AMSContext db)
    {
        this.db = db;
    }

    public List<SelectListItem> Languages() => new()
    {
        new SelectListItem { Text = Resource.Albanian, Value = LanguageEnum.Albanian.ToString() },
        new SelectListItem { Text = Resource.English, Value = LanguageEnum.English.ToString() }
    };

    public List<SelectListItem> Genders() => new()
    {
        new SelectListItem { Value = ((int)GenderEnum.Male).ToString(), Text = Resource.Male },
        new SelectListItem { Value = ((int)GenderEnum.Female).ToString(), Text = Resource.Female },
    };

    public async Task<List<SelectListItem>> Roles(LanguageEnum language) =>
        await db.AspNetRoles.Select(a => new SelectListItem
        {
            Value = a.Id,
            Text = language == LanguageEnum.Albanian ? a.NameSq : a.NameEn
        }).OrderBy(a => a.Text).ToListAsync();
}
