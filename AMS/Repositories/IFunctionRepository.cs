using AMS.Data.SqlFunctions;
using AMS.Utilities;

namespace AMS.Repositories;

public interface IFunctionRepository
{
    Task<List<MenuList>> MenuList(string role, LanguageEnum lang);

    Task<List<MenuListAccess>> MenuListAccess(string role, LanguageEnum lang);

    Task<List<Logs>> Logs(string roleId, string userId, DateTime startDate, DateTime endDate, string ip, string controller, string action, string httpMethod, int? error, bool advancedSearch);

    Task<List<AttendanceConsecutiveDays>> AttendanceConsecutiveDays(int? staffId, int? departmentId, int? staffTypeId, DateTime? startDate, DateTime? endDate, LanguageEnum language);

    Task<List<StaffConsecutiveDays>> StaffConsecutiveDays(int? staffId, int? departmentId, int? staffTypeId, LanguageEnum language);

    Task<List<SearchApplication>> SearchApplication(string title, string userId, LanguageEnum language);

    Task<List<StaffListHistory>> StaffListHistory(int? staffId, int? departmentId, int? staffTypeId, DateTime? startDate, DateTime? endDate, string personalNumber, string firstName, string lastName, DateTime? birthDate, int? statusType, bool advanced, LanguageEnum language);

    Task<List<TablesWithColumns>> TablesWithColumns();
}
