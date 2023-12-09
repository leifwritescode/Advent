using Ornaments.Solutions;

[RegisterOrnament("Wait For It", 2023, 6)]
internal sealed partial class WaitForIt : ISolution
{
    public async Task<object> DoPartOneAsync(ISolutionContext solutionContext)
    {
        var input = solutionContext.As<IEnumerable<string>>();
        var temp = input
            .Select(s => s.Split(' ', StringSplitOptions.RemoveEmptyEntries))
            .Select(s => s.Select(x => long.Parse(x)));
        var pairs = temp.First().Zip(temp.Last());

        return await Task.FromResult(SumOfRecordBreakingSolutions(pairs));
    }

    public async Task<object> DoPartTwoAsync(ISolutionContext solutionContext)
    {
        var input = solutionContext.As<IEnumerable<string>>();
        var temp = input
            .Select(s => s.Replace(" ", string.Empty))
            .Select(long.Parse);
        var pair = (temp.First(), temp.Last());
        var pairs = Enumerable.Empty<(long, long)>();
        pairs = pairs.Append(pair);

        return await Task.FromResult(SumOfRecordBreakingSolutions(pairs));
    }

    public bool TryParse(string input, out object parsed)
    {
        parsed = input
            .Trim()
            .ReplaceLineEndings()
            .Split(Environment.NewLine)
            .Select(s => s.Split(':').Last().Trim());
        return true;        
    }

    private double SumOfRecordBreakingSolutions(IEnumerable<(long, long)> values)
    {
        return values.Aggregate(1d, (a, b) =>
        {
            // it's an interval! woohoo!
            // s = sqrt(t^2 - 4r)
            var s = Math.Sqrt(Math.Pow(b.Item1, 2) - (4 * b.Item2));
            if (s % 1 == 0)
            {
                return a * (s - 1);
            }
            else
            {
                return a * Math.Round(s);
            }
        });
    }
}