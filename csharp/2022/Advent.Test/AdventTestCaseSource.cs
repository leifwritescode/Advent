namespace Advent.Test;

internal class AdventTestCaseSource : IAdventTestCaseSource
{
    public string Input { get; init; }

    public string[] Responses { get; init; }

    public AdventTestCaseSource(string input, string[] responses)
    {
        Input = input;
        Responses = responses;
    }
}
