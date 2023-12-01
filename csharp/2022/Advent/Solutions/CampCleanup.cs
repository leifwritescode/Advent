using Advent.Contracts;
using Microsoft.Extensions.Logging;

namespace Advent.Solutions;

internal class CampCleanup : SolutionBase
{
    private class LineSegment
    {
        public int A { get; set; }
        public int B { get; set; }

        public bool Contains(LineSegment other)
        {
            return A <= other.A && B >= other.B;
        }

        public bool Overlaps(LineSegment other)
        {
            return (A <= other.A && other.A <= B) || (A <= other.B && other.B <= B);
        }
    }

    public CampCleanup(ILogger<CampCleanup> logger, IInstrument instrument)
        : base(logger, instrument, 4)
    {
    }

    protected override async Task<string> SolvePartOneAsync(IContext context)
    {
        var assignments = context.Input
            .Trim()
            .ReplaceLineEndings()
            .Split(Environment.NewLine)
            .Select(x =>
            {
                var pair = x.Split(",");
                var line1 = pair.First().Split("-");
                var line2 = pair.Last().Split("-");
                return new
                {
                    A = new LineSegment() { A = int.Parse(line1.First()), B = int.Parse(line1.Last()) },
                    B = new LineSegment() { A = int.Parse(line2.First()), B = int.Parse(line2.Last()) }
                };
            });

        var count = assignments.Count(x => x.A.Contains(x.B) || x.B.Contains(x.A));
        return await Task.FromResult($"{count}");
    }

    protected override async Task<string> SolvePartTwoAsync(IContext context)
    {
        var assignments = context.Input
            .Trim()
            .ReplaceLineEndings()
            .Split(Environment.NewLine)
            .Select(x =>
            {
                var pair = x.Split(",");
                var line1 = pair.First().Split("-");
                var line2 = pair.Last().Split("-");
                return new
                {
                    A = new LineSegment() { A = int.Parse(line1.First()), B = int.Parse(line1.Last()) },
                    B = new LineSegment() { A = int.Parse(line2.First()), B = int.Parse(line2.Last()) }
                };
            });

        var count = assignments.Count(x => x.A.Overlaps(x.B) || x.B.Overlaps(x.A));
        return await Task.FromResult($"{count}");
    }
}
