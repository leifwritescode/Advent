using System.Text.RegularExpressions;
using Ornaments.Solutions;

namespace Advent.Solutions;

internal class Map
{
    public string Instructions { get; init; }

    public IDictionary<string, (string, string)> Nodes { get; init; }

    public Map(string instruction, IDictionary<string, (string, string)> map)
    {
        Instructions = instruction;
        Nodes = map;
    }

    public string GetNext(string current, char direction)
    {
        var (left, right) = Nodes[current];
        return direction switch
        {
            'L' => left,
            'R' => right,
            _ => throw new ArgumentException($"Invalid direction: {direction}", nameof(direction))
        };
    }
}

internal record Instruction(string Start, string Left, string Right);

[RegisterOrnament("Haunted Wasteland", 2023, 8)]
internal sealed partial class HauntedWasteland : ISolution
{
    public async Task<object> DoPartOneAsync(ISolutionContext solutionContext)
    {
        var input = solutionContext.As<Map>();
        var current = "AAA";
        var steps = 0;

        while(current != "ZZZ")
        {
            var direction = input.Instructions[steps++ % input.Instructions.Length];
            current = input.GetNext(current, direction);
        }

        return await Task.FromResult(steps);
    }

    public async Task<object> DoPartTwoAsync(ISolutionContext solutionContext)
    {
        var input = solutionContext.As<Map>();
        var current = input.Nodes.Keys.Where(k => k.EndsWith("A")).ToArray();
        var steps = new int[current.Length];

        for (var i = 0; i < current.Length; i++)
        {
            while (!current[i].EndsWith("Z"))
            {
                var direction = input.Instructions[steps[i]++ % input.Instructions.Length];
                current[i] = input.GetNext(current[i], direction);
            }
        }

        return await Task.FromResult(LeastCommonMultiple(steps));
    }

    public bool TryParse(string input, out object parsed)
    {
        var regex = new Regex(@"(?<start>\w{3})\s=\s\((?<left>\w{3}),\s(?<right>\w{3})", RegexOptions.Compiled);
        var lines = input.Trim().ReplaceLineEndings().Split(Environment.NewLine);
        var instructions = lines[0];
        var nodes = lines.Skip(2).Select(line => regex.Match(line)).ToDictionary(
            match => match.Groups["start"].Value,
            match => (match.Groups["left"].Value, match.Groups["right"].Value)
        );
        parsed = new Map(instructions, nodes);
        return true;
    }

    private long LeastCommonMultiple(int[] numbers)
    {
        return numbers.Aggregate((long)numbers.First(), (a, b) => LowestCommonMultiple(a, b));
    }

    private long LowestCommonMultiple(long a, long b)
    {
        var gcd = GreatestCommonDivisor(a, b);
        return a / gcd * b;
    }

    private long GreatestCommonDivisor(long a, long b)
    {
        while (b != 0)
        {
            var temp = b;
            b = a % b;
            a = temp;
        }

        return a;
    }
}