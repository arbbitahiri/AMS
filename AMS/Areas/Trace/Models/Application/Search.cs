﻿namespace AMS.Areas.Trace.Models.Application;

public class Search
{
    public string Role { get; set; }
    public string User { get; set; }
    public string Date { get; set; }
    public string Ip { get; set; }
    public string Controller { get; set; }
    public string Action { get; set; }
    public string HttpMethod { get; set; }
    public int? Error { get; set; }
    public bool AdvancedSearch { get; set; }
}
