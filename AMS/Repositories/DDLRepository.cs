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

    public async Task<List<SelectListItem>> Genders(LanguageEnum language) =>
        await db.Gender.Select(a => new SelectListItem
        {
            Value = a.GenderId.ToString(),
            Text = language == LanguageEnum.Albanian ? a.NameSq : a.NameEn
        }).OrderBy(a => a.Text).ToListAsync();

    public async Task<List<SelectListItem>> Roles(LanguageEnum language) =>
        await db.AspNetRoles.Select(a => new SelectListItem
        {
            Value = a.Id,
            Text = language == LanguageEnum.Albanian ? a.NameSq : a.NameEn
        }).OrderBy(a => a.Text).ToListAsync();

    public async Task<List<SelectListItem>> Cities(LanguageEnum language) =>
        await db.City.Select(a => new SelectListItem
        {
            Value = a.CityId.ToString(),
            Text = language == LanguageEnum.Albanian ? a.NameSq : a.NameEn
        }).OrderBy(a => a.Text).ToListAsync();

    public async Task<List<SelectListItem>> Countries(LanguageEnum language) =>
        await db.Country.Select(a => new SelectListItem
        {
            Value = a.CountryId.ToString(),
            Text = language == LanguageEnum.Albanian ? a.NameSq : a.NameEn
        }).OrderBy(a => a.Text).ToListAsync();

    public async Task<List<SelectListItem>> Departments(LanguageEnum language) =>
        await db.Department.Select(a => new SelectListItem
        {
            Value = a.DepartmentId.ToString(),
            Text = language == LanguageEnum.Albanian ? a.NameSq : a.NameEn
        }).OrderBy(a => a.Text).ToListAsync();

    public async Task<List<SelectListItem>> StaffTypes(LanguageEnum language) =>
        await db.StaffType.Select(a => new SelectListItem
        {
            Value = a.StaffTypeId.ToString(),
            Text = language == LanguageEnum.Albanian ? a.NameSq : a.NameEn
        }).OrderBy(a => a.Text).ToListAsync();

    public async Task<List<SelectListItem>> DocumentTypes(LanguageEnum language) =>
        await db.DocumentType
            .OrderBy(a => language == LanguageEnum.Albanian ? a.NameSq : a.NameEn)
            .Where(a => a.Active)
            .Select(a => new SelectListItem
            {
                Value = a.DocumentTypeId.ToString(),
                Text = language == LanguageEnum.Albanian ? a.NameSq : a.NameEn
            }).ToListAsync();

    public async Task<List<SelectListItem>> AbsentTypes(LanguageEnum language) =>
        await db.AbsentType.Select(a => new SelectListItem
        {
            Value = a.AbsentTypeId.ToString(),
            Text = language == LanguageEnum.Albanian ? a.NameSq : a.NameEn
        }).OrderBy(a => a.Text).ToListAsync();
}
