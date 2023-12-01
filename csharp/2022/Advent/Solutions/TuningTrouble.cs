using Advent.Contracts;
using Microsoft.Extensions.Logging;

namespace Advent.Solutions;

internal class TuningTrouble : SolutionBase
{
    public TuningTrouble(ILogger<TuningTrouble> logger, IInstrument instrument)
        : base(logger, instrument, 6)
    {
    }

    private int FindIndex(char[] input, int windowSize)
    {
        return Enumerable
            .Range(0, input.Length - windowSize + 1)
            .First(i => input.Skip(i).Take(windowSize).Distinct().Count() == windowSize) + windowSize;
    }

    protected override async Task<string> SolvePartOneAsync(IContext context)
        => await Task.FromResult($"{FindIndex(context.Input.Trim().ToCharArray(), 4)}");

    protected override async Task<string> SolvePartTwoAsync(IContext context)
        => await Task.FromResult($"{FindIndex(context.Input.Trim().ToCharArray(), 14)}");
}
