using Advent.Solutions;

namespace Advent.Test.Sources;

internal class Day9TestCaseSource : AdventTestBase<Day9>
{
    public static new IEnumerable<IAdventTestCaseSource> ChallengeTestCaseSources()
    {
        yield return new AdventTestCaseSource("", new[] { "", "" });
    }
}
