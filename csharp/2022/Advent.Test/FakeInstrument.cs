using Advent.Contracts;

namespace Advent.Test;

internal sealed class FakeInstrument : IInstrument
{
    public async Task<TResult> Measure<TResult>(Measurable<TResult> subjectUnderMeasurement, IContext context)
    {
        return await subjectUnderMeasurement(context);
    }
}
