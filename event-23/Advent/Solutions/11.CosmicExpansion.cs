using Ornaments.Solutions;

namespace Advent;

[RegisterOrnament("Cosmic Expansion", 2023, 11)]
internal sealed partial class CosmicExpansion : ISolution
{
    public async Task<object> DoPartOneAsync(ISolutionContext solutionContext)
    {
        var galaxies = solutionContext.As<IEnumerable<(long x, long y)>>();
        return await Task.FromResult(Expand(galaxies, 1));
    }

    public async Task<object> DoPartTwoAsync(ISolutionContext solutionContext)
    {
        var galaxies = solutionContext.As<IEnumerable<(long x, long y)>>();
        return await Task.FromResult(Expand(galaxies, 999999));
    }

    public bool TryParse(string input, out object parsed)
    {
        var lines = input
            .Trim()
            .ReplaceLineEndings()
            .Split(Environment.NewLine);
        var galaxies = new List<(long, long)>();
        for (var y = 0; y < lines.Length; ++y)
        {
            var line = lines[y];
            for (var x = 0; x < line.Length; ++x)
            {
                if (line[x] == '#')
                {
                    galaxies.Add((x, y));
                }
            }
        }
        parsed = galaxies;
        return true;
    }

    private List<((long,long),(long,long))> Combinations(IEnumerable<(long,long)> values)
    {
        var r = new List<((long,long),(long,long))>();
        foreach (var a in values)
        {
            foreach (var b in values)
            {
                if (a == b)
                {
                    continue;
                }

                if (r.Contains((a, b)) || r.Contains((b, a)))
                {
                    continue;
                }

                r.Add((a, b));
            }
        }
        return r;
    }

    private long Expand(IEnumerable<(long x, long y)> galaxies, long expandBy)
    {
        // get the extents of the universe
        var minX = galaxies.Min(g => g.x);
        var maxX = galaxies.Max(g => g.x);
        var minY = galaxies.Min(g => g.y);
        var maxY = galaxies.Max(g => g.y);

        var expansionsInY = EnumerateRange(minY, maxY).Where(v => !galaxies.Any(g => g.y == v));
        var expansionsInX = EnumerateRange(minX, maxX).Where(v => !galaxies.Any(g => g.x == v));

        var expanded = galaxies.Select(g => {
            var (x, y) = g;
            var dx = expansionsInX.Count(v => v < x) * expandBy;
            var dy = expansionsInY.Count(v => v < y) * expandBy;
            return (x + dx, y + dy);
        });

        var combinations = Combinations(expanded);

        // order by the manhattan distance between each pair of galaxies
        var sum = combinations.Sum(g => Math.Abs(g.Item1.Item1 - g.Item2.Item1) + Math.Abs(g.Item1.Item2 - g.Item2.Item2));
        return sum;
    }

    private IEnumerable<long> EnumerateRange(long start, long end)
    {
        for (var i = start; i <= end; ++i)
        {
            yield return i;
        }
    }
}
