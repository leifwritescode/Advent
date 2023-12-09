using Advent.Contracts;
using Advent.Ornaments;

namespace Advent.Test;

internal sealed class FakeContext : IContext
{
    public string Input { get; init; } = string.Empty;
    public Stage Stages { get; set; }
    public string? Response { get; set; }
}
