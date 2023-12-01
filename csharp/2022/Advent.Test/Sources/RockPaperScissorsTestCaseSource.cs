using Advent.Solutions;

namespace Advent.Test.Sources;

internal class RockPaperScissorsTestCaseSource : AdventTestBase<RockPaperScissors>
{
    public static new IEnumerable<IAdventTestCaseSource> ChallengeTestCaseSources()
    {
        yield return new AdventTestCaseSource("A Y\r\nB X\r\nC Z", new[] { "15", "12" });
    }
}
