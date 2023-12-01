using Advent.Contracts;
using Advent.Ornaments;
using Microsoft.Extensions.Logging;
using System.Text.RegularExpressions;

namespace Advent.Solutions;

internal class Instruction
{
    private string instruction;

    public Instruction(string instruction)
    {
        this.instruction = instruction;
    }

    public IEnumerable<int> Execute(Cpu cpu)
    {
        if (instruction.Equals("noop"))
        {
            yield return 1;
        }
        else if (instruction.StartsWith("addx "))
        {
            yield return 2;
            cpu.X += int.Parse(instruction.Substring("addx ".Length));
        }
        yield break;
    }
}

internal class Cpu
{
    public int X { get; set; } = 1;
    public int ProgramCounter { get; private set; } = 1;

    private IEnumerable<Instruction> instructions;

    public Cpu(string[] memory)
    {
        instructions = memory.Select(x => new Instruction(x));
    }

    public IEnumerable<int> Run()
    {
        foreach (var instruction in instructions)
        {
            foreach (var cycle in instruction.Execute(this))
            {
                for (var i = 0; i < cycle; i++)
                {
                    yield return ProgramCounter++;
                }
            }
        }
        yield return ProgramCounter;
    }
}

internal class CathodeRayTube : SolutionBase
{
    public CathodeRayTube(ILogger<CathodeRayTube> logger, IInstrument instrument)
        : base(logger, instrument, 10)
    {
    }

    protected override async Task<string> SolvePartOneAsync(IContext context)
    {
        var instructions = context.Input.PreProcessLines();

        var cpu = new Cpu(instructions);
        var acc = 0;

        foreach (var cycle in cpu.Run())
        {
            if (cycle > 220) break;
            else if (cycle is >= 20 && ((cycle - 20) % 40) is 0)
            {
                acc += cycle * cpu.X;
            }
        }

        await Task.CompletedTask;
        return acc.ToString();
    }

    protected override async Task<string> SolvePartTwoAsync(IContext context)
    {
        var instructions = context.Input.PreProcessLines();

        var cpu = new Cpu(instructions);
        var screenW = 40;
        var screenH = 6;
        var buffer = new char[screenH][];

        foreach (var cycle in cpu.Run())
        {
            var y = Math.DivRem(cycle - 1, screenW, out var x);
            if (x >= cpu.X - 1 && x <= cpu.X + 1)
            {
                if (buffer[y] is null)
                {
                    buffer[y] = new char[screenW];
                    Array.Fill(buffer[y], '.');
                }

                buffer[y][x] = '#';
            }
        }

        var result = string.Join(Environment.NewLine, buffer.Select(x => new string(x)));
        logger.LogWarning("this task requires manual submission of the below text");
        logger.LogWarning(result);


        await Task.CompletedTask;
        return result;
    }
}
