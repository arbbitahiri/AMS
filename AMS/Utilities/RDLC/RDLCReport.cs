using Microsoft.Reporting.NETCore;
using System.Reflection;

namespace AMS.Utilities.RDLC;

public class RDLCReport
{
    public static byte[] GenerateReport(string name, List<ReportDataSource> dataSources, List<ReportParameter> parameters, ReportType type, ReportOrientation orientation)
    {
        var localReport = new LocalReport();

        dataSources.ForEach(a => localReport.DataSources.Add(a));
        var resourceStream = Assembly.GetExecutingAssembly().GetManifestResourceStream($"AMS.Reports.{name}");

        localReport.LoadReportDefinition(resourceStream);
        localReport.SetParameters(parameters);

        string renderType = type switch
        {
            ReportType.PDF => "PDF",
            ReportType.Excel => "EXCELOPENXML",
            ReportType.Word => "WORDOPENXML",
            ReportType.Image => "IMAGE",
            _ => "PDF"
        };

        string deviceInfo = orientation switch
        {
            ReportOrientation.Portrait => "<DeviceInfo>" + "  <OutputFormat>PDF</OutputFormat>" + "  <PageWidth>8.27in</PageWidth>" + "  <PageHeight>11.69in</PageHeight>" + "  <MarginTop>0.0in</MarginTop>" + "  <MarginLeft>0.0in</MarginLeft>" + "  <MarginRight>0.0in</MarginRight>" + "  <MarginBottom>0.0in</MarginBottom>" + "</DeviceInfo>",
            ReportOrientation.Landscape => "<DeviceInfo>" + "  <OutputFormat>PDF</OutputFormat>" + "  <PageWidth>11.69in</PageWidth>" + "  <PageHeight>8.27in</PageHeight>" + "  <MarginTop>0.0in</MarginTop>" + "  <MarginLeft>0.0in</MarginLeft>" + "  <MarginRight>0.0in</MarginRight>" + "  <MarginBottom>0.0in</MarginBottom>" + "</DeviceInfo>",
            _ => "<DeviceInfo>" + "  <OutputFormat>PDF</OutputFormat>" + "  <PageWidth>11.69in</PageWidth>" + "  <PageHeight>8.27in</PageHeight>" + "  <MarginTop>0.0in</MarginTop>" + "  <MarginLeft>0.0in</MarginLeft>" + "  <MarginRight>0.0in</MarginRight>" + "  <MarginBottom>0.0in</MarginBottom>" + "</DeviceInfo>"
        };

        return localReport.Render(renderType, deviceInfo);
    }
}
