using Advent.Ornaments;

namespace Advent.Contracts;

internal interface IContext
{
    /// <summary>
    /// The challenge input string.
    /// </summary>
    string Input { get; init; }

    /// <summary>
    /// Which stages should be executed.
    /// </summary>
    Stage Stages { get; set; }

    /// <summary>
    /// The response from a challenge stage.
    /// </summary>
    string? Response { get; set; }
}

internal delegate IContext ContextFactory(string input);
