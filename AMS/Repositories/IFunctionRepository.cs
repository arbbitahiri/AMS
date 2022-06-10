﻿using AMS.Data.SqlFunctions;
using AMS.Utilities;

namespace AMS.Repositories;

public interface IFunctionRepository
{
    Task<List<MenuList>> MenuList(string role, LanguageEnum lang);

    Task<List<MenuListAccess>> MenuListAccess(string role, LanguageEnum lang);

    Task<List<Logs>> Logs(string roleId, string userId, DateTime startDate, DateTime endDate, string ip, string controller, string action, string httpMethod, bool error);
}
