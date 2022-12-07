using Advent.Contracts;
using Advent.Ornaments;
using Microsoft.Extensions.Logging;
using System.Text.RegularExpressions;

namespace Advent.Solutions;

internal class SupplyStacks : SolutionBase
{
    private static readonly Regex box = new(@"\[(?<item>[A-Z\-])\]", RegexOptions.Compiled);
    private static readonly Regex command = new(@"move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)", RegexOptions.Compiled);

    public SupplyStacks(ILogger<SupplyStacks> logger, IInstrument instrument)
        : base(logger, instrument, 5)
    {
    }

    protected override async Task<string> SolvePartOneAsync(IContext context)
    {
        var sanitisedInput = context.Input // we are NOT going to trim this one. instead...
            .Replace("    ", "[-] ")       // replace groups of four spaces with a blank stack item
                                           // so that we have even height inputs
            .Replace("  ", " ")            // cleanup double spaces
            .Replace("][", "] [")          // cleanup none spaces
            .ReplaceLineEndings()          // then replace the line endings as normal
            .Split(Environment.NewLine);

        // get number of stacks from the first line
        var numStacks = box.Matches(sanitisedInput.First()).Count;

        // populate the stacks
        var stacks = new Dictionary<int, Stack<string>>();

        // process the stacks until we reach beyond 
        var inputEnumerator = sanitisedInput.GetEnumerator();
        while(inputEnumerator.MoveNext() && box.IsMatch((string)inputEnumerator.Current))
        {
            var boxes = box.Matches((string)inputEnumerator.Current);
            for (var i = 1; i <= numStacks; i++)
            {
                var box = boxes[i-1].Groups["item"].Value;
                if (box == "-")
                {
                    continue;
                }

                if (!stacks.ContainsKey(i))
                {
                    stacks.Add(i, new Stack<string>()); 
                }

                stacks[i].Push(box);
            }
        }

        // post process the stacks -- the need inverting
        for (var i = 1; i <= numStacks; i++)
        {
            stacks[i] = stacks[i].Reverse();
        }

        // need to skip current line
        inputEnumerator.MoveNext();

        // parse out the commands and start doing stuff
        while (inputEnumerator.MoveNext() && command.IsMatch((string)inputEnumerator.Current))
        {
            var details = command.Match((string)inputEnumerator.Current);
            var count = int.Parse(details.Groups["count"].Value);
            var from = int.Parse(details.Groups["from"].Value);
            var to = int.Parse(details.Groups["to"].Value);

            // do the switcheroo
            for (var i = 0; i < count; i++)
            {
                stacks[to].Push(stacks[from].Pop());
            }
        }

        var message = stacks.OrderBy(kvp => kvp.Key).Aggregate(string.Empty, (a, s) => a + s.Value.Pop());
        return await Task.FromResult(message);
    }

    protected override async Task<string> SolvePartTwoAsync(IContext context)
    {
        var sanitisedInput = context.Input // we are NOT going to trim this one. instead...
            .Replace("    ", "[-] ")       // replace groups of four spaces with a blank stack item
                                           // so that we have even height inputs
            .Replace("  ", " ")            // cleanup double spaces
            .Replace("][", "] [")          // cleanup none spaces
            .ReplaceLineEndings()          // then replace the line endings as normal
            .Split(Environment.NewLine);

        // get number of stacks from the first line
        var numStacks = box.Matches(sanitisedInput.First()).Count;

        // populate the stacks
        var stacks = new Dictionary<int, Stack<string>>();

        // process the stacks until we reach beyond 
        var inputEnumerator = sanitisedInput.GetEnumerator();
        while (inputEnumerator.MoveNext() && box.IsMatch((string)inputEnumerator.Current))
        {
            var boxes = box.Matches((string)inputEnumerator.Current);
            for (var i = 1; i <= numStacks; i++)
            {
                var box = boxes[i - 1].Groups["item"].Value;
                if (box == "-")
                {
                    continue;
                }

                if (!stacks.ContainsKey(i))
                {
                    stacks.Add(i, new Stack<string>());
                }

                stacks[i].Push(box);
            }
        }

        // post process the stacks -- the need inverting
        for (var i = 1; i <= numStacks; i++)
        {
            stacks[i] = stacks[i].Reverse();
        }

        // need to skip current line
        inputEnumerator.MoveNext();

        // parse out the commands and start doing stuff
        while (inputEnumerator.MoveNext() && command.IsMatch((string)inputEnumerator.Current))
        {
            var details = command.Match((string)inputEnumerator.Current);
            var count = int.Parse(details.Groups["count"].Value);
            var from = int.Parse(details.Groups["from"].Value);
            var to = int.Parse(details.Groups["to"].Value);

            // pull the items into a temporary stack, which will reverse them (important)
            var temp = new Stack<string>();
            for (var i = 0; i < count; i++)
            {
                temp.Push(stacks[from].Pop());
            }

            // repopulate the destination stack by popping the temp one, reversing them again
            while (temp.Any()) { stacks[to].Push(temp.Pop()); }
        }

        var message = stacks.OrderBy(kvp => kvp.Key).Aggregate(string.Empty, (a, s) => a + s.Value.Pop());
        return await Task.FromResult(message);
    }
}
