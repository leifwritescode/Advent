using Ornaments.Solutions;

[RegisterOrnament("Mirage Maintenance", 2023, 9)]
internal sealed partial class MirageMaintenance : ISolution
{
    public async Task<object> DoPartOneAsync(ISolutionContext solutionContext)
    {
        var sequences = solutionContext.As<IEnumerable<IEnumerable<long>>>();
        return await Task.FromResult(sequences.Aggregate(0L, (acc, sequence) => acc + PredictExtension(sequence).Last()));
    }

    public async Task<object> DoPartTwoAsync(ISolutionContext solutionContext)
    {
        var sequences = solutionContext.As<IEnumerable<IEnumerable<long>>>().Select(s => s.Reverse());
        return await Task.FromResult(sequences.Aggregate(0L, (acc, sequence) => acc + PredictExtension(sequence).Last()));
    }

    public bool TryParse(string input, out object parsed)
    {
        parsed = input
            .Trim()
            .ReplaceLineEndings()
            .Split(Environment.NewLine)
            .Select(line => line.Split(' ', StringSplitOptions.RemoveEmptyEntries))
            .Select(line => line.Select(long.Parse));
        return true;
    }

    private IEnumerable<long> PredictExtension(IEnumerable<long> sequence)
    {
        if (sequence.All(x => x == 0))
        {
            return sequence.Append(0);
        }

        // this is much slower than a for loop
        var steps = Difference(sequence);
        var predicted = PredictExtension(steps);
        return sequence.Append(sequence.Last() + predicted.Last());
    }

    private static IEnumerable<long> Difference(IEnumerable<long> sequence)
    {
        // the linq'y options are to zip, or to enumerable.range + select
        // both are horridly slow, and a for loop is much faster
        // return Enumerable.Range(1, sequence.Count() - 1).Select(i => sequence.ElementAt(i) - sequence.ElementAt(i - 1));
        // return sequence.Zip(sequence.Skip(1), (a, b) => b - a);

        var result = Enumerable.Empty<long>();
        for (var i = 1; i < sequence.Count(); ++i)
        {
            result = result.Append(sequence.ElementAt(i) - sequence.ElementAt(i - 1));
        }
        return result;
    }
}
