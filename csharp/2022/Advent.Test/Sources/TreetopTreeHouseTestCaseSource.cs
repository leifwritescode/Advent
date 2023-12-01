using Advent.Solutions;

namespace Advent.Test.Sources;

internal class TreetopTreeHouseTestCaseSource : AdventTestBase<TreetopTreeHouse>
{
    public static new IEnumerable<IAdventTestCaseSource> ChallengeTestCaseSources()
    {
        yield return new AdventTestCaseSource("30373\n25512\n65332\n33549\n35390", new[] { "21", "8" });
    }
}
