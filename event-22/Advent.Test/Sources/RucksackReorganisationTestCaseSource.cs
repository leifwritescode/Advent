using Advent.Solutions;

namespace Advent.Test.Sources;

internal class RucksackReorganisationTestCaseSource : AdventTestBase<RucksackReorganisation>
{
    public static new IEnumerable<IAdventTestCaseSource> ChallengeTestCaseSources()
    {
        yield return new AdventTestCaseSource("vJrwpWtwJgWrhcsFMMfFFhFp\r\njqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL\r\nPmmdzqPrVvPwwTWBwg\r\nwMqvLMZHhHMvwLHjbvcjnnSBnvTQFn\r\nttgJtRGJQctTZtZT\r\nCrZsJsPPZsGzwwsLwLmpwMDw", new[] { "157", "70" });
    }
}
