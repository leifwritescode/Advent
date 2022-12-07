using Advent.Contracts;
using Microsoft.Extensions.Logging;

namespace Advent.Solutions;

internal class RockPaperScissors : SolutionBase
{
    private static readonly KeyValuePair<string, int>[] lookUpTableP1 =
    {
        // winning pairs
        new KeyValuePair<string, int>("AY", 8),
        new KeyValuePair<string, int>("BZ", 9),
        new KeyValuePair<string, int>("CX", 7),
        // drawing pairs
        new KeyValuePair<string, int>("AX", 4),
        new KeyValuePair<string, int>("BY", 5),
        new KeyValuePair<string, int>("CZ", 6),
        // losing pairs
        new KeyValuePair<string, int>("AZ", 3),
        new KeyValuePair<string, int>("BX", 1),
        new KeyValuePair<string, int>("CY", 2),
    };

    private static readonly KeyValuePair<string, int>[] lookUpTableP2 =
{
        // winning pairs
        new KeyValuePair<string, int>("AZ", 8),
        new KeyValuePair<string, int>("BZ", 9),
        new KeyValuePair<string, int>("CZ", 7),
        // drawing pairs
        new KeyValuePair<string, int>("AY", 4),
        new KeyValuePair<string, int>("BY", 5),
        new KeyValuePair<string, int>("CY", 6),
        // losing pairs
        new KeyValuePair<string, int>("AX", 3),
        new KeyValuePair<string, int>("BX", 1),
        new KeyValuePair<string, int>("CX", 2),
    };

    public RockPaperScissors(IInstrument instrument, ILogger<ISolution> logger)
        : base(logger, instrument, 2) { }

    private int PlayRockPaperScissors(IContext context, KeyValuePair<string, int>[] lookup)
        => context.Input
            .Trim()
            .ReplaceLineEndings()
            .Replace(" ", "")
            .Split(Environment.NewLine)
            .Aggregate(0, (accumulator, round) => accumulator + lookup.Single(x => x.Key == round).Value);

    protected override async Task<string> SolvePartOneAsync(IContext context)
        => await Task.FromResult($"{PlayRockPaperScissors(context, lookUpTableP1)}");

    protected override async Task<string> SolvePartTwoAsync(IContext context)
        => await Task.FromResult($"{PlayRockPaperScissors(context, lookUpTableP2)}");
}
