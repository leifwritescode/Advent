using Advent.Contracts;
using Microsoft.Extensions.Logging;

namespace Advent.Solutions;

internal class TreetopTreeHouse : SolutionBase
{
    public TreetopTreeHouse(ILogger<TreetopTreeHouse> logger, IInstrument instrument)
        : base(logger, instrument, 8)
    {
    }

    protected override async Task<string> SolvePartOneAsync(IContext context)
    {
        return "";
    }

    protected override async Task<string> SolvePartTwoAsync(IContext context)
    {
        return "";
    }
}
