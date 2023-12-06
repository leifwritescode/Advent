using Ornaments.Solutions;

[RegisterOrnament("Scratchcards", 2023, 4)]
internal sealed partial class Scratchcards : ISolution
{
    public async Task<object> DoPartOneAsync(ISolutionContext solutionContext)
    {
        var scratchcards = solutionContext.As<IEnumerable<IEnumerable<int[]>>>();
        var result = 0;
        foreach (var scratchcard in scratchcards)
        {
            var set = scratchcard.Select(arr => new HashSet<int>(arr)).Aggregate((a, b) => a.Intersect(b).ToHashSet());
            result += set.Count switch {
                0 => 0,
                1 => 1,
                _ => (int)Math.Pow(2, set.Count - 1)
            };
        }
        return await Task.FromResult(result);
    }

    public async Task<object> DoPartTwoAsync(ISolutionContext solutionContext)
    {
        var scratchcards = solutionContext.As<IEnumerable<IEnumerable<int[]>>>();
        var result = new int[scratchcards.Count()];
        Array.Fill(result, 1);
        for (var i = 0; i < scratchcards.Count(); ++i)
        {
            var scratchcard = scratchcards.ElementAt(i);
            var set = scratchcard.Select(arr => new HashSet<int>(arr)).Aggregate((a, b) => a.Intersect(b).ToHashSet());
            for (var j = 0; j < set.Count; j++)
            {
                result[i + j + 1] += result[i];
            }
        }
        return await Task.FromResult(result.Sum());
    }

    public bool TryParse(string input, out object parsed)
    {
        parsed = input
            .Trim()
            .ReplaceLineEndings()
            .Split(Environment.NewLine)
            .Select(line => line.Replace("  ", " ")) // remove double spaces
            .Select(line => string.Join(string.Empty, line.Skip(line.IndexOf(':') + 1))) // remove the field name
            .Select(line => line.Split('|'))
            .Select(line => line.Select(item => item.Split(' ', StringSplitOptions.RemoveEmptyEntries).Select(int.Parse).ToArray()));
        return true;
    }
}
