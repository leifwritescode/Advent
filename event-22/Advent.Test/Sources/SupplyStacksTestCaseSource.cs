﻿using Advent.Solutions;

namespace Advent.Test.Sources;

internal class SupplyStacksTestCaseSource : AdventTestBase<SupplyStacks>
{
    public static new IEnumerable<IAdventTestCaseSource> ChallengeTestCaseSources()
    {
        yield return new AdventTestCaseSource("    [D]    \r\n[N] [C]    \r\n[Z] [M] [P]\r\n 1   2   3 \r\n\r\nmove 1 from 2 to 1\r\nmove 3 from 1 to 3\r\nmove 2 from 2 to 1\r\nmove 1 from 1 to 2", new[] { "CMZ", "MCD" });
    }
}
