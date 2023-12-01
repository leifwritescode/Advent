using Advent.Contracts;
using Advent.Ornaments;
using Microsoft.Extensions.Logging;
using System.Collections.Concurrent;

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

        // we start with all outer trees visible
        var count = (grid.Width * 2) + (grid.Height * 2) - 4;
        Parallel.For(0, grid.Width * grid.Height, coord =>
        {
            var x = coord % grid.Width;
            var y = coord / grid.Height;
            if (x == 0 || y == 0 || x == grid.Width - 1 || y == grid.Height - 1)
                return;

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
        var grid = new Grid<int>(context.Input.PreProcessLines());

        var scenicScores = new ConcurrentBag<int>();
        Parallel.For(0, grid.Width * grid.Height, coord =>
        {
            var x = coord % grid.Width;
            var y = coord / grid.Height;

            var cell = grid.Cell(x, y);

            // tree is visible iif all trees in a given direction are shorter than it
            var scenicScore = new[]
            {
                grid.Above(cell)?.TakeWhile(x => x.Value < cell.Value,  inclusive: true).Count() ?? 0,
                grid.Aleft(cell)?.TakeWhile(x => x.Value < cell.Value,  inclusive: true).Count() ?? 0,
                grid.Below(cell)?.TakeWhile(x => x.Value < cell.Value,  inclusive: true).Count() ?? 0,
                grid.Aright(cell)?.TakeWhile(x => x.Value < cell.Value, inclusive: true).Count() ?? 0,
            }.Aggregate(1, (a, v) => a * v);

            scenicScores.Add(scenicScore);
        });

        return await Task.FromResult($"{scenicScores.Max()}");
    }
}
