using Advent;
using Advent.CommandLine;
using Advent.Contracts;
using Advent.Ornaments;
using Advent.Sleigh;
using Advent.Solutions;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System.CommandLine;

var yearOption = new Option<int>(name: "--year", "the challenge year"); 
var dayOption = new Option<int>("--day", "the challenge day");
var dryRunOption = new Option<bool>("--dry-run", "advent should not automatically submit responses");
var oneOption = new Option<bool>("--one", "advent should not automatically submit responses");

var rootCommand = new RootCommand
{
    yearOption,
    dayOption,
    dryRunOption,
    oneOption
};

rootCommand.SetHandler(async adventOptions =>
{
    var configuration = new ConfigurationBuilder()
        .SetBasePath(Directory.GetCurrentDirectory())
        .AddJsonFile("appsettings.json")
        .Build();

    var services = new ServiceCollection();

    var tokens = new TokenSettings();
    configuration.GetSection(TokenSettings.Section).Bind(tokens);
    ArgumentException.ThrowIfNullOrEmpty(tokens.Github);

    // Add new dependencies here
    services
         .AddLogging(logging =>
         {
             logging.AddConsole();
         })
        .AddTransient<ContextFactory>(sp => input => new Context(input))
        .AddSleigh(tokens.Github)
        .AddTransient<IInstrument, Instrument>()
        .AddTransient<IApp, App>();

    // Add new solutions here
    services
        .AddTransient<ISolution, CalorieCounting>()
        .AddTransient<ISolution, RockPaperScissors>()
        .AddTransient<ISolution, RucksackReorganisation>()
        .AddTransient<ISolution, CampCleanup>()
        .AddTransient<ISolution, SupplyStacks>()
        .AddTransient<ISolution, TuningTrouble>()
        .AddTransient<ISolution, NoSpaceLeftOnDevice>()
        .AddTransient<ISolution, TreetopTreeHouse>()
        .AddTransient<ISolution, CathodeRayTube>()
        .AddTransient<ISolution, MonkeyInTheMiddle>();

    var app = services
        .BuildServiceProvider()
        .GetRequiredService<IApp>();

    await app.RunAsync(adventOptions);
}, new AdventOptionsBinder(yearOption, dayOption, dryRunOption, oneOption));

await rootCommand.InvokeAsync(args);
