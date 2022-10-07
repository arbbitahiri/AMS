namespace AMS.Areas.Trace.Models.Database;

public class DatabaseStructure
{
    public List<DatabaseTable> Tables { get; set; }
    public List<DatabaseFunction> Functions { get; set; }
    public List<DatabaseProcedure> Procedures { get; set; }
    public List<DatabaseTableColumn> TableColumns { get; set; }
}

public class DatabaseTable
{
    public string Name { get; set; }
    public string Schema { get; set; }
}

public class DatabaseFunction
{
    public string Name { get; set; }
    public string Schema { get; set; }
}

public class DatabaseProcedure
{
    public string Name { get; set; }

    public string Schema { get; set; }
}

public class DatabaseTableColumn
{
    public string Schema { get; set; }
    public string Table { get; set; }
    public List<string> Columns { get; set; }
}

public class DatabaseColumn
{
    public bool PrimaryKey { get; set; }
    public bool ForeignKey { get; set; }
    public string Type { get; set; }
    public string Name { get; set; }
    public bool AllowNull { get; set; }
}
