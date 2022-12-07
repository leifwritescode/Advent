using Advent.Contracts;
using Microsoft.Extensions.Logging;

namespace Advent.Solutions;

internal sealed class CalorieCounting : SolutionBase
{
    public CalorieCounting(IInstrument instrument, ILogger<ISolution> logger)
        : base(logger, instrument, 1) { }

    protected override async Task<string> SolvePartOneAsync(IContext context)
    {
        var ints = context.Input
            .Trim()
            .ReplaceLineEndings()
            .Split($"{Environment.NewLine}{Environment.NewLine}", StringSplitOptions.RemoveEmptyEntries)
            .Select(x => x.Split(Environment.NewLine))
            .Select(x => x.Aggregate(0, (a, s) => a + int.Parse(s)));

        return await Task.FromResult($"{ints.Max()}");
    }

    protected override async Task<string> SolvePartTwoAsync(IContext context)
    {
        var ints = context.Input
            .Trim()
            .ReplaceLineEndings()
            .Split($"{Environment.NewLine}{Environment.NewLine}", StringSplitOptions.RemoveEmptyEntries)
            .Select(x => x.Split(Environment.NewLine))
            .Select(x => x.Aggregate(0, (a, s) => a + int.Parse(s)));
        var topThree = ints.OrderDescending().Take(3);

        return await Task.FromResult($"{topThree.Sum()}");
    }
}
