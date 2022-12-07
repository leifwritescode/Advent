using Advent.Ornaments;

namespace Advent.Contracts;

internal interface IAdventOptions
{
    int Day { get; init; }

    int Year { get; init; }

    bool DryRun { get; init; }

    Stage Stages { get; init; }
}
