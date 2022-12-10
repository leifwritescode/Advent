using Advent.Contracts;
using Microsoft.Extensions.Logging;

namespace Advent.Solutions;

internal class CathodeRayTube : SolutionBase
{
    public CathodeRayTube(ILogger<CathodeRayTube> logger, IInstrument instrument)
        : base(logger, instrument, 10)
    {
    }

    protected override async Task<string> SolvePartOneAsync(IContext context)
    {
        await Task.CompletedTask;
        return "";
    }

    protected override async Task<string> SolvePartTwoAsync(IContext context)
    {
        await Task.CompletedTask;
        return "";
    }
}
