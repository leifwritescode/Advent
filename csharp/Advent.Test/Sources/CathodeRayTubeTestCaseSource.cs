using Advent.Solutions;

namespace Advent.Test.Sources;

internal class CathodeRayTubeTestCaseSource : AdventTestBase<CathodeRayTube>
{
    public static new IEnumerable<IAdventTestCaseSource> ChallengeTestCaseSources()
    {
        yield return new AdventTestCaseSource("", new[] { "", "" });
    }
}
