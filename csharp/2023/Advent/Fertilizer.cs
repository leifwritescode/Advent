using Ornaments.Solutions;

internal class Mapping
{
    private readonly long _sourceStart;
    private readonly long _destinationStart;
    private readonly long _length;

    public Mapping(long destinationStart, long sourceStart, long length)
    {
        _destinationStart = destinationStart;
        _sourceStart = sourceStart;
        _length = length;
    }

    public long Map(long sourceValue)
    {
        // it doesn't map to this range
        if (sourceValue < _sourceStart || sourceValue >= _sourceStart + _length)
        {
            return -1;
        }

        return _destinationStart + (sourceValue - _sourceStart);
    }

    public bool InSource(long sourceValue)
    {
        return sourceValue >= _sourceStart && sourceValue < _sourceStart + _length;
    }

    public bool InDestination(long destinationValue)
    {
        return destinationValue >= _destinationStart && destinationValue < _destinationStart + _length;
    }
}

internal enum Mappings
{
    SeedToSoil = 0,
    SoilToFertilizer,
    FertilizerToWater,
    WaterToLight,
    LightToTemperature,
    TemperatureToHumidity,
    HumidityToLocatiom
}

internal class Almanac
{
    public long[] Seeds;

    public Mapping[][] Mappings;

    public Almanac(long[] seeds, Mapping[][] mappings)
    {
        Seeds = seeds;
        Mappings = mappings;
    }
}

[RegisterOrnament("If You Give A Seed A Fertilizer", 2023, 5)]
internal sealed partial class Fertilizer : ISolution
{
    public async Task<object> DoPartOneAsync(ISolutionContext solutionContext)
    {
        var almanac = solutionContext.As<Almanac>();
        var seeds = almanac.Seeds;
        foreach (var value in Enum.GetValues<Mappings>())
        {
            var mappings = almanac.Mappings[(int)value];
            seeds = seeds.Select(seed => {
                var m = mappings?.FirstOrDefault(mapping => mapping.Map(seed) != -1);
                if (m is null) {
                    return seed;
                } else {
                    return m.Map(seed);
                }
            }).ToArray();
        }
        return await Task.FromResult(seeds.Min());
    }

    public async Task<object> DoPartTwoAsync(ISolutionContext solutionContext)
    {
        // for part 2, i need to reinterpret what the seeds are (that is, pairs descriing start and range)
        // to achieve the same end i need to process each range one at a time, using parallel for an interlocked replace.
        var almanac = solutionContext.As<Almanac>();

        // extract the ranges
        var seeds = new long[almanac.Seeds.Length / 2][];
        for (var i = 0; i < almanac.Seeds.Length; i += 2)
        {
            seeds[i / 2] = new long[] { almanac.Seeds[i], almanac.Seeds[i + 1] };
        }

        // process each range
        Console.WriteLine("Processing {0} ranges", seeds.Length);
        Console.WriteLine(string.Join(',', seeds.Select(s => $"[{s[0]},{s[1]}]")));
        var mins = (long[])Array.CreateInstance(typeof(long), almanac.Seeds.Length / 2);
        for (var i = 0; i < seeds.Length; i++) {
            var pair = seeds[i];
            Console.WriteLine("Processing range {0} to {1}", pair[0], pair[0] + pair[1]);
            Parallel.For(0, pair[1], idx => {
                var seed = pair[0] + idx;

                foreach (var value in Enum.GetValues<Mappings>())
                {
                    var mappings = almanac.Mappings[(int)value];
                    var m = mappings?.FirstOrDefault(mapping => mapping.Map(seed) != -1);
                    if (m is null) {
                        continue;
                    } else {
                        seed = m.Map(seed);
                    }
                }

                Interlocked.CompareExchange(ref mins[i], seed, (seed < mins[i] || mins[i] == 0) ? seed : mins[i]);
            });
        }

        return await Task.FromResult(mins.Min());
    }

    public bool TryParse(string input, out object parsed)
    {
        var lines = input.Trim().ReplaceLineEndings().Split(Environment.NewLine, StringSplitOptions.RemoveEmptyEntries);
        var seeds = lines[0].Split(':').Last().Split(' ', StringSplitOptions.RemoveEmptyEntries).Select(long.Parse).ToArray();

        lines = lines.Skip(2).ToArray();
        var mappings = new Mapping[Enum.GetValues<Mappings>().Length][];
        foreach (var mapping in Enum.GetValues<Mappings>())
        {
            // get the numbers
            var raw = lines.TakeWhile(line => !line.Contains(':')).ToArray();
            foreach (var line in raw) {
                var longs = line.Split(' ', StringSplitOptions.RemoveEmptyEntries).Select(long.Parse).ToArray();
                var range = new Mapping(longs[0], longs[1], longs[2]);
                if (mappings[(int)mapping] == null)
                    mappings[(int)mapping] = new Mapping[] { range };
                else
                    mappings[(int)mapping] = mappings[(int)mapping].Append(range).ToArray();
            }

            // go to the end of the range, and then skip it
            lines = lines.SkipWhile(line => !line.Contains(':')).Skip(1).ToArray();
        }

        parsed = new Almanac(seeds, mappings);
        return true;
    }
}
