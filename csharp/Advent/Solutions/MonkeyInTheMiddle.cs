using Advent.Contracts;
using Microsoft.Extensions.Logging;

namespace Advent.Solutions;

internal sealed class MonkeyInTheMiddle : SolutionBase
{
    private sealed class Monkey
    {
        private readonly Queue<long> items;
        private readonly Func<long, long> operation;
        private readonly int outcomeIfTrue;
        private readonly int outcomeIfFalse;
        private readonly bool relief;

        public long Inspections { get; private set; } = 0;
        public long Test { get; }

        public Monkey(Func<long, long> operation, long test, int outcomeIfTrue, int outcomeIfFalse, bool relief, params long[] items)
        {
            this.operation = operation;
            this.items = new Queue<long>(items);
            Test = test;
            this.outcomeIfTrue = outcomeIfTrue;
            this.outcomeIfFalse = outcomeIfFalse;
            this.relief = relief;
        }

        public void Throw(IDictionary<int, Monkey> monkeys, long modulo)
        {
            while (items.Any())
            {
                var item = items.Dequeue();
                var worry = operation(item);
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

    protected override async Task<string> SolvePartOneAsync(IContext context)
    {
        var monkeys = new Dictionary<int, Monkey>()
        {
            { 0, new Monkey(v => v * 3, 5, 2, 7, true, 78, 53, 89, 51, 52, 59, 58, 85) },
            { 1, new Monkey(v => v + 7, 2, 3, 6, true, 64) },
            { 2, new Monkey(v => v + 5, 13, 5, 4, true, 71, 93, 65, 82) },
            { 3, new Monkey(v => v + 8, 19, 6, 0, true, 67, 73, 95, 75, 56, 74) },
            { 4, new Monkey(v => v + 4, 11, 3, 1, true, 85, 91, 90) },
            { 5, new Monkey(v => v * 2, 3, 4, 1, true, 67, 96, 69, 55, 70, 83, 62) },
            { 6, new Monkey(v => v + 6, 7, 7, 0, true, 53, 86, 98, 70, 64) },
            { 7, new Monkey(v => v * v, 17, 2, 5, true, 88, 64) },
        };

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
        var monkeys = new Dictionary<int, Monkey>()
        {
            { 0, new Monkey(v => v * 3, 5, 2, 7, false, 78, 53, 89, 51, 52, 59, 58, 85) },
            { 1, new Monkey(v => v + 7, 2, 3, 6, false, 64) },
            { 2, new Monkey(v => v + 5, 13, 5, 4, false, 71, 93, 65, 82) },
            { 3, new Monkey(v => v + 8, 19, 6, 0, false, 67, 73, 95, 75, 56, 74) },
            { 4, new Monkey(v => v + 4, 11, 3, 1, false, 85, 91, 90) },
            { 5, new Monkey(v => v * 2, 3, 4, 1, false, 67, 96, 69, 55, 70, 83, 62) },
            { 6, new Monkey(v => v + 6, 7, 7, 0, false, 53, 86, 98, 70, 64) },
            { 7, new Monkey(v => v * v, 17, 2, 5, false, 88, 64) },
        };

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
