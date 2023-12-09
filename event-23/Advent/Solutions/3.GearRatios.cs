using Ornaments.Solutions;

namespace Advent.Solutions;

[RegisterOrnament("Gear Ratios", 2023, 3)]
internal sealed partial class GearRatios : ISolution
{
    public async Task<object> DoPartOneAsync(ISolutionContext solutionContext)
    {
        var result = 0;
        var map = solutionContext.As<char[,]>();
        var hit = new bool[map.GetLength(0), map.GetLength(1)];
        Parallel.For(0, map.Length, i => {
            var x = i % map.GetLength(0);
            var y = i / map.GetLength(0);

            var g = map[x, y];
            if (char.IsDigit(g) || g == '.')
            {
                return;
            }

            for (var y2 = y - 1; y2 <= y + 1; ++y2)
            {
                for (var x2 = x - 1; x2 <= x + 1; ++x2)
                {
                    // Skip self
                    if (x2 == x && y2 == y)
                    {
                        continue;
                    }

                    // Skip out of bounds
                    if (x2 < 0 || x2 >= map.GetLength(0) || y2 < 0 || y2 >= map.GetLength(1))
                    {
                        continue;
                    }

                    // there's a chance that the index has a number next to it
                    // we should maintain a map of places a number was found, and ignore anything that's already been found 
                    if (char.IsDigit(map[x2, y2]) && !hit[x2, y2])
                    {
                        // find the actual numbers
                        var rec = ReconstructNumber(map, hit, x2, y2);
                        var num = int.Parse(rec);
                        Interlocked.Add(ref result, num);
                    }
                }
            }
        });

        return await Task.FromResult(result);
    }

    public async Task<object> DoPartTwoAsync(ISolutionContext solutionContext)
    {
        var result = 0;
        var map = solutionContext.As<char[,]>();
        var hit = new bool[map.GetLength(0), map.GetLength(1)];
        Parallel.For(0, map.Length, i => {
            var x = i % map.GetLength(0);
            var y = i / map.GetLength(0);

            var g = map[x, y];
            if (g != '*')
            {
                return;
            }

            List<int> parts = new List<int>();
            for (var y2 = y - 1; y2 <= y + 1; ++y2)
            {
                for (var x2 = x - 1; x2 <= x + 1; ++x2)
                {
                    // Skip self
                    if (x2 == x && y2 == y)
                    {
                        continue;
                    }

                    // Skip out of bounds
                    if (x2 < 0 || x2 >= map.GetLength(0) || y2 < 0 || y2 >= map.GetLength(1))
                    {
                        continue;
                    }

                    if (char.IsDigit(map[x2, y2]) && !hit[x2, y2])
                    {
                        // find the actual numbers
                        var rec = ReconstructNumber(map, hit, x2, y2);
                        var num = int.Parse(rec);
                        parts.Add(num);
                    }
                }
            }

            if (parts.Count() == 2)
            {
                var ratio = parts.First() * parts.Last();
                Interlocked.Add(ref result, ratio);
            }
        });

        return await Task.FromResult(result);
    }

    public bool TryParse(string input, out object parsed)
    {
        var lines = input.Trim().ReplaceLineEndings().Split(Environment.NewLine);
        char[,] map = new char[lines[0].Length, lines.Length];
        for (var y = 0; y < lines.Length; ++y) {
            for (var x = 0; x < lines[y].Length; ++x) {
                map[x, y] = lines[y][x];
            }
        }
        parsed = map;
        return true;
    }

    private string ReconstructLeft(char[,] map, bool[,] hit, int x, int y)
    {
        if (x < 0)
        {
            return string.Empty;
        }

        if (!char.IsDigit(map[x, y]))
        {
            return string.Empty;
        }

        hit[x, y] = true;
        return ReconstructLeft(map, hit, x - 1, y) + map[x, y];
    }

    private string ReconstructRight(char[,] map, bool[,] hit, int x, int y)
    {
        if (x >= map.GetLength(0))
        {
            return string.Empty;
        }

        if (!char.IsDigit(map[x, y]))
        {
            return string.Empty;
        }

        hit[x, y] = true;
        return map[x, y] + ReconstructRight(map, hit, x + 1, y);
    }

    private string ReconstructNumber(char[,] map, bool[,] hit, int x, int y)
    {
        if (!char.IsDigit(map[x, y]))
        {
            return string.Empty;
        }

        hit[x, y] = true;
        return ReconstructLeft(map, hit, x - 1, y) + map[x, y] + ReconstructRight(map, hit, x + 1, y);
    }
}
