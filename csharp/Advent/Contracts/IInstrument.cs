namespace Advent.Contracts;

internal interface IInstrument
{
    Task<TResult> Measure<TResult>(Measurable<TResult> func, IContext context);
}

internal delegate Task<TResult> Measurable<TResult>(IContext context);
