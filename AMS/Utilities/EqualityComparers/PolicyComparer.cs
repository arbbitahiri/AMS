using AMS.Areas.Authorization.Models.Authorizations;
using System.Diagnostics.CodeAnalysis;

namespace AMS.Utilities.EqualityComparers;

public class PolicyComparer : IEqualityComparer<Rule>
{
    public bool Equals(Rule x, Rule y)
    {
        return x.Policy == y.Policy;
    }

    public int GetHashCode([DisallowNull] Rule obj)
    {
        return obj.Policy.GetHashCode();
    }
}
