using Advent.Contracts;
using Advent.Ornaments;
using Microsoft.Extensions.Logging;
using System.ComponentModel;

namespace Advent.Solutions;

internal class TreetopTreeHouse : SolutionBase
{
    public TreetopTreeHouse(ILogger<TreetopTreeHouse> logger, IInstrument instrument)
        : base(logger, instrument, 8)
    {
    }

    protected override async Task<string> SolvePartOneAsync(IContext context)
    {
        var grid = new Grid<int>(context.Input.PreProcessLines());

        // consider all trees simultaneously
        var limx = grid.Width - 1;
        var limy = grid.Height - 1;

        // we start with all outer trees visible
        var count = (grid.Width * 2) + (grid.Height * 2) - 4;

        for (var y = 1; y < limy; y++)
        {
            for (var x = 1; x < limx; x++)
            {
                var cell = grid.Cell(x, y);

                // tree is visible iif all trees in a given direction are shorter than it
                var isVisible = new[]
                {
                    grid.Above(cell).All(x => x.Value < cell.Value),
                    grid.Aright(cell).All(x => x.Value < cell.Value),
                    grid.Below(cell).All(x => x.Value < cell.Value),
                    grid.Aleft(cell).All(x => x.Value < cell.Value),
                }.Any(x => x);

                count += isVisible ? 1 : 0;
            }
        }

        return await Task.FromResult($"{count}");
    }

    protected override async Task<string> SolvePartTwoAsync(IContext context)
    {
        return "";
    }
}
