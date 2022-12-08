using Advent.Solutions;

namespace Advent.Test.Sources;

internal class TreetopTreeHouseTestCaseSource : AdventTestBase<TreetopTreeHouse>
{
    public static new IEnumerable<IAdventTestCaseSource> ChallengeTestCaseSources()
    {
        yield return new AdventTestCaseSource("", new[] { "", "" });
    }
}
