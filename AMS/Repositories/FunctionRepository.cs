using AMS.Data;
using AMS.Data.SqlFunctions;
using AMS.Utilities;
using Microsoft.EntityFrameworkCore;

namespace AMS.Repositories;

public class FunctionRepository : IFunctionRepository
{
    private readonly ApplicationDbContext db;

    public FunctionRepository(ApplicationDbContext db)
    {
        this.db = db;
    }

    public async Task<List<MenuList>> MenuList(string role, LanguageEnum lang) =>
        await db.Set<MenuList>().FromSqlInterpolated(sql: $"SELECT * FROM [MenuList] ({role}, {lang})").ToListAsync();

    public async Task<List<MenuListAccess>> MenuListAccess(string role, LanguageEnum lang) =>
        await db.Set<MenuListAccess>().FromSqlInterpolated(sql: $"SELECT * FROM [MenuListAccess] ({role}, {lang})").ToListAsync();

    public async Task<List<Logs>> Logs(string roleId, string userId, DateTime startDate, DateTime endDate, string ip, string controller, string action, string httpMethod, bool error) =>
        await db.Set<Logs>().FromSqlInterpolated(sql: $"SELECT * FROM [Logs] ({roleId}, {userId}, {startDate}, {endDate}, {ip}, {controller}, {action}, {httpMethod}, {error})").ToListAsync();

    public async Task<List<AttendanceConsecutiveDays>> AttendanceConsecutiveDays(int? staffId, int? departmentId, int? staffTypeId, DateTime? startDate, DateTime? endDate, LanguageEnum language) =>
        await db.Set<AttendanceConsecutiveDays>().FromSqlInterpolated(sql: $"SELECT * FROM [AttendanceConsecutiveDays] ({staffId}, {departmentId}, {staffTypeId}, {startDate}, {endDate}, {language})").ToListAsync();

    public async Task<List<StaffConsecutiveDays>> StaffConsecutiveDays(int? staffId, int? departmentId, int? staffTypeId, LanguageEnum language) =>
        await db.Set<StaffConsecutiveDays>().FromSqlInterpolated(sql: $"SELECT * FROM [StaffConsecutiveDays] ({staffId}, {departmentId}, {staffTypeId}, {language})").ToListAsync();

    public async Task<List<SearchApplication>> SearchApplication(string title, string userId, LanguageEnum language) =>
        await db.Set<SearchApplication>().FromSqlInterpolated(sql: $"SELECT * FROM [SearchApplication] ({title}, {userId}, {language})").ToListAsync();

    public async Task<List<StaffListHistory>> StaffListHistory(int? staffId, int? departmentId, int? staffTypeId, DateTime? startDate, DateTime? endDate, string personalNumber, string firstName, string lastName, DateTime? birthDate, int? statusType, bool advanced, LanguageEnum language) =>
        await db.Set<StaffListHistory>().FromSqlInterpolated(sql: $"SELECT * FROM [StaffListHistory] ({staffId}, {departmentId}, {staffTypeId}, {startDate}, {endDate}, {personalNumber}, {firstName}, {lastName}, {birthDate}, {statusType}, {advanced}, {language})").ToListAsync();
}
