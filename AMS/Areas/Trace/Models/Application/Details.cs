using AMS.Resources;
using System.ComponentModel.DataAnnotations;

namespace AMS.Areas.Trace.Models.Application;

public class Details
{
    [Display(Name = "IPAddress", ResourceType = typeof(Resource))]
    public string Ip { get; set; }

    [Display(Name = "Url", ResourceType = typeof(Resource))]
    public string Url { get; set; }

    [Display(Name = "InsertedDate", ResourceType = typeof(Resource))]
    public string InsertedDate { get; set; }

    [Display(Name = "Controller", ResourceType = typeof(Resource))]
    public string Controller { get; set; }

    [Display(Name = "Action", ResourceType = typeof(Resource))]
    public string Action { get; set; }

    [Display(Name = "Title", ResourceType = typeof(Resource))]
    public string Title { get; set; }

    [Display(Name = "HttpMethod", ResourceType = typeof(Resource))]
    public string HttpMethod { get; set; }

    [Display(Name = "Username", ResourceType = typeof(Resource))]
    public string Username { get; set; }

    [Display(Name = "IsError", ResourceType = typeof(Resource))]
    public string Error { get; set; }

    [Display(Name = "Exception", ResourceType = typeof(Resource))]
    public string Exception { get; set; }

    [Display(Name = "FormContent", ResourceType = typeof(Resource))]
    public string FormContent { get; set; }
}
