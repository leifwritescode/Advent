using Ornaments.Solutions;

internal record Range(long From, long To);

internal record Almanac(long[] Seeds, IEnumerable<IDictionary<Range, Range>> Maps);

[RegisterOrnament("If You Give A Seed A Fertilizer", 2023, 5)]
internal sealed partial class Fertilizer : ISolution
{
    public async Task<object> DoPartOneAsync(ISolutionContext solutionContext)
    {
        var almanac = solutionContext.As<Almanac>();
        var seeds = almanac.Seeds.Select(seed => new Range(seed, seed));
        return await Solve(seeds, almanac.Maps);
    }

    public async Task<object> DoPartTwoAsync(ISolutionContext solutionContext)
    { 
        // 2695483 too low
        var almanac = solutionContext.As<Almanac>();
        var seeds = almanac.Seeds.Chunk(2).Select(seed => new Range(seed[0], seed[1] + seed[0] - 1));
        return await Solve(seeds, almanac.Maps);
    }

    public bool TryParse(string input, out object parsed)
    {
        var lines = input.Trim().ReplaceLineEndings().Split($"{Environment.NewLine}{Environment.NewLine}", StringSplitOptions.RemoveEmptyEntries);
        var seeds = lines[0].Split(':').Last().Split(' ', StringSplitOptions.RemoveEmptyEntries).Select(long.Parse).ToArray();
        var maps = lines.Skip(1).Select(line => {
            var data = line.Split(Environment.NewLine).Skip(1);
            return data.Select(line => {
                var longs = line.Split(' ', StringSplitOptions.RemoveEmptyEntries).Select(long.Parse).ToArray();
                var from = new Range(longs[1], longs[1] + longs[2] - 1);
                var to = new Range(longs[0], longs[0] + longs[2] - 1);
                return new KeyValuePair<Range, Range>(from, to);
            }).ToDictionary(kvp => kvp.Key, kvp => kvp.Value);
        });
        parsed = new Almanac(seeds, maps.ToArray());
        return true;
    }

    private async Task<object> Solve(IEnumerable<Range> seeds, IEnumerable<IDictionary<Range, Range>> maps)
    {
        return await Task.FromResult(maps.Aggregate(seeds, (a, b) => {
            var outputRange = new List<Range>();
            var todo = new Queue<Range>(a);
            while (todo.TryDequeue(out var inputRange)) {
                var src = b.Keys.FirstOrDefault(range => inputRange.From <= range.To && range.From <= inputRange.To);
                if (src is null) {
                    outputRange.Add(inputRange);
                } else if (src.From <= inputRange.From && inputRange.To <= src.To) {
                    var dest = b[src];
                    var from = inputRange.From - src.From + dest.From;
                    var to = inputRange.To - src.From + dest.From;
                    outputRange.Add(new Range(from, to));
                } else if (inputRange.From < src.From) {
                    todo.Enqueue(new Range(inputRange.From, src.From - 1));
                    todo.Enqueue(new Range(src.From, inputRange.To));
                } else {
                    todo.Enqueue(new Range(inputRange.From, src.To));
                    todo.Enqueue(new Range(src.To + 1, inputRange.To));
                }
            }
            return outputRange;
        }).Select(range => range.From).Min());
    }
}
