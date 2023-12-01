using Advent.Contracts;
using Advent.Ornaments;
using Microsoft.Extensions.Logging;
using System.Text.RegularExpressions;

namespace Advent;

internal abstract class SolutionBase : ISolution
{
    private static readonly Regex camelCaseSplit = new Regex(@"(?<=[A-Z])(?=[A-Z][a-z]) |(?<=[^A-Z])(?=[A-Z])|(?<=[A-Za-z])(?=[^A-Za-z])", RegexOptions.IgnorePatternWhitespace | RegexOptions.Compiled);

    private readonly IInstrument instrument;
    protected readonly ILogger logger;

    public int Day { get; init; }

    public SolutionBase(ILogger logger, IInstrument instrument, int day)
    {
        this.logger = logger;
        this.instrument = instrument;

        Day = day;
    }

    protected abstract Task<string> SolvePartOneAsync(IContext context);

    protected abstract Task<string> SolvePartTwoAsync(IContext context);

    public async IAsyncEnumerable<string> SolveAsync(IContext context)
    {
        logger.LogInformation($"{string.Join(" ", camelCaseSplit.Split(GetType().Name))}");

        if (context.Stages.HasFlag(Stage.One))
        {
            var measured = instrument.Measure(SolvePartOneAsync, context);
            context.Response = await measured;
            yield return context.Response;
        }

        if (context.Stages.HasFlag(Stage.Two))
        {
            var measured = instrument.Measure(SolvePartTwoAsync, context);
            context.Response = await measured;
            yield return context.Response;
        }
    }
}
