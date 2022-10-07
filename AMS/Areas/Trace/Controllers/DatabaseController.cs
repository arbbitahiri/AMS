using AMS.Areas.Trace.Models.Database;
using AMS.Controllers;
using AMS.Data.Core;
using AMS.Data.General;
using AMS.Models.Shared;
using AMS.Repositories;
using AMS.Resources;
using AMS.Utilities;
using AMS.Utilities.General;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.SqlServer.Management.Smo;

namespace AMS.Areas.Trace.Controllers;

[Route("/{area}/{controller}/{action}")]
public class DataBaseController : BaseController
{
    private readonly IFunctionRepository function;
    private readonly string connectionString;

    public DataBaseController(IConfiguration configuration, IFunctionRepository function,
        AMSContext db, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        : base(db, signInManager, userManager)
    {
        this.function = function;
        connectionString = configuration.GetConnectionString("SqlConnection");
    }

    #region Index

    [Authorize(Policy = "62:m"), Description("Arb Tahiri", "Entry form for security logs.")]
    public async Task<IActionResult> Index()
    {
        ViewData["Title"] = Resource.Database;

        var serverDatabase = GetDatabaseData(connectionString);

        var tables = new List<DatabaseTable>();
        foreach (Table table in serverDatabase.Tables)
        {
            tables.Add(new DatabaseTable
            {
                Name = table.Name,
                Schema = table.Schema
            });
        }

        var functions = new List<DatabaseFunction>();
        foreach (UserDefinedFunction function in serverDatabase.UserDefinedFunctions)
        {
            if (function.Schema == "dbo")
            {
                functions.Add(new DatabaseFunction
                {
                    Name = function.Name,
                    Schema = function.Schema
                });
            }
        }

        var procedures = new List<DatabaseProcedure>();
        foreach (StoredProcedure procedure in serverDatabase.StoredProcedures)
        {
            if (procedure.Schema == "dbo")
            {
                procedures.Add(new DatabaseProcedure
                {
                    Name = procedure.Name,
                    Schema = procedure.Schema
                });
            }
        }

        var tableColumns = (await function.TablesWithColumns())
            .OrderBy(a => a.Schema).ThenBy(a => a.Table)
            .GroupBy(a => a.Table)
            .Select(a => new DatabaseTableColumn
            {
                Schema = a.Select(a => a.Schema).FirstOrDefault(),
                Table = a.Key,
                Columns = a.Select(a => a.Column).ToList()
            }).ToList();

        var databaseStructure = new DatabaseStructure
        {
            Tables = tables,
            Functions = functions,
            Procedures = procedures,
            TableColumns = tableColumns
        };
        return View(databaseStructure);
    }

    #endregion

    #region Structure

    [HttpGet, Description("Arb Tahiri", "Action to get list of columns for specific table.")]
    public IActionResult GetColumns(string name, string schema)
    {
        var serverDatabase = GetDatabaseData(connectionString);
        var table = serverDatabase.Tables[name, schema];

        var columns = new List<DatabaseColumn>();
        foreach (Column column in table.Columns)
        {
            columns.Add(new DatabaseColumn
            {
                Name = column.Name,
                Type = column.DataType.Name,
                PrimaryKey = column.InPrimaryKey,
                ForeignKey = column.IsForeignKey,
                AllowNull = column.Nullable
            });
        }
        return PartialView(columns);
    }

    [HttpGet, Description("Arb Tahiri", "Action to get function query.")]
    public IActionResult GetFunction(string name, string schema)
    {
        var serverDatabase = GetDatabaseData(connectionString);
        var function = serverDatabase.UserDefinedFunctions[name, schema];
        return Json(function.TextHeader + function.TextBody);
    }

    [HttpGet, Description("Arb Tahiri", "Action to get procedure query.")]
    public IActionResult GetProcedure(string name, string schema)
    {
        var serverDatabase = GetDatabaseData(connectionString);
        var function = serverDatabase.StoredProcedures[name, schema];
        return Json(function.TextHeader + function.TextBody);
    }

    #endregion

    #region Execute query

    [HttpPost, ValidateAntiForgeryToken]
    [Description("Arb Tahiri", "Action to execute sql queries in database.")]
    public async Task<IActionResult> ExecuteQuery(string query)
    {
        var result = new DatabaseResult { Error = new ErrorVM { Status = ErrorStatus.Success } };

        var queryResult = new List<string[]>();
        var executed = true;
        using (var command = db.Database.GetDbConnection().CreateCommand())
        {
            command.CommandText = query;
            command.CommandTimeout = 0;
            db.Database.OpenConnection();
            try
            {
                using (var reader = await command.ExecuteReaderAsync())
                {
                    var columnsNo = reader.FieldCount;
                    var header = new string[columnsNo];
                    for (int i = 0; i < columnsNo; i++)
                    {
                        header[i] = reader.GetName(i);
                    }
                    queryResult.Add(header);

                    while (reader.Read())
                    {
                        var rows = new string[columnsNo];
                        for (int i = 0; i < columnsNo; i++)
                        {
                            rows[i] = reader.GetValue(i).ToString();
                        }
                        queryResult.Add(rows);
                    }
                }
                result.Results = queryResult;
            }
            catch (Exception ex)
            {
                executed = false;
                await LogError(ex);
                result.Error = new ErrorVM { Status = ErrorStatus.Error, Description = Resource.NoCommandExecuted };
            }
        }

        if (executed)
        {
            db.DatabaseQuery.Add(new DatabaseQuery
            {
                Query = query,
                InsertedDate = DateTime.Now,
                InsertedFrom = user.Id
            });
            await db.SaveChangesAsync();
        }
        return Json(result);
    }

    #endregion

    #region Report

    #endregion

    #region Methods

    private static string GetConnectionInfo(string connectionString, ConnectionString connection) =>
        connectionString.Split(";")[(int)connection - 1].Split("=")[1];

    private static Database GetDatabaseData(string connectionString)
    {
        var server = new Server(GetConnectionInfo(connectionString, ConnectionString.ServerName));
        server.ConnectionContext.LoginSecure = false;
        server.ConnectionContext.Login = GetConnectionInfo(connectionString, ConnectionString.UserId);
        server.ConnectionContext.Password = GetConnectionInfo(connectionString, ConnectionString.Password);

        return server.Databases[GetConnectionInfo(connectionString, ConnectionString.Database)];
    }

    #endregion
}
