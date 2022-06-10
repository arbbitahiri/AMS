namespace AMS.Utilities;

public enum Status
{

}

public enum ErrorStatus
{
    Success = 1,
    Error = 2,
    Warning = 3,
    Info = 4
}

public enum TemplateMode
{
    Light = 1,
    Dark = 2
}

public enum LanguageEnum
{
    Albanian = 1,
    English = 2
}

public enum GenderEnum
{
    Male = 1,
    Female = 2
}

public enum ReportType
{
    PDF = 1,
    Excel = 2,
    Word = 3,
    CSV = 4,
    XML = 5,
    JSON = 6,
    Image = 7
}

public enum ReportOrientation
{
    Landscape = 1,
    Portrait = 2
}

public enum NotificationTypeEnum
{
    Success = 1,
    Info = 2,
    Warning = 3,
    Error = 4,
    Question = 5
}

public enum StaffTypeEnum
{
    Administrator = 1
}

public enum ImageSizeType
{
    ProfilePhoto = 512,
    News = 1280
}

public enum LookUpTable
{
    City = 1,
    Country = 2,
    Status = 3,
    Absent = 4,
    Department = 5,
    Document = 6,
    Staff = 7
}
