namespace Advent.Test
{
    internal interface IAdventTestCaseSource
    {
        string Input { get; }

        string[] Responses { get; }
    }
}
