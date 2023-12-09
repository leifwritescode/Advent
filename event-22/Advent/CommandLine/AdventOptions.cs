using Advent.Contracts;
using Advent.Ornaments;

namespace Advent.CommandLine;

internal class AdventOptions : IAdventOptions
{
    public int Year { get; init; }

    public int Day { get; init; }

    public bool DryRun { get; init; }

    public Stage Stages { get; init; }
}
