using Advent.Contracts;
using Microsoft.Extensions.Logging;
using System.Diagnostics;

namespace Advent.Solutions;

internal sealed class MonkeyInTheMiddle : SolutionBase
{
    private sealed class Monkey
    {
        private readonly Queue<long> items;
        private readonly string operation;
        private readonly long rhsOperand;
        private readonly int outcomeIfTrue;
        private readonly int outcomeIfFalse;
        private readonly bool relief;

        public long Inspections { get; private set; } = 0;

        public long Test { get; }

        public Monkey(string operation, long rhsOperand, long test, int outcomeIfTrue, int outcomeIfFalse, bool relief, params long[] items)
        {
            this.operation = operation;
            this.rhsOperand = rhsOperand;
            this.items = new Queue<long>(items);
            Test = test;
            this.outcomeIfTrue = outcomeIfTrue;
            this.outcomeIfFalse = outcomeIfFalse;
            this.relief = relief;
        }

        private long Operate(long item)
        {
            return operation switch
            {
                "*" => item * rhsOperand,
                "+" => item + rhsOperand,
                "^" => item * item,
                "-" => item - rhsOperand,
                _ => throw new UnreachableException()
            };
        }

        public void Throw(IDictionary<int, Monkey> monkeys, long modulo)
        {
            while (items.Any())
            {
                var item = items.Dequeue();
                var worry = Operate(item);

                if (relief)
                {
                    worry /= 3;
                }
                else
                {
                    // if part 2, use chinese remainder theorem instead
                    worry %= modulo;
                }

                var where = worry % Test == 0;
                if (where)
                {
                    monkeys[outcomeIfTrue].Give(worry);
                }
                else
                {
                    monkeys[outcomeIfFalse].Give(worry);
                }

                Inspections++;
            }
        }

        private void Give(long item)
        {
            items.Enqueue(item);
        }
    }

    public MonkeyInTheMiddle(ILogger<MonkeyInTheMiddle> logger, IInstrument instrument)
        : base(logger, instrument, 11)
    {
    }

    private IDictionary<int, Monkey> ParseInput(string input, bool part)
    {
        var blocks = input.ReplaceLineEndings().Split("Monkey ").Where(x => !string.IsNullOrWhiteSpace(x));
        var counter = 0;
        var dictionary = new Dictionary<int, Monkey>();
        foreach (var block in blocks)
        {
            var operation = string.Empty;
            var rhsOperand = 0L;
            var test = 0L;
            var outcomeIfTrue = 0;
            var outcomeIfFalse = 0;
            var items = new long[] { };

            var enumerator = block.Split(Environment.NewLine).GetEnumerator();
            while (enumerator.MoveNext())
            {
                var line = ((string)enumerator.Current).Trim();
                if (line.StartsWith("Monkey"))
                {
                    continue;
                }
                else if (line.StartsWith("Starting items: "))
                {
                    items = line.Substring("Starting items: ".Length).Split(',').Select(x => long.Parse(x)).ToArray();
                }
                else if (line.StartsWith("Operation: new = old "))
                {
                    var parts = line.Substring("Operation: new = old ".Length).Split(' ');
                    operation = parts.First();
                    if (!long.TryParse(parts.Last(), out rhsOperand))
                    {
                        operation = "^";
                        rhsOperand = 0L;
                    }
                }
                else if (line.StartsWith("Test: divisible by "))
                {
                    test = long.Parse(line.Substring("Test: divisible by ".Length));
                }
                else if (line.StartsWith("If true: throw to monkey "))
                {
                    outcomeIfTrue = int.Parse(line.Substring("If true: throw to monkey ".Length));
                }
                else if (line.StartsWith("If false: throw to monkey "))
                {
                    outcomeIfFalse = int.Parse(line.Substring("If false: throw to monkey ".Length));
                }
            }

            dictionary.Add(counter, new Monkey(operation, rhsOperand, test, outcomeIfTrue, outcomeIfFalse, part, items));
            counter++;
        }
        return dictionary;
    }

    protected override async Task<string> SolvePartOneAsync(IContext context)
    {
        var monkeys = ParseInput(context.Input, true);

        var rounds = 20;
        var round = 0;
        var modulo = monkeys.Select(x => x.Value).Aggregate(1L, (a, v) => a * v.Test);
        while (round++ < rounds)
        {
            foreach (var monkey in monkeys)
            {
                monkey.Value.Throw(monkeys, modulo);
            }
        }

        await Task.CompletedTask;
        return monkeys
            .Select(x => x.Value)
            .OrderByDescending(x => x.Inspections)
            .Take(2)
            .Aggregate(1L, (a, v) => a * v.Inspections)
            .ToString();
    }

    protected override async Task<string> SolvePartTwoAsync(IContext context)
    {
        var monkeys = ParseInput(context.Input, false);

        var rounds = 10000;
        var round = 0;
        var modulo = monkeys.Select(x => x.Value).Aggregate(1L, (a, v) => a * v.Test);
        while (round++ < rounds)
        {
            foreach (var monkey in monkeys)
            {
                monkey.Value.Throw(monkeys, modulo);
            }
        }

        await Task.CompletedTask;
        return monkeys
            .Select(x => x.Value)
            .OrderByDescending(x => x.Inspections)
            .Take(2)
            .Aggregate(1L, (a, v) => a * v.Inspections)
            .ToString();
    }
}
