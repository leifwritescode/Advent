namespace Advent.Contracts;

internal interface IApp
{
    Task RunAsync(IAdventOptions args);
}
