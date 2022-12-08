using Advent.Contracts;
using Advent.Ornaments;
using Microsoft.Extensions.Logging;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

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

        var start = grid.Width + 1;                                // (1,1), assuming top left origin
        var end = (grid.Height - 1) * grid.Width + grid.Width - 1; // (1,1), assuming bottom right origin

        // we start with all outer trees visible
        var count = (grid.Width * 2) + (grid.Height * 2) - 4;
        Parallel.For(start, end, coord =>
        {
            var x = coord % grid.Width;
            var y = coord / grid.Height;

            var cell = grid.Cell(x, y);

            // tree is visible iif all trees in a given direction are shorter than it
            var isVisible = new[]
            {
                    grid.Above(cell).All(x => x.Value < cell.Value),
                    grid.Aright(cell).All(x => x.Value < cell.Value),
                    grid.Below(cell).All(x => x.Value < cell.Value),
                    grid.Aleft(cell).All(x => x.Value < cell.Value),
                }.Any(x => x);

            if (isVisible)
                Interlocked.Increment(ref count);
        });

        return await Task.FromResult($"{count}");
    }

    protected override async Task<string> SolvePartTwoAsync(IContext context)
    {
        return "";
    }
}
