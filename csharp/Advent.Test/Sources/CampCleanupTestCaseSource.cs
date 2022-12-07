using Advent.Solutions;

namespace Advent.Test.Sources;

internal class CampCleanupTestCaseSource : AdventTestBase<CampCleanup>
{
    public static new IEnumerable<IAdventTestCaseSource> ChallengeTestCaseSources()
    {
        yield return new AdventTestCaseSource("2-4,6-8\r\n2-3,4-5\r\n5-7,7-9\r\n2-8,3-7\r\n6-6,4-6\r\n2-6,4-8", new[] { "2", "4" });
    }
}
