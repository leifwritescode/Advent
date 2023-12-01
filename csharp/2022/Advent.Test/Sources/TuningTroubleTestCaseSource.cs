using Advent.Solutions;

namespace Advent.Test.Sources;

internal class TuningTroubleTestCaseSource : AdventTestBase<TuningTrouble>
{
    public static new IEnumerable<IAdventTestCaseSource> ChallengeTestCaseSources()
    {
        yield return new AdventTestCaseSource("mjqjpqmgbljsphdztnvjfqwrcgsmlb", new[] { "7", "19" });
        yield return new AdventTestCaseSource("bvwbjplbgvbhsrlpgdmjqwftvncz", new[] { "5", "23" });
        yield return new AdventTestCaseSource("nppdvjthqldpwncqszvftbrmjlhg", new[] { "6", "23" });
        yield return new AdventTestCaseSource("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", new[] { "10", "29" });
        yield return new AdventTestCaseSource("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", new[] { "11", "26" });
    }
}
