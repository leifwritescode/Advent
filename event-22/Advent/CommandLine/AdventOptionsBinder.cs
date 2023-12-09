using Advent.Ornaments;
using System.CommandLine;
using System.CommandLine.Binding;

namespace Advent.CommandLine;

internal class AdventOptionsBinder : BinderBase<AdventOptions>
{
    private readonly Option<int> yearOption;
    private readonly Option<int> dayOption;
    private readonly Option<bool> dryRunOption;
    private readonly Option<bool> oneOption;

    public AdventOptionsBinder(Option<int> yearOption, Option<int> dayOption, Option<bool> dryRunOption, Option<bool> oneOption)
    {
        this.yearOption = yearOption;
        this.dayOption = dayOption;
        this.dryRunOption = dryRunOption;
        this.oneOption = oneOption;
    }

    protected override AdventOptions GetBoundValue(BindingContext bindingContext)
    {
        var year = bindingContext.ParseResult.GetValueForOption(yearOption);
        if (Math.Clamp(year, 2022, 2022) != year)
        {
            year = 2022;
        }

        var day = bindingContext.ParseResult.GetValueForOption(dayOption);
        if (Math.Clamp(day, 1, 25) != day)
        {
            var now = DateTime.Now;
            if (now.Month == 12 && Math.Clamp(now.Day, 1, 25) == now.Day)
            {
                day = now.Day;
            }
            else
            {
                day = 1;
            }
        }

        // only do stage two if --one is not specified
        Stage stages = Stage.One;
        if (!bindingContext.ParseResult.GetValueForOption(oneOption))
        {
            stages |= Stage.Two;
        }

        return new AdventOptions()
        {
            Year = year,
            Day = day,
            DryRun = bindingContext.ParseResult.GetValueForOption(dryRunOption),
            Stages = stages
        };
    }
}
