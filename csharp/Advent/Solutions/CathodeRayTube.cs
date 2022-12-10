using Advent.Contracts;
using Advent.Ornaments;
using Microsoft.Extensions.Logging;

namespace Advent.Solutions;

internal class CathodeRayTube : SolutionBase
{
    public CathodeRayTube(ILogger<CathodeRayTube> logger, IInstrument instrument)
        : base(logger, instrument, 10)
    {
    }

    private IEnumerable<int> AddX(int x, int v)
    {
        yield return x;
        yield return x + v;
    }

    private IEnumerable<int> Noop(int x, int v)
    {
        yield return x;
    }

    protected override async Task<string> SolvePartOneAsync(IContext context)
    {
        var pc = 0;
        var reg = 1;
        var acc = 0;
        var v = 0;
        var line = string.Empty;
        Func<int, int, IEnumerable<int>> func;
        var instructions = context.Input.PreProcessLines();
        var enumerator = instructions.GetEnumerator();

        while (enumerator.MoveNext())
        {
            line = (string)enumerator.Current;
            if (line.StartsWith("addx "))
            {
                func = AddX;
                v = line["addx ".Length..].ToInt();
            }
            else
            {
                func = Noop;
            }

            foreach(var result in func(reg, v))
            {
                pc++;
                if (pc == 20 || (pc - 20) % 40 == 0)
                {
                    acc += pc * reg;
                }
                reg = result;
            }
        }

        await Task.CompletedTask;
        return acc.ToString();
    }

    protected override async Task<string> SolvePartTwoAsync(IContext context)
    {
        await Task.CompletedTask;
        return "";
    }
}
