using Advent.Contracts;
using Microsoft.Extensions.Logging;

namespace Advent;

/// <summary>
/// Provides basic instrumentation for a block of code.
/// </summary>
internal class Instrument : IInstrument
{
    private readonly ILogger<Instrument> logger;

    public Instrument(ILogger<Instrument> logger)
    {
        this.logger = logger;
    }

    public async Task<TResult> Measure<TResult>(Measurable<TResult> subjectUnderMeasurement, IContext context)
    {
        var utcThen = DateTime.UtcNow;
        var result = await subjectUnderMeasurement(context);
        var utcNow = DateTime.UtcNow;
        var delta = utcNow - utcThen;
        logger.LogInformation($"Subject execution took {delta.TotalMilliseconds} milliseconds");
        return result;
    }
}
