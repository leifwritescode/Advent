using Ornaments.App;

namespace Advent;

internal class Program
{
    static async Task Main(string[] args)
    {
        await OrnamentsApp.CreateDefault().RunAsync(args);
    }
}