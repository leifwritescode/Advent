namespace Advent.Contracts;

internal interface ISolution
{
    int Day { get; }

    IAsyncEnumerable<string> SolveAsync(IContext context);
}
