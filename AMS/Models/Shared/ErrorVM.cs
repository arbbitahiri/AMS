using AMS.Utilities;

namespace AMS.Models.Shared;

public class ErrorVM
{
    public string Title { get; set; }

    public ErrorStatus Status { get; set; }

    public string Description { get; set; }

    public bool RawContent { get; set; }

    public string Icon { get; set; }

    public string RequestId { get; set; }

    public bool ShowRequestId => !string.IsNullOrEmpty(RequestId);

    public bool Dismissible { get; set; }
}
