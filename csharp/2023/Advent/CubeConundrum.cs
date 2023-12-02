using System.Text.RegularExpressions;
using Ornaments.App;
using Ornaments.Solutions;

namespace Advent;

[RegisterOrnament("Cube Conundrum", 2023, 2)]
internal sealed partial class CubeConundrum : ISolution
{
    private readonly ILogger<CubeConundrum> _logger;

    public CubeConundrum(ILogger<CubeConundrum> logger) {
        _logger = logger;
    }

    public async Task<object> DoPartOneAsync(ISolutionContext solutionContext)
    {
        var games = solutionContext.As<IEnumerable<string>>();
        var regex = MyRegex();
        var caps = new Dictionary<string, int> {
            { "blue" , 14 },
            { "green", 13 },
            { "red"  , 12 },
        };
        var sum = 0;
        for (var i = 0; i < games.Count(); ++i) {
            var game = games.ElementAt(i);
            var matches = regex.Matches(game);
            if (matches.Any(m => int.Parse(m.Groups["count"].Value) > caps[m.Groups["colour"].Value])) {
                continue;
            }
            sum += i + 1;
        }

        return await Task.FromResult(sum);
    }

    public async Task<object> DoPartTwoAsync(ISolutionContext solutionContext)
    {
        var power = 0;
        var games = solutionContext.As<IEnumerable<string>>();
        var regex = MyRegex();
        for (var i = 0; i < games.Count(); ++i) {
            var game = games.ElementAt(i);
            var matches = regex.Matches(game);
            var a = matches.Where(m => m.Groups["colour"].Value == "green").Max(m => int.Parse(m.Groups["count"].Value));
            var b = matches.Where(m => m.Groups["colour"].Value == "red").Max(m => int.Parse(m.Groups["count"].Value));
            var c = matches.Where(m => m.Groups["colour"].Value == "blue").Max(m => int.Parse(m.Groups["count"].Value));
            power += a * b * c;
        }
        return await Task.FromResult(power);
    }

    public bool TryParse(string input, out object parsed)
    {
        parsed = input.Trim().ReplaceLineEndings().Split(Environment.NewLine);
        return true;
    }

    [GeneratedRegex("(?<count>[0-9]+)\\s(?<colour>blue|red|green)", RegexOptions.IgnoreCase | RegexOptions.Compiled)]
    private static partial Regex MyRegex();
}
