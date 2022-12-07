using Advent.Solutions;

namespace Advent.Test.Sources;

internal class CalorieCountingTest : AdventTestBase<CalorieCounting>
{
    public static new IEnumerable<IAdventTestCaseSource> ChallengeTestCaseSources()
    {
        yield return new AdventTestCaseSource("1000\r\n2000\r\n3000\r\n\r\n4000\r\n\r\n5000\r\n6000\r\n\r\n7000\r\n8000\r\n9000\r\n\r\n10000", new[] { "24000", "45000" });
    }
}
