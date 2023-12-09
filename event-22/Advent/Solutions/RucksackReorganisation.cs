using Advent.Contracts;
using Microsoft.Extensions.Logging;

namespace Advent.Solutions;

internal class RucksackReorganisation : SolutionBase
{
    private static readonly string priority = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

    public RucksackReorganisation(ILogger<RucksackReorganisation> logger, IInstrument instrument)
        : base(logger, instrument, 3)
    {
    }

    protected override async Task<string> SolvePartOneAsync(IContext context)
    {
        var score = context.Input
            .Trim()
            .ReplaceLineEndings()
            .Split(Environment.NewLine)
            .Select(x => x.Insert(x.Length / 2, "-").Split('-'))
            .Aggregate(0, (a, c) => priority.IndexOf(c.First().Intersect(c.Last()).Single()) + 1 + a);

        return await Task.FromResult(score.ToString());
    }

    protected override async Task<string> SolvePartTwoAsync(IContext context)
    {
        var score = context.Input
            .Trim()
            .ReplaceLineEndings()
            .Split(Environment.NewLine)
            // create an index we can group by
            .Select((value, index) => new { value, index })
            // group by the index / 3, which rounds down -- 0,1,2 = 0; 3,4,5 = 1 etc.
            .GroupBy(x => x.index / 3)
            // reduce the groups down to the intersection of their items
            .Select(x => x.Aggregate(priority, (a, v) => string.Concat(a.Intersect(v.value))))
            // result should be a list of characters, reduce to value of character in priority list
            .Aggregate(0, (a, v) => priority.IndexOf(v.Single()) + 1 + a);

        return await Task.FromResult(score.ToString());
    }
}
