using Ornaments.App;
using Ornaments.Solutions;
using System.Text.RegularExpressions;

namespace Advent.Solutions;

[RegisterOrnament("Trebuchet!?", 2023, 1)]
internal sealed partial class Trebuchet : ISolution
{
    private static readonly Dictionary<string, int> s_lookup = new() {
        { "one"  , 1 },
        { "two"  , 2 },
        { "three", 3 },
        { "four" , 4 },
        { "five" , 5 },
        { "six"  , 6 },
        { "seven", 7 },
        { "eight", 8 },
        { "nine" , 9 },
        { "1"    , 1 },
        { "2"    , 2 },
        { "3"    , 3 },
        { "4"    , 4 },
        { "5"    , 5 },
        { "6"    , 6 },
        { "7"    , 7 },
        { "8"    , 8 },
        { "9"    , 9 }, 
    };

    private readonly ILogger<Trebuchet> _logger;

    public Trebuchet(ILogger<Trebuchet> logger) {
        _logger = logger;
    }

    public async Task<object> DoPartOneAsync(ISolutionContext solutionContext)
    {
        //56049
        await Task.CompletedTask;
        var input = solutionContext.As<IEnumerable<string>>();
        return input
            .Select(s => ExtractCalibrationValue(s, false))
            .Sum();
    }

    public async Task<object> DoPartTwoAsync(ISolutionContext solutionContext)
    {
        // 54530
        await Task.CompletedTask;
        var input = solutionContext.As<IEnumerable<string>>();
        return input
            .Select(s => {
                var a = ExtractCalibrationValue(s, true);
                return a;
            })
            .Sum();
    }

    public bool TryParse(string input, out object parsed)
    {
        parsed = input.Trim()
            .ReplaceLineEndings()
            .Split($"{Environment.NewLine}");

        return true;
    }

    [GeneratedRegex("[0-9]|one|two|three|four|five|six|seven|eight|nine", RegexOptions.Compiled)]
    private static partial Regex ExtractNumbers();

    [GeneratedRegex("[0-9]|one|two|three|four|five|six|seven|eight|nine", RegexOptions.Compiled | RegexOptions.RightToLeft)]
    private static partial Regex ExtractNumbersRtl();

    private static int ExtractCalibrationValue(string s, bool partTwo) {
        var matchesLtr = ExtractNumbers().Matches(s);
        var matchesRtl = ExtractNumbersRtl().Matches(s);
        var result = 0;
        if (matchesLtr.Count > 0) { // can assume rtl has also matched
            var a = s_lookup[matchesLtr.First(x => partTwo || int.TryParse(x.Value, out var _)).Value];
            var b = s_lookup[matchesRtl.First(x => partTwo || int.TryParse(x.Value, out var _)).Value];
            result = a * 10 + b;
        }
        return result;
    }
}
