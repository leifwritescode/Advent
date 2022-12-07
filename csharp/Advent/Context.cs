using Advent.Contracts;
using Advent.Ornaments;

namespace Advent;

internal class Context : IContext
{
    public string Input { get; init; }

    public Stage Stages { get; set; }

    public string? Response { get; set; }

    public Context(string input)
    {
        Input = input;
        Stages = Stage.One | Stage.Two;
    }

    public IEnumerable<char> InputAsCharacters()
    {
        return Input.ToCharArray();
    }
}
