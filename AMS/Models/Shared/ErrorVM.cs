using AMS.Utilities;

namespace AMS.Models.Shared;

public class ErrorVM
{
    public string Title { get; set; }

    public ErrorStatus Status { get; set; }

    public string Description { get; set; }

    public bool RawContent { get; set; }

    public string Icon { get; set; }

    public bool Dismissible { get; set; }

    public bool Light { get; set; }
}
